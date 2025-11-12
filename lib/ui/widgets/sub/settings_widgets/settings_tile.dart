import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

Widget buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isNavigate = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary,
                  ).withValues(alpha: 0.2),
                  CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary,
                  ).withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: CustomColors.getThemeColor(
                  context,
                  AppColorData.secondary,
                ).withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Icon(
                  icon,
                  color: CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary,
                  ),
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(
                        context,
                        AppColorData.secondary,
                      ),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (isNavigate)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColors.getThemeColor(
                      context,
                      AppColorData.secondary,
                    ),
                    size: 18,
                  ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }