import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterStudentController extends GetxController {
  final EndpointService endpointService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();

  var isLoading = false.obs;

  // variable texteditingcontroller name, email, pass, etc...
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var confirmPassController = TextEditingController();
  var nisnController = TextEditingController();
  var idClassController = TextEditingController();
  var entryYearController = TextEditingController();

  // flag password visibility
  var isPassObscure = true.obs;
  var isConfirmPassObscure = true.obs;

  var selectedItem = '(Pilih Kelas)'.obs;

  BigInt selectedId = BigInt.from(-1);

  RxList<ClassModel> classDataList = RxList<ClassModel>([]);

  var classItemList = ['(Pilih Kelas)'].obs;

  var classMap = <String, BigInt>{}.obs;

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

  // Force refresh classes (ignore cache)
  Future<void> refreshClasses() async {
    log('Force refreshing classes...');
    await scrapStudentClases(forceRefresh: true);
    getKelasItem();
  }

  // validate all field before register
  void validateAndSubmit(BuildContext context, String name, String email, String password, String confirmPassword,
      String nisn, int idClass, int entryYear) {
    // validate form
    if (name.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi nama lengkap');
      return;
    } 
    if (email.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi email');
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi kata sandi');
      return;
    }
    if (confirmPassController.text.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi konfirmasi kata sandi');
      return;
    }
    if (nisn.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi NISN');
      return;
    }
    if (idClass == -1) {
      Get.snackbar('Error', 'Silahkan pilih kelas');
      return;
    }
    if (entryYear <= 0) {
      Get.snackbar('Error', 'Silahkan isi tahun masuk yang valid');
      return;
    }
    if (password != confirmPassController.text) {
      Get.snackbar('Error', 'Kata sandi dan konfirmasi kata sandi tidak cocok');
      return;
    }

    // submit form
    doRegister(context, name, email, password, confirmPassword, nisn, idClass, entryYear);
  
  }

  // function to register
  Future<void> doRegister(BuildContext context, String name, String email,
      String password, String confirmPassword, String nisn, int idClass, int entryYear) async {
    isLoading.value = true;
    AppUtil.showLoadingDialog(context, message: "Register in process...");

    try {
      final result = await endpointService.registerStudent(
          name: name,
          email: email,
          password: password,
          nisn: nisn,
          idClass: idClass,
          entryYear: entryYear);

      isLoading.value = false;

      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }

      var msg = result.message ?? 'Register Fail!';

      if (result.success && result.data != null) {
        log("Token: ${endpointService.accessToken}");
        log("User registered: ${result.data!.email}");
        log("User role: ${result.data!.role}");
        Get.offNamed(AppRoutes.login);
        Fluttertoast.showToast(msg: msg);
      } else {
        if (result.errors != null) {
          result.errors!.forEach((field, messages) {
            log("Field: $field, Messages: $messages");
            // bisa tampilkan toast per field
            Fluttertoast.showToast(msg: "${messages[0]}");
          });
        } else {
          Fluttertoast.showToast(msg: msg);
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Error 500!');
      log('error while register : $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load classes and populate dropdown
    _initializeClasses();
  }

  Future<void> _initializeClasses() async {
    final success = await scrapStudentClases();
    if (success) {
      getKelasItem();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    nisnController.dispose();
    idClassController.dispose();
    entryYearController.dispose();
    super.onClose();
  }
}
