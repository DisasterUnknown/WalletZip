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
  Map<String, double> categoryTotalsExpenses = {};
  Map<String, double> categoryTotalsIncome = {};
  double globalTotalExpenses = 0;
  double globalTotalIncome = 0;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    final db = DBHelper();
    final allCategories = await db.getCategories();
    final allExpenses = await db.getAllExpenses();

    final Map<String, double> totalsExpenses = {};
    final Map<String, double> totalsIncome = {};
    double totalExpenses = 0;
    double totalIncome = 0;

    for (var e in allExpenses) {
      final ids = e.categoryIds.isNotEmpty ? e.categoryIds.toList() : [];

      if (ids.isEmpty) {
        _addToTotals(
          e.type,
          'Uncategorized',
          e.price,
          totalsExpenses,
          totalsIncome,
          (v) => totalExpenses += v,
          (v) => totalIncome += v,
        );
      } else {
        for (var id in ids) {
          final cat = allCategories.firstWhere(
            (c) => c.id == id,
            orElse: () => Category(
              id: 0,
              name: 'Uncategorized',
              state: 'active',
              icon: Icons.category,
            ),
          );
          _addToTotals(
            e.type,
            cat.name,
            e.price,
            totalsExpenses,
            totalsIncome,
            (v) => totalExpenses += v,
            (v) => totalIncome += v,
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        categoryTotalsExpenses = totalsExpenses;
        categoryTotalsIncome = totalsIncome;
        globalTotalExpenses = totalExpenses;
        globalTotalIncome = totalIncome;
        categories = allCategories;
        isLoading = false;
      });
    }
  }

  void _addToTotals(
    String type,
    String categoryName,
    double amount,
    Map<String, double> expensesMap,
    Map<String, double> incomeMap,
    void Function(double) addExpense,
    void Function(double) addIncome,
  ) {
    if (type.toLowerCase() == 'expense') {
      expensesMap[categoryName] = (expensesMap[categoryName] ?? 0) + amount;
      addExpense(amount);
    } else if (type.toLowerCase() == 'income') {
      incomeMap[categoryName] = (incomeMap[categoryName] ?? 0) + amount;
      addIncome(amount);
    }
  }

  Widget _buildCategorySection(
    String title,
    Map<String, double> categoryTotals,
    double globalTotal,
    String type,
    double barMaxWidth,
  ) {
    if (categoryTotals.isEmpty) return const SizedBox.shrink();

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        ...sortedEntries.map((e) {
          final cat = categories.firstWhere(
            (c) => c.name == e.key,
            orElse: () => Category(
              id: 0,
              name: 'Uncategorized',
              state: 'active',
              icon: Icons.category,
            ),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: buildCategoryCard(
              e.key,
              type,
              e.value,
              cat.icon,
              barMaxWidth,
              globalTotal,
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barMaxWidth = screenWidth - 64;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Dashboard',
        showBackButton: false,
        showHomeButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: BudgetCard(
                      title: 'Lifetime Summary',
                      type: 'lifetime',
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildCategorySection(
                    'Top Expenses by Category',
                    categoryTotalsExpenses,
                    globalTotalExpenses,
                    'expense',
                    barMaxWidth,
                  ),
                  const SizedBox(height: 16),

                  _buildCategorySection(
                    'Top Income by Category',
                    categoryTotalsIncome,
                    globalTotalIncome,
                    'income',
                    barMaxWidth,
                  ),
                  const SizedBox(height: 16),

                  if (categoryTotalsExpenses.isEmpty &&
                      categoryTotalsIncome.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No categorized data found.',
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
