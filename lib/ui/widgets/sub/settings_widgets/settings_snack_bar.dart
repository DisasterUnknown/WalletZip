import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    bool floating = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color:
                textColor ??
                CustomColors.getThemeColor(context, AppColorData.primary),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            backgroundColor ??
            CustomColors.getThemeColor(context, AppColorData.secondary),
        duration: duration,
        behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }