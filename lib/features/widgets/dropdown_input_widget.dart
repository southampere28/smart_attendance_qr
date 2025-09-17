import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class DropdownInputWidget extends StatelessWidget {
  const DropdownInputWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.readOnly = false,
  });

  final String title;
  final String? selected;
  final List<String> items;
  final String hint;
  final void Function(String?)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFontStyle.primaryText),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.inactiveColor, width: 2.0),
            color: readOnly ? Colors.grey[300] : Colors.grey[200],
          ),
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                disabledColor: AppFontStyle.primaryText.color, // biar nggak abu
              ),
              child: DropdownButton<String>(
                value: items.contains(selected) ? selected : null,
                hint: Text(
                  hint,
                  style: AppFontStyle.primaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: AppFontStyle.primaryText,
                onChanged: readOnly ? null : onChanged,
                items: items.map(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          value,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: AppFontStyle.primaryText, // <-- biar teks-nya gak jadi abu
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
