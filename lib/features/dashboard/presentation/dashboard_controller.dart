import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  var isConnected = false.obs;

  Future<void> checkConnection() async {
    isConnected.value = await _httpService.testConnection();
  }

  // geolocation
  Future<void> getLocation() async {
    await _geolocationService.getCurrentPosition(30);
    // await getPlacemarkLocation();
  }

  String get placemark => _geolocationService.outputPlacemark.value;

  // kota
  String get placemarkCity => _geolocationService.placemarkResult.value?.subAdministrativeArea ?? '(No Data)';

  // kecamatan
  String get placemarkLocality => _geolocationService.placemarkResult.value?.locality ?? '(No Data)';
  
  // desa
  String get placemarkVillage => _geolocationService.placemarkResult.value?.subLocality ?? '(No Data)';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
