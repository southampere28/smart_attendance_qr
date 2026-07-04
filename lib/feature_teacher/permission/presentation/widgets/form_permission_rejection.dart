import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:flutter/material.dart';

class FormPermissionRejection extends StatefulWidget {
  const FormPermissionRejection({super.key, required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<FormPermissionRejection> createState() =>
      _FormPermissionRejectionState();
}

class _FormPermissionRejectionState extends State<FormPermissionRejection> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                SpacingSize.spacingSMWidth,
                Expanded(
                  child: Text(
                    'Form Penolakan',
                    style: AppFontStyle.primaryText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SpacingSize.spacingSMWidth,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ],
            ),
            SpacingSize.spacingBaseHeight,
            Text(
              'Alasan Penolakan',
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SpacingSize.spacingBaseHeight,
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Alasan penolakan...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SpacingSize.spacingBaseHeight,
            Row(
              children: [
                Expanded(
                  child: ButtonPrimaryWidget(
                    title: 'Batal',
                    isOutlineButton: true,
                    customColor: AppColor.colorAlpha,
                    callback: () => Navigator.of(context).pop(),
                  ),
                ),
                SpacingSize.spacingSMWidth,
                Expanded(
                  child: ButtonPrimaryWidget(
                    title: 'Tolak',
                    customColor: AppColor.errorColor,
                    callback: () {
                      final reason = _reasonController.text.trim();
                      Navigator.of(context).pop();
                      widget.onSubmit(reason);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
