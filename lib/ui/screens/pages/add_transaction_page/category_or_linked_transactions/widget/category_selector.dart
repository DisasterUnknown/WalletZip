import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:expenso/data/models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> userCategories;
  final int? selectedCategoryId;
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
    // Decide number of rows
    final int numRows = userCategories.length > 20 ? 3 : 2;

    // Split categories into chunks per row
    final List<List<Category>> rows = _splitCategories(userCategories, numRows);

    // Adjust height dynamically
    final double totalHeight = numRows == 2 ? 150 : 220;

    return SizedBox(
      height: totalHeight + 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Transaction Category',
            style: TextStyle(
              color: CustomColors.getThemeColor(context, 'secondary'),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: totalHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(rows.length, (rowIndex) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : 8),
                      child: Row(
                        children: rows[rowIndex]
                            .map((cat) => _categoryCard(cat, context))
                            .toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper: Split list into n nearly equal parts
  List<List<Category>> _splitCategories(List<Category> list, int n) {
    int chunkSize = (list.length / n).ceil();
    List<List<Category>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Widget _categoryCard(Category category, BuildContext context) {
    final isSelected = selectedCategoryId == category.id;

    return InkWell(
      onTap: () => onCategoryTap(category),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: CustomColors.getThemeColor(context, 'primary'),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : CustomColors.getThemeColor(context, 'secondary2'),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? accentColor : CustomColors.getThemeColor(context, 'secondary3'),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? accentColor : CustomColors.getThemeColor(context, 'secondary3'),
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
