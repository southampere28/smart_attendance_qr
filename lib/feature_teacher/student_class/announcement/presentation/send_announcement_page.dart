import 'dart:developer';

import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/student_class/announcement/presentation/send_announcement_controller.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textarea_with_title.dart';
import 'package:absensi_qr/features/widgets/textfield_with_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendAnnouncementPage extends StatelessWidget {
  const SendAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SendAnnouncementController>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Buat Pengumuman"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpacingSize.spacingBaseHeight,
              Obx(() => DropdownInputWidget(
                      title: 'Kelas',
                      selected: controller.selectedItem.value,
                      items: controller.classItemList.toList(),
                      onChanged: (value) {
                        // do something
                        controller.selectedItem.value =
                            value ?? '(Pilih Kelas)';

                        if (value != null && value != '(Pilih Kelas)') {
                          final selectedId = controller.classMap[value];
                          log('Selected: $value, ID: $selectedId');
                          controller.selectedId = selectedId!;
                        } else {
                          controller.selectedId = BigInt.from(-1);
                        }
                      },
                      hint: '(Pilih Kelas)')),
              SpacingSize.spacingBaseHeight,
              TextfieldWithTitle(
                  title: 'Judul Pengumuman',
                  controller: controller.titleController,
                  hintTxt: 'Masukkan judul pengumuman',
                  keyboardType: TextInputType.text),
              SpacingSize.spacingBaseHeight,
              TextareaWithTitle(
                title: 'Isi Pengumuman',
                controller: controller.contentAnnouncementController,
                hintTxt:
                    'Masukkan isi pengumuman, pastikan untuk menyampaikan informasi dengan jelas dan lengkap.',
                keyboardType: TextInputType.text,
                minLines: 4,
                maxLines: 5,
              ),
            ],
          ),
        ));
  }
}
