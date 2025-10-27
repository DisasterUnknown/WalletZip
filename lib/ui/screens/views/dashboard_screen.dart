import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/build_category_card.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  Map<String, double> categoryTotals = {};
  double totalExpenses = 0;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final db = DBHelper();
    final allCategories = await db.getCategories();
    final allExpenses = await db.getAllExpenses();

    final Map<String, double> totals = {};
    double total = 0;

    for (var e in allExpenses) {
      if (e.type.toLowerCase() != "expense") continue;

      List<int> ids = [];
      if (e.categoryIds.isNotEmpty) {
        ids = e.categoryIds.map((s) => (s)).toList();
      }

      if (ids.isEmpty) {
        totals["Uncategorized"] = (totals["Uncategorized"] ?? 0) + e.price;
      } else {
        for (var id in ids) {
          final cat = allCategories.firstWhere(
            (c) => c.id == id,
            orElse: () => Category(
              id: 0,
              name: "Uncategorized",
              state: "active",
              icon: Icons.category,
            ),
          );
          totals[cat.name] = (totals[cat.name] ?? 0) + e.price;
        }
      }

      total += e.price;
    }

    if (mounted) {
      setState(() {
        categoryTotals = totals;
        totalExpenses = total;
        categories = allCategories;
        isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barMaxWidth = screenWidth * 0.7;
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Dashboard",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const BudgetCard(title: "Lifetime Summary", type: "lifetime"),
                  const SizedBox(height: 16),

                  if (categoryTotals.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Top Expenses by Category",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Render sorted category cards
                  ...sortedEntries.map((e) {
                    final cat = categories.firstWhere(
                      (c) => c.name == e.key,
                      orElse: () => Category(
                        id: 0,
                        name: "Uncategorized",
                        state: "active",
                        icon: Icons.category,
                      ),
                    );
                    return buildCategoryCard(
                      e.key,
                      e.value,
                      cat.icon,
                      barMaxWidth,
                      totalExpenses
                    );
                  }),

                  if (categoryTotals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No categorized expenses found.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
      floatingActionButton: const FloatingAddBtn(),
      bottomNavigationBar: const BottomNavBar(tabIndex: 1, showAdd: false),
    );
  }
}
