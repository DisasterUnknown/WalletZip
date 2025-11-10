import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/data/models/month_data.dart';
import 'package:expenso/data/models/year_data.dart';
import 'package:expenso/services/log_service.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:expenso/ui/widgets/sub/transaction_record_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyExpensesPage extends StatefulWidget {
  const MonthlyExpensesPage({super.key});

  @override
  State<MonthlyExpensesPage> createState() => _MonthlyExpensesPageState();
}

class _MonthlyExpensesPageState extends State<MonthlyExpensesPage> {
  late String year;
  late String month;
  List<Expense> expenses = [];
  bool isLoading = true;
  String _dataHash = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as List<String>? ??
        ["Unknown", "Unknown"];
    year = args[0];
    month = args[1];

    _checkAndLoadExpenses();
  }

  Future<void> _checkAndLoadExpenses() async {
    final allData = await DBHelper().getAllDataStructured();

    final yearData = allData.firstWhere(
      (y) => y.year == year,
      orElse: () => YearData(year: year, months: []),
    );

    final monthIndex = DateFormat.MMMM().parse(month).month;
    final monthData = yearData.months.firstWhere(
      (m) => int.parse(m.month) == monthIndex,
      orElse: () => MonthData(month: monthIndex.toString(), days: []),
    );

    final monthExpenses = <Expense>[];
    for (var day in monthData.days) {
      monthExpenses.addAll(day.expenses);
    }

    // Compute a simple hash (length + last timestamp)
    final hash =
        '${monthExpenses.length}-${monthExpenses.isNotEmpty ? monthExpenses.last.dateTime.millisecondsSinceEpoch : 0}';

    // Only refresh if data has changed
    if (_dataHash != hash) {
      if (mounted) {
        setState(() {
          expenses = monthExpenses;
          isLoading = false;
          _dataHash = hash;
        });
      }
    }
  }

  Future<void> _deleteExpense(int id) async {
    await DBHelper().deleteExpense(id);
    LogService.log("Expense deleted: $id");
    _checkAndLoadExpenses();
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
                BudgetCard(
                  title: "Monthly Summary",
                  type: "month",
                  month: month,
                  year: year,
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length + 1,
                    itemBuilder: (context, index) {
                      if (index == expenses.length) {
                        return const SizedBox(height: 80);
                      }

                      final expense = expenses[index];

                      // Use the reusable card widget
                      return transactionRecordCard(
                        expense,
                        context,
                        showDelete: true,
                        onDeletePress: (id) => _deleteExpense(id),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingAddBtn(month: month, year: year),
    );
  }
}
