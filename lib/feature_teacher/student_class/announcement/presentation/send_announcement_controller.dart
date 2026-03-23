import 'dart:developer';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
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

  // form field
  final titleController = TextEditingController();
  final contentAnnouncementController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    log('Received arguments: $arguments');
    if (arguments != null && arguments is Map<String, dynamic>) {
      final classId = arguments['classId'];
      log('Received classId: $classId');
      this.classId = classId;
    }
    _initializeClasses();
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


}