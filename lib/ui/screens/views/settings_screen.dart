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
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final path =
                      await LogService.downloadLogToUserSelectedLocation();
                  if (!mounted) return;

                  if (path != null) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Log downloaded to: $path'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Log download canceled or failed.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Error saving log: $e'),
                      duration: const Duration(seconds: 3),
                    ),
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
