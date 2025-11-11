import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/core/constants/app_constants.dart';

/// Shows a confirmation dialog for super-setting transactions.
/// Returns true if user chooses to proceed, false otherwise.
Future<bool> showSuperTransactionConfirmDialog({
  required BuildContext context,
  required String type, // "expense" or "income"
  required double amount,
}) async {
  final accentColor = type.toLowerCase() == 'expense'
      ? CustomColors.getThemeColor(context, AppColorData.expenseColor)
      : CustomColors.getThemeColor(context, AppColorData.incomeColor);

  final proceed = await showDialog<bool>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor:
            CustomColors.getThemeColor(context, AppColorData.primary)
                .withAlpha(200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CustomColors.getThemeColor(context, AppColorData.transparent),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withAlpha(180), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Confirm Transaction',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Text(
                    'This super-setting transaction will result in a $type of '
                    '${amount.toStringAsFixed(2)}. Do you want to proceed?',
                    style: TextStyle(color: CustomColors.getThemeColor(context, AppColorData.secondary3), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: accentColor),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.getThemeColor(
                              context, AppColorData.transparent),
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Proceed',
                          style: TextStyle(color: accentColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  return proceed == true;
}
