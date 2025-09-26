import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
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
  bool positionStreamStarted = false;

  String? lattitude = '';
  String? longitude = '';

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      PositionItemType.position,
      position.toString(),
    );

    lattitude = position.latitude.toString();
    longitude = position.longitude.toString();

    log('lat: $lattitude, long: $longitude');

    Fluttertoast.showToast(
      msg: "Lokasi: ${position.latitude}, ${position.longitude}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

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

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        Fluttertoast.showToast(
          msg: _kPermissionDeniedMessage,
          toastLength: Toast.LENGTH_LONG,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      Fluttertoast.showToast(
        msg: _kPermissionDeniedForeverMessage,
        toastLength: Toast.LENGTH_LONG,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(PositionItemType type, String displayValue) {
    _positionItems.add(PositionItem(type, displayValue));
  }

  // initialize
  Future<GeolocationService> init() async {
    // inisialisasi token etc...
    return this;
  }
}
