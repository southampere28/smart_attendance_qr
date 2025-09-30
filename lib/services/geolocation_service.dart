import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:absensi_qr/models/geolocation/position_item.dart';

class GeolocationService extends GetxService {
  // do something here
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<PositionItem> _positionItems = <PositionItem>[];
  // service subscription for listener
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  // flag fetch location
  bool _hasFetchedLocation = false;

  String serviceStatusValue = 'disabled';

  String? lattitude = '';
  String? longitude = '';

  // placemark value =====================
  var outputPlacemark = ''.obs;
  var placemarkResult = Rxn<Placemark?>();

  // =====================================

  Future<bool> getCurrentPosition(int limitSecond) async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return false;
    }

    Fluttertoast.showToast(msg: 'mencoba mendapatkan lokasi...');

    try {
      final position = await _geolocatorPlatform.getCurrentPosition(
          locationSettings:
              LocationSettings(timeLimit: Duration(seconds: limitSecond)));

      _updatePositionList(
        PositionItemType.position,
        position.toString(),
      );

      lattitude = position.latitude.toString();
      longitude = position.longitude.toString();

      log('lat: $lattitude, long: $longitude');

      // Fluttertoast.showToast(
      //   msg: "Lokasi: ${position.latitude}, ${position.longitude}",
      //   toastLength: Toast.LENGTH_LONG,
      // );

      Fluttertoast.showToast(msg: "lokasi telah di update");

      if ((lattitude != '') &&
          (longitude != '')) {
        await placemarkLocation(
            lattitude!, longitude!);
      } else {
        Fluttertoast.showToast(msg: 'gagal mendapatkan alamat!');
      }

      return true;
    } on TimeoutException {
      log("Timeout: lokasi tidak bisa didapatkan dalam $limitSecond detik");
      Fluttertoast.showToast(
          msg: "Gagal dapat lokasi (timeout $limitSecond detik)");
      return false;
    } catch (e) {
      log("Error getCurrentPosition: $e");
      Fluttertoast.showToast(msg: "Gagal dapat lokasi: $e");
      return false;
    }
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await _geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _updatePositionList(PositionItemType.log, _kPermissionDeniedMessage);
        Fluttertoast.showToast(
            msg: _kPermissionDeniedMessage, toastLength: Toast.LENGTH_LONG);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _updatePositionList(
          PositionItemType.log, _kPermissionDeniedForeverMessage);
      Fluttertoast.showToast(
          msg: _kPermissionDeniedForeverMessage,
          toastLength: Toast.LENGTH_LONG);
      return false;
    }

    return true;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Fluttertoast.showToast(
        msg: "GPS belum aktif, aktifkan dulu!",
        toastLength: Toast.LENGTH_LONG,
      );

      _updatePositionList(
        PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      await AppSettings.openAppSettings(type: AppSettingsType.location);

      return false;
    }

    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) return false;

    _updatePositionList(PositionItemType.log, _kPermissionGrantedMessage);
    return true;
  }

  void _updatePositionList(PositionItemType type, String displayValue) {
    _positionItems.add(PositionItem(type, displayValue));
  }

  Future<void> waitForGpsEnabled(
      {int maxRetries = 5, Duration delay = const Duration(seconds: 2)}) async {
    // Pastikan listener aktif
    listenGpsStatus();

    int retries = 0;

    while (serviceStatusValue != 'enabled' && retries < maxRetries) {
      log("GPS masih disabled, retry ke-$retries...");
      await Future.delayed(delay);
      if (retries == 1) {
        Fluttertoast.showToast(msg: 'Mohon Nyalakan GPS!');
      }
      if (retries == 4) {
        Fluttertoast.showToast(msg: 'Mengalihkan ke pengaturan lokasi...');
      }
      retries++;
    }

    if (serviceStatusValue != 'enabled') {
      throw Exception("GPS masih disabled setelah $maxRetries percobaan");
    }

    if (_hasFetchedLocation != true) {
      await getCurrentPosition(15);
    }
  }

  void stopListening() {
    _serviceStatusStreamSubscription?.cancel();
    _serviceStatusStreamSubscription = null;
    log("GPS listener dihentikan");
  }

  void listenGpsStatus() async {
    bool isEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    serviceStatusValue = isEnabled ? 'enabled' : 'disabled';

    if (isEnabled) {
      _hasFetchedLocation = true;
      await getCurrentPosition(15);
    }

    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen(
        (serviceStatus) {
          if (serviceStatus == ServiceStatus.enabled && !_hasFetchedLocation) {
            serviceStatusValue = 'enabled';
            // stopListening();
            _hasFetchedLocation = true;
            getCurrentPosition(15);
          } else {
            serviceStatusValue = 'disabled';
            _hasFetchedLocation = false;
          }
          _updatePositionList(
            PositionItemType.log,
            'Location service has been $serviceStatusValue',
          );
        },
      );
    }
  }

  Future<void> placemarkLocation(String lat, String lon) async {
    var convertedLat = double.parse(lat);
    var convertedLon = double.parse(lon);

    await placemarkFromCoordinates(convertedLat, convertedLon)
        .then((placemarks) {
      if (placemarks.isNotEmpty) {
        outputPlacemark.value = placemarks[0].toString();
        placemarkResult.value = placemarks[0];
      }
    });
  }

  // initialize
  Future<GeolocationService> init() async {
    // inisialisasi token etc...
    return this;
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}
