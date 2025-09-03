import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrController extends GetxController {
  late MobileScannerController scannerController;

  final _isScanCompleted = false.obs;

  bool get isScanCompleted => _isScanCompleted.value;

  set isScanCompleted(bool value) {
    print('Status scan diubah dari ${_isScanCompleted.value} menjadi $value');
    _isScanCompleted.value = value;
  }
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scannerController =
        MobileScannerController(facing: CameraFacing.back, torchEnabled: false);
  }
}