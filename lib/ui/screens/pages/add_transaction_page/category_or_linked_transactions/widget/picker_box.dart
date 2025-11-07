import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

class PickerBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accentColor;

  const PickerBox({
    super.key,
    required this.label,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(context, 'primary1'),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.getThemeColor(context, 'secondary2')),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary'))),
          Icon(icon, color: accentColor),
        ],
      ),
    );
  }
}
