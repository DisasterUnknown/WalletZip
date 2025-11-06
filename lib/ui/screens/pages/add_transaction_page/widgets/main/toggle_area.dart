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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Super Setting
          Expanded(
            child: Row(
              children: [
                const Text('Super Setting', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Switch.adaptive(
                  value: superSetting,
                  onChanged: onSuperSettingChanged,
                  activeThumbColor: accentColor,
                  activeTrackColor: accentColor.withValues(alpha: 0.2),
                  inactiveThumbColor: accentColor,
                  inactiveTrackColor: Colors.transparent,
                ),
              ],
            ),
          ),

          // Temporary (only if not superSetting)
          if (!superSetting)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Temporary', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: isTemporary,
                    onChanged: onTemporaryChanged,
                    activeThumbColor: accentColor,
                    activeTrackColor: accentColor.withValues(alpha: 0.2),
                    inactiveThumbColor: accentColor,
                    inactiveTrackColor: Colors.transparent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
