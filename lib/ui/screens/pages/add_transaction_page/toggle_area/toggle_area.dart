import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

class ToggleArea extends StatelessWidget {
  final bool superSetting;
  final bool isTemporary;
  final Color accentColor;
  final Function(bool) onSuperSettingChanged;
  final Function(bool) onTemporaryChanged;

  const ToggleArea({
    super.key,
    required this.superSetting,
    required this.isTemporary,
    required this.accentColor,
    required this.onSuperSettingChanged,
    required this.onTemporaryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Super Setting
          _buildToggle(
            context: context,
            label: 'Super Setting',
            value: superSetting,
            onChanged: onSuperSettingChanged,
            accentColor: accentColor,
          ),

          // Temporary (always visible, disabled if superSetting is true)
          _buildToggle(
            context: context,
            label: 'Temporary',
            value: isTemporary,
            onChanged: superSetting ? null : onTemporaryChanged, 
            accentColor: accentColor,
            isDisabled: superSetting,
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required BuildContext context,
    required String label,
    required bool value,
    required Function(bool)? onChanged,
    required Color accentColor,
    bool isDisabled = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDisabled ? CustomColors.getThemeColor(context, AppColorData.secondary4) : CustomColors.getThemeColor(context, AppColorData.secondary), // 👈 dim when disabled
          ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          onChanged: onChanged, // 👈 null disables the switch
          activeThumbColor: accentColor,
          activeTrackColor: accentColor.withValues(alpha: 0.2),
          inactiveThumbColor: isDisabled
              ? CustomColors.getThemeColor(context, AppColorData.disabled).withValues(alpha: 0.6) // 👈 subtle gray when disabled
              : accentColor,
          inactiveTrackColor: isDisabled
              ? CustomColors.getThemeColor(context, AppColorData.disabled).withValues(alpha: 0.2)
              : CustomColors.getThemeColor(context, AppColorData.transparent),
        ),
      ],
    );
  }
}
