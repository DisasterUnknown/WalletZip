// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/data/backup/backup_service.dart';
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

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
              ],
            ),
          ),
        ),
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

            // Appearance
            _buildSettingsTile(
              context: context,
              icon: Icons.palette,
              title: "Appearances",
              onTap: () {
                RoutingService().navigateTo(RoutingService.colorTheme);
              },
            ),

            // Appearance
            _buildSettingsTile(
              context: context,
              icon: Icons.developer_board,
              title: "View Logs",
              onTap: () {
                RoutingService().navigateTo(RoutingService.viewLogs);
              },
            ),

            // Logs download
            _buildSettingsTile(
              context: context,
              icon: Icons.download,
              title: "Download Logs",
              onTap: () async {
                try {
                  final path =
                      await LogService.downloadLogToUserSelectedLocation();

                  if (!mounted) return;
                  if (path != null) {
                    showAppSnackBar(
                      context,
                      message: 'Log downloaded to: $path',
                      backgroundColor: CustomColors.getThemeColor(
                        context,
                        AppColorData.incomeColor,
                      ),
                      textColor: CustomColors.getThemeColor(
                        context,
                        AppColorData.primary,
                      ),
                    );
                  } else {
                    showAppSnackBar(
                      context,
                      message: 'Log download canceled or failed.',
                      backgroundColor: CustomColors.getThemeColor(
                        context,
                        AppColorData.pendingColor,
                      ),
                      textColor: CustomColors.getThemeColor(
                        context,
                        AppColorData.primary,
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  showAppSnackBar(
                    context,
                    message: 'Error saving log: $e',
                    backgroundColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.expenseColor,
                    ),
                    textColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.primary,
                    ),
                  );
                }
              },
            ),

            const Divider(height: 40, thickness: 1),

            // 🧭 DB: Export
            _buildSettingsTile(
              context: context,
              icon: Icons.cloud_download,
              title: "Download Backup (.silverFoxDb)",
              onTap: () async {
                final path = await DBSyncService.exportDatabase();
                if (!mounted) return;
                if (path != null) {
                  showAppSnackBar(
                    context,
                    message: 'Database saved to: $path',
                    backgroundColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.incomeColor,
                    ),
                    textColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.primary,
                    ),
                  );
                } else {
                  showAppSnackBar(
                    context,
                    message: 'Backup canceled or failed.',
                    backgroundColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.pendingColor,
                    ),
                    textColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.primary,
                    ),
                  );
                }
              },
            ),

            // 🔁 DB: Import
            _buildSettingsTile(
              context: context,
              icon: Icons.cloud_upload,
              title: "Import Backup (.silverFoxDb)",
              onTap: () async {
                final success = await DBSyncService.importDatabase();
                if (!mounted) return;
                if (success) {
                  showAppSnackBar(
                    context,
                    message: 'Database restored successfully!',
                    backgroundColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.incomeColor,
                    ),
                    textColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.primary,
                    ),
                  );
                } else {
                  showAppSnackBar(
                    context,
                    message: 'Restore canceled or failed.',
                    backgroundColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.pendingColor,
                    ),
                    textColor: CustomColors.getThemeColor(
                      context,
                      AppColorData.primary,
                    ),
                  );
                }
              },
            ),

            // 🧹 DB: Clear
            _buildSettingsTile(
              context: context,
              icon: Icons.delete_forever,
              title: "Clear All Data",
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Dialog(
                      backgroundColor: CustomColors.getThemeColor(
                        context,
                        AppColorData.transparent,
                      ).withAlpha(220),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: CustomColors.getThemeColor(
                              context,
                              AppColorData.primary,
                            ).withAlpha(180),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CustomColors.getThemeColor(
                                context,
                                AppColorData.expenseColor,
                              ).withAlpha(180),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Confirm Data Clear",
                                style: TextStyle(
                                  color: CustomColors.getThemeColor(
                                    context,
                                    AppColorData.expenseColor,
                                  ),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Are you sure you want to permanently delete all app data? This action cannot be undone.",
                                style: TextStyle(
                                  color: CustomColors.getThemeColor(
                                    context,
                                    AppColorData.secondary,
                                  ),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: CustomColors.getThemeColor(
                                          context,
                                          AppColorData.expenseColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),

                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          CustomColors.getThemeColor(
                                            context,
                                            AppColorData.transparent,
                                          ),
                                      side: BorderSide(
                                        color: CustomColors.getThemeColor(
                                          context,
                                          AppColorData.expenseColor,
                                        ), // border color
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                        color: CustomColors.getThemeColor(
                                          context,
                                          AppColorData.expenseColor,
                                        ),
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

                if (confirm != true) return;

                await DBSyncService.clearDatabase();
                if (!mounted) return;
                showAppSnackBar(
                  context,
                  message: 'All data cleared successfully.',
                  backgroundColor: CustomColors.getThemeColor(
                    context,
                    AppColorData.expenseColor,
                  ),
                  textColor: CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary,
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 6, showAdd: false),
    );
  }
}
