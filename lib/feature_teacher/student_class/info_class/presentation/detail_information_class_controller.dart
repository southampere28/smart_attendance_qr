import 'dart:developer';

import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/model_merging/class_info_item.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DetailInformationClassController extends GetxController {
  // services controller
  final EndpointService _endpointService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();

  // state
  final RxBool isLoading = false.obs;

  // data class detail information with student
  final Rx<ClassInfoItem?> classInfo = Rx<ClassInfoItem?>(null);

  // field dropwdown class selection
  // flag for selected class id
  BigInt selectedClassId = BigInt.from(-1);
  // dropdown items for class selection
  var selectedItem = '(Pilih Kelas)'.obs;
  RxList<ClassModel> classDataList = RxList<ClassModel>([]);
  var classItemList = ['(Pilih Kelas)'].obs;
  var classMap = <String, BigInt>{}.obs;

  @override
  void onInit() {
    super.onInit();
    scrapStudentClases().then((success) {
      if (success) {
        getKelasItem();
      }
    });
  }

  // === SERVICE ZONE ===
  // future function to get detail information of a class
  Future<void> fetchDetailClass(String classId) async {
    isLoading.value = true;

    final result = await _endpointService.detailInformationClass(classId);

    if (result.success) {
      final data = result.data;

      if (data != null) {
        final classInformation = ClassInfoItem.fromMap(data);
        classInfo.value = classInformation;
        Fluttertoast.showToast(msg: 'Data detail kelas berhasil dimuat');
      } else {
        classInfo.value = null;
        Fluttertoast.showToast(msg: 'Data detail kelas tidak ditemukan');
      }
    } else {
      classInfo.value = null;
      Fluttertoast.showToast(msg: 'Gagal memuat data detail kelas');
    }
    isLoading.value = false;
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
      final result = await _endpointService.loadClasses();

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
