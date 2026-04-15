


import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:flutter/material.dart';

class FormPermissionRejection extends StatelessWidget {
  const FormPermissionRejection({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tolak Perizinan',
              style: AppFontStyle.titleText,
            ),
            SpacingSize.spacingBaseHeight,
            Text(
              'Apakah Anda yakin ingin menolak perizinan ini?',
              style: AppFontStyle.primaryText,
              textAlign: TextAlign.center,
            ),
            SpacingSize.spacingBaseHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tolak'),
                ),
              ],
            )]))
            
    );
  }
}