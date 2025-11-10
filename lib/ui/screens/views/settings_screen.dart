// ignore_for_file: use_build_context_synchronously

import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/log_service.dart';
import 'package:expenso/services/routing_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Settings",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Appearance / Theme Button
            GestureDetector(
              onTap: () {
                RoutingService().navigateTo(RoutingService.colorTheme);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          Icons.palette,
                          color: CustomColors.getThemeColor(
                            context,
                            AppColorData.secondary,
                          ),
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Appearances",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              AppColorData.secondary,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: CustomColors.getThemeColor(
                                  context,
                                  AppColorData.primary,
                                ),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Download Logs Button
            GestureDetector(
              onTap: () async {
                final currentContext = context; // capture context

                try {
                  final path =
                      await LogService.downloadLogToUserSelectedLocation();

                  if (!mounted) return; 

                  if (path != null) {
                    showAppSnackBar(
                      currentContext, 
                      message: 'Log downloaded to: $path',
                    );
                  } else {
                    showAppSnackBar(
                      currentContext,
                      message: 'Log download canceled or failed.',
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  showAppSnackBar(
                    currentContext,
                    message: 'Error saving log: $e',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          Icons.download,
                          color: CustomColors.getThemeColor(
                            context,
                            AppColorData.secondary,
                          ),
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Download Logs",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              AppColorData.secondary,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: CustomColors.getThemeColor(
                                  context,
                                  AppColorData.primary,
                                ),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 6, showAdd: false),
    );
  }
}
