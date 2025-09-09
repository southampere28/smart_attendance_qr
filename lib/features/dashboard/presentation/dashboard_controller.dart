import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{
  final EndpointService _httpService = Get.find<EndpointService>();

  var isConnected = false.obs;

  Future<void> checkConnection() async {
    isConnected.value = await _httpService.testConnection();
  }
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}