import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/data/models/month_data.dart';
import 'package:expenso/data/models/year_data.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyExpensesScreen extends StatefulWidget {
  const MonthlyExpensesScreen({super.key});

  @override
  State<MonthlyExpensesScreen> createState() => _MonthlyExpensesScreenState();
}

class _MonthlyExpensesScreenState extends State<MonthlyExpensesScreen> {
  late String year;
  late String month;
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments (["2025", "October"])
    final args =
        ModalRoute.of(context)?.settings.arguments as List<String>? ??
        ["Unknown", "Unknown"];
    year = args[0];
    month = args[1];

    _loadMonthlyExpenses();
  }

  Future<void> _loadMonthlyExpenses() async {
    setState(() => isLoading = true);

    // Get all data structured by year/month/day
    final allData = await DBHelper().getAllDataStructured();

    // Find the matching year
    final yearData = allData.firstWhere(
      (y) => y.year == year,
      orElse: () => YearData(year: year, months: []),
    );

    // Find the matching month (using 1-12 as month index)
    final monthIndex = DateFormat.MMMM().parse(month).month;
    final monthData = yearData.months.firstWhere(
      (m) => int.parse(m.month) == monthIndex,
      orElse: () => MonthData(month: monthIndex.toString(), days: []),
    );

    // Flatten all expenses in the month
    final monthExpenses = <Expense>[];
    for (var day in monthData.days) {
      monthExpenses.addAll(day.expenses);
    }

    if (mounted) {
      setState(() {
        expenses = monthExpenses;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${month.substring(0, 3).toUpperCase()} Expenses $year",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
          ? const Center(child: Text("No expenses found for this month"))
          : Column(
              children: [
                const SizedBox(height: 5),
                const BudgetCard(
                  title: "Total Difference",
                  income: "54,654",
                  expense: "34,120",
                  remaining: "20,534",
                ),
                const SizedBox(height: 10),

                // Wrap ListView.builder with Expanded
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final e = expenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            e.type == 'Expense'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: e.type == 'Expense'
                                ? Colors.red
                                : Colors.green,
                          ),
                          title: Text("\$${e.price.toStringAsFixed(2)}"),
                          subtitle: Text(
                            "${DateFormat('dd MMM yyyy').format(e.dateTime)}\n${e.note ?? ''}",
                          ),
                          isThreeLine: true,
                          trailing: Text(e.categoryIds.join(', ')),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      floatingActionButton: const FloatingAddBtn(),
    );
  }
}
