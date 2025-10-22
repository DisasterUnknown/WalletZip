import 'package:flutter/material.dart';
import 'package:expenso/data/models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> userCategories;
  final List<int> selectedCategoryIds;
  final Color accentColor;
  final Function(Category) onCategoryTap;

  const CategorySelector({
    super.key,
    required this.userCategories,
    required this.selectedCategoryIds,
    required this.accentColor,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: userCategories
                      .asMap()
                      .entries
                      .where((e) => e.key.isEven)
                      .map((e) => _categoryCard(e.value))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: userCategories
                      .asMap()
                      .entries
                      .where((e) => e.key.isOdd)
                      .map((e) => _categoryCard(e.value))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(Category category) {
    final isSelected = selectedCategoryIds.contains(category.id);
    return GestureDetector(
      onTap: () => onCategoryTap(category),
      child: Container(
        width: 80,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white24,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withAlpha(150),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: accentColor.withAlpha(80),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon,
                color: isSelected ? accentColor : Colors.white70, size: 24),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? accentColor : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
