import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/build_category_card.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:flutter/material.dart';

enum DashboardFilter { month, year, all }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, double> categoryTotalsExpenses = {};
  Map<String, double> categoryTotalsIncome = {};
  double globalTotalExpenses = 0;
  double globalTotalIncome = 0;
  List<Category> categories = [];
  DashboardFilter selectedFilter = DashboardFilter.month;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final filter = DashboardFilter.values[_tabController.index];
      if (filter != selectedFilter) {
        setState(() => selectedFilter = filter);
        _loadData();
      }
    });
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final filter = DashboardFilter.values[_tabController.index];
      if (filter != selectedFilter) {
        setState(() => selectedFilter = filter);
        _loadData();
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = DBHelper();
    final allCategories = await db.getCategories();
    final allExpenses = await db.getAllExpenses();

    final now = DateTime.now();
    final filteredExpenses = allExpenses.where((e) {
      switch (selectedFilter) {
        case DashboardFilter.month:
          return e.dateTime.year == now.year && e.dateTime.month == now.month;
        case DashboardFilter.year:
          return e.dateTime.year == now.year;
        case DashboardFilter.all:
          return true;
      }
    }).toList();

    final Map<String, double> totalsExpenses = {};
    final Map<String, double> totalsIncome = {};
    double totalExpenses = 0;
    double totalIncome = 0;

    for (var e in filteredExpenses) {
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
        final distributedAmount = e.price / ids.length;
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
            distributedAmount,
            totalsExpenses,
            totalsIncome,
            (v) => totalExpenses += distributedAmount,
            (v) => totalIncome += distributedAmount,
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        categories = allCategories;
        categoryTotalsExpenses = totalsExpenses;
        categoryTotalsIncome = totalsIncome;
        globalTotalExpenses = totalExpenses;
        globalTotalIncome = totalIncome;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
          : Column(
              children: [
                // Top card
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: BudgetCard(
                    title: 'Lifetime Summary',
                    type: 'lifetime',
                  ),
                ),
                // Tabs for filtering categories
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: Colors.greenAccent,
                  tabs: const [
                    Tab(text: 'Month'),
                    Tab(text: 'Year'),
                    Tab(text: 'All Time'),
                  ],
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: SingleChildScrollView(
                      key: ValueKey(selectedFilter), // smooth transition
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ),
                ),
              ],
            ),
      floatingActionButton: const FloatingAddBtn(),
      bottomNavigationBar: const BottomNavBar(tabIndex: 1, showAdd: false),
    );
  }
}
