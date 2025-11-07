import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:flutter/material.dart';

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
    await LocalSharedPreferences.saveString('selected_categories', ids);
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
        child: GridView.builder(
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
                  color: CustomColors.getThemeColor(context, 'primary'),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? CustomColors.getThemeColor(context, 'incomeColor') : CustomColors.getThemeColor(context, 'secondary2'),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: CustomColors.getThemeColor(context, 'incomeColor').withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: CustomColors.getThemeColor(context, 'incomeColor').withValues(alpha: 0.3),
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
                      color: isSelected ? CustomColors.getThemeColor(context, 'incomeColor') : CustomColors.getThemeColor(context, 'secondary3'),
                      size: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      style: TextStyle(
                        color: isSelected ? CustomColors.getThemeColor(context, 'incomeColor') : CustomColors.getThemeColor(context, 'secondary3'),
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
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 2, showAdd: false),
    );
  }
}
