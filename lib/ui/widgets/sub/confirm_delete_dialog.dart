import 'dart:ui';
import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    this.title = "Delete Item",
    this.message = "Are you sure you want to delete this item?",
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.getThemeColor(context, AppColorData.transparent), // make transparent for glass effect
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container( // semi-transparent dark
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: CustomColors.getThemeColor(context, AppColorData.expenseColor)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title + icon
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: CustomColors.getThemeColor(context, AppColorData.expenseColor), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: CustomColors.getThemeColor(context, AppColorData.expenseColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Message
                Text(
                  message,
                  style: TextStyle(
                    color: CustomColors.getThemeColor(context, AppColorData.secondary3),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: CustomColors.getThemeColor(context, AppColorData.secondary2)),
                        foregroundColor: CustomColors.getThemeColor(context, AppColorData.secondary5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.getThemeColor(context, AppColorData.expenseColor),
                        foregroundColor: CustomColors.getThemeColor(context, AppColorData.secondary),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
