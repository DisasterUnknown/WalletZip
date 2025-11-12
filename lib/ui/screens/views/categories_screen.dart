import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:expenso/services/log_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Set<int> selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedCategories();
  }

  // Load saved selected categories
  Future<void> _loadSelectedCategories() async {
    final saved = await LocalSharedPreferences.getString('selected_categories');
    LogService.log("Info", "Loaded selected categories: $saved");
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        selectedCategoryIds = saved
            .split(',')
            .map((id) => int.tryParse(id))
            .whereType<int>()
            .toSet();
      });
    }
  }

  // Save selected categories
  Future<void> _saveSelectedCategories() async {
    final ids = selectedCategoryIds.join(',');
    LogService.log("Info", "Saving selected categories: $ids");
    await LocalSharedPreferences.setString('selected_categories', ids);
  }

  void _toggleCategory(Category category) {
    setState(() {
      if (selectedCategoryIds.contains(category.id)) {
        selectedCategoryIds.remove(category.id);
      } else {
        selectedCategoryIds.add(category.id);
      }
      _saveSelectedCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Categories",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: CustomColors.getThemeColor(
                  context,
                  AppColorData.secondary,
                ).withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary1,
                  ).withAlpha(120),
                  width: 1.2,
                ),
              ),
              child: Text(
                "Select the categories you want to use regularly. "
                "Only the categories you select here will appear when adding a new transaction. "
                "If you don't select any, all categories will be available by default.",
                style: TextStyle(
                  color: CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary,
                  ),
                  fontSize: 13,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            SizedBox(height: 4),

            // Grid of categories
            GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView scroll
              shrinkWrap: true, // Let GridView take only needed space
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 80,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategoryIds.contains(category.id);

                return GestureDetector(
                  onTap: () => _toggleCategory(category),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColors.getThemeColor(
                        context,
                        AppColorData.primary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? CustomColors.getThemeColor(
                                context,
                                AppColorData.incomeColor,
                              )
                            : CustomColors.getThemeColor(
                                context,
                                AppColorData.secondary2,
                              ),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: CustomColors.getThemeColor(
                                  context,
                                  AppColorData.incomeColor,
                                ).withValues(alpha: 0.6),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: CustomColors.getThemeColor(
                                  context,
                                  AppColorData.incomeColor,
                                ).withValues(alpha: 0.3),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          color: isSelected
                              ? CustomColors.getThemeColor(
                                  context,
                                  AppColorData.incomeColor,
                                )
                              : CustomColors.getThemeColor(
                                  context,
                                  AppColorData.secondary3,
                                ),
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected
                                ? CustomColors.getThemeColor(
                                    context,
                                    AppColorData.incomeColor,
                                  )
                                : CustomColors.getThemeColor(
                                    context,
                                    AppColorData.secondary3,
                                  ),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 2, showAdd: false),
    );
  }
}
