import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/services/log_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AppColorThemePage extends StatefulWidget {
  const AppColorThemePage({super.key});

  @override
  State<AppColorThemePage> createState() => _AppColorThemePageState();
}

class _AppColorThemePageState extends State<AppColorThemePage> {
  final List<Map<String, dynamic>> themes = [
    {"name": "Default", "color": Color(0xFF000000), "prefValue": "default"},
    {"name": "Dark Gray", "color": Color.fromARGB(255, 46, 46, 46), "prefValue": "darkGray"},
    {"name": "Ocean Blue", "color": Color.fromARGB(255, 3, 12, 67), "prefValue": "oceanBlue"},
    {"name": "Deep Purple", "color": Color.fromARGB(255, 73, 18, 98), "prefValue": "deepPurple"},
    {"name": "Forest Green", "color": Color.fromARGB(255, 19, 68, 23), "prefValue": "forestGreen"},
    {"name": "Sky Light", "color": Color(0xFFB3E5FC), "prefValue": "skyLight"},
    {"name": "Aqua Light", "color": Color(0xFFE0F7FA), "prefValue": "aquaLight"},
    {"name": "Blush Pink", "color": Color(0xFFF8BBD0), "prefValue": "blushPink"},
    {"name": "Classic Light", "color": Color(0xFFFFFFFF), "prefValue": "classicLight"},
    {"name": "Mint Green", "color": Color(0xFFB2DFDB), "prefValue": "mintGreen"},
    {"name": "Sunny Yellow", "color": Color(0xFFFFF9C4), "prefValue": "sunnyYellow"},
  ];

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  Future<void> _loadSelectedTheme() async {
    final savedPref = await LocalSharedPreferences.getString(SharedPrefValues.prefTheme) ?? "default";
    final index = themes.indexWhere((theme) => theme['prefValue'] == savedPref);
    LogService.log("Loaded selected theme: $savedPref");

    if (index != -1) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "App Color Theme",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: themes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        CustomColors.setTheme(theme['prefValue']);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: theme['color'].withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? CustomColors.getThemeColor(context, AppColorData.secondary)
                                : CustomColors.getThemeColor(context, AppColorData.secondary)
                                    .withValues(alpha: 0.3),
                            width: isSelected ? 3 : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Icon(
                                Icons.palette,
                                color: CustomColors.getThemeColor(context, AppColorData.secondary),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              theme['name'],
                              style: TextStyle(
                                color: CustomColors.getThemeColor(context, AppColorData.secondary),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 18
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: CustomColors.getThemeColor(context, AppColorData.secondary),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
