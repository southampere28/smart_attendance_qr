import 'dart:developer';
import 'dart:ffi';
import 'package:absensi_qr/domain/enum/announcement_type_enum.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SendAnnouncementController extends GetxController {
  // service
  final EndpointService endpointService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();

  // data target
  int? classId;

  // dropdown input class
  var selectedItem = '(Pilih Kelas)'.obs;
  BigInt selectedId = BigInt.from(-1);
  RxList<ClassModel> classDataList = RxList<ClassModel>([]);
  var classItemList = ['(Pilih Kelas)'].obs;

  var classMap = <String, BigInt>{}.obs;

  // dropdown input type
  var selectedType = 'Batalkan Kelas'.obs;

  // form field
  final titleController = TextEditingController();
  final contentAnnouncementController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    final classIdArg = arguments != null && arguments is Map<String, dynamic>
        ? arguments['classId']
        : null;

    log('Received arguments: $arguments');

    if (arguments != null &&
        arguments is Map<String, dynamic> &&
        classIdArg != null) {
      final classId = arguments['classId'];
      log('Received classId: $classId');
      this.classId = int.tryParse(classId.toString());
      _initializeClasses();
    } else {
      log('No valid arguments received, proceeding without pre-selected class');
      _initializeClasses();
    }
  }

  Future<void> _initializeClasses() async {
    final success = await scrapStudentClases();
    if (success) {
      getKelasItem();
    }
    // select the class if classId is provided
    if (classId != null) {
      final classModel = classDataList.firstWhere(
        (c) => c.id == BigInt.from((classId)!),
      );
      if (classModel.id != BigInt.from(-1)) {
        selectedItem.value = classModel.name;
        selectedId = classModel.id;
        log('Pre-selected class: ${classModel.name} with ID: ${classModel.id}');
      } else {
        log('Class with ID $classId not found in classDataList');
      }
    }
  }

  // function to get item list
  void getKelasItem() {
    // Use reactive classDataList instead of global service data
    if (classDataList.isNotEmpty) {
      // Build new list to trigger reactivity
      final newItems = ['(Pilih Kelas)'];
      classMap.clear();

      for (var i = 0; i < classDataList.length; i++) {
        final name = classDataList[i].name;
        final id = classDataList[i].id;

        newItems.add(name);
        classMap[name] = id;
      }

      // Assign once to trigger Obx update
      classItemList.value = newItems;
      log('Class map updated: ${classMap.toString()}');
      log('Dropdown items: ${classItemList.length} items');
    } else {
      log('classDataList is empty!');
    }
  }

  // Fetch classes from API with cache support
  Future<bool> scrapStudentClases({bool forceRefresh = false}) async {
    try {
      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cachedClasses = await _cacheService.loadCachedClasses();
        if (cachedClasses != null) {
          classDataList.value = cachedClasses;
          return true;
        }
      }

      // Fetch from API
      final result = await endpointService.loadClasses();

      if (result.success && result.data != null) {
        // Update reactive list
        classDataList.value = result.data!;

        // Save to cache
        await _cacheService.saveCachedClasses(result.data!);

        log('Classes loaded from API: ${classDataList.length}');
        return true;
      } else {
        log('Failed to load classes: ${result.message}');
        Fluttertoast.showToast(msg: result.message ?? 'Failed to load classes');
        return false;
      }
    } catch (e) {
      log('Error loading classes: $e');
      Fluttertoast.showToast(msg: 'Error loading classes');
      return false;
    }
  }

  // send announcement to backend
  Future<void> sendAnnouncement() async {
    if (Get.context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context != null) {
          AppUtil.showLoadingDialog(Get.context!,
              message: 'Mengirim pengumuman...');
        }
      });
    }

    if (selectedId == BigInt.from(-1)) {
      Fluttertoast.showToast(msg: 'Pilih kelas terlebih dahulu');
      if (Get.context != null) {
        AppUtil.hideLoadingDialog(Get.context!);
      }
      return;
    }
    if (contentAnnouncementController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Isi pengumuman tidak boleh kosong');
      if (Get.context != null) {
        AppUtil.hideLoadingDialog(Get.context!);
      }
      return;
    }

    final result = await endpointService.sendAnnouncement(
      title: titleController.text,
      message: contentAnnouncementController.text,
      idClass: selectedId.toString(),
      type: AnnouncementTypeEnum.values.firstWhere(
          (e) => e.title == selectedType.value,
          orElse: () => AnnouncementTypeEnum.classCancelled),
    );
    if (Get.context != null) {
      AppUtil.hideLoadingDialog(Get.context!);
    }

    if (result.success) {
      Fluttertoast.showToast(msg: 'Pengumuman berhasil dikirim');
      Get.back();
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'Gagal mengirim pengumuman');
    }
  }
}
