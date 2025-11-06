import 'package:flutter/material.dart';
import 'package:expenso/data/models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> userCategories;
  final int? selectedCategoryId; // only one selected
  final Color accentColor;
  final Function(Category) onCategoryTap;

  const CategorySelector({
    super.key,
    required this.userCategories,
    required this.selectedCategoryId,
    required this.accentColor,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Transaction Category',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150, 
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(Category category) {
    final isSelected = selectedCategoryId == category.id; // only one
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
            Icon(
              category.icon,
              color: isSelected ? accentColor : Colors.white70,
              size: 24,
            ),
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
