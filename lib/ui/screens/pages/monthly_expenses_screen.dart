import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/data/models/month_data.dart';
import 'package:expenso/data/models/year_data.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/confirm_delete_dialog.dart';
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

                      final e = expenses[index];
                      final date = e.dateTime;
                      final day = DateFormat('dd').format(date);
                      final weekday = DateFormat('E').format(date);
                      final time = DateFormat('hh:mm a').format(date);

                      final isExpense = e.type.toLowerCase() == 'expense';
                      final borderColor = isExpense
                          ? Colors.redAccent
                          : Colors.greenAccent;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border(
                            left: BorderSide(color: borderColor, width: 4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side: date + details
                            Row(
                              children: [
                                // Date block
                                Container(
                                  width: 30,
                                  margin: const EdgeInsets.only(right: 6),
                                  child: Column(
                                    children: [
                                      Text(
                                        weekday,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        day,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Description + time
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.note != null && e.note!.isNotEmpty
                                          ? (e.note!.length > 20
                                                ? '${e.note!.substring(0, 20)}...'
                                                : e.note!)
                                          : '(No description)',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      time,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Right side: amount + delete
                            Row(
                              children: [
                                Text(
                                  e.price
                                      .toStringAsFixed(2)
                                      .replaceAllMapped(
                                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                        (match) => ',',
                                      ),
                                  style: TextStyle(
                                    color: isExpense
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ConfirmDeleteDialog(
                                        message:
                                            "Delete this ${isExpense ? 'expense' : 'income'} permanently?",
                                        onConfirm: () => _deleteExpense(e.id!),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.white54,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
