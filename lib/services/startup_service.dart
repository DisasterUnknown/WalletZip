import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/transaction.dart';
import 'package:expenso/services/log_service.dart';

class StartupService {
  static Future<bool> shouldOpenCurrentMonth() async {
    final saved = await LocalSharedPreferences.getString(
      SharedPrefValues.openCurrentMonth,
    );
    return saved == 'true';
  }

  static Future<void> checkAndAddBudgetIncome() async {
    final db = DBHelper();

    final budgets = await db.getAllBudgets();
    if (budgets.isEmpty) return;

    final budget = budgets[0];
    final now = DateTime.now();

    // Get all income/expense records
    final allEntries = await db.getAllExpenses();

    // Filter only budget-based incomes
    final budgetIncomes = allEntries
        .where((e) => e.isBudgetEntry && e.type.toLowerCase() == "income")
        .toList();

    DateTime? lastAdded;

    if (budgetIncomes.isNotEmpty) {
      budgetIncomes.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      lastAdded = budgetIncomes.last.dateTime;
    }

    // Determine the month to start adding from
    DateTime startMonth;

    if (lastAdded != null) {
      // Continue from the next month after the last added one
      startMonth = DateTime(lastAdded.year, lastAdded.month + 1, 1);
    } else {
      // No records yet → start from the month the budget was created
      startMonth = DateTime(budget.year, budget.month, 1);
    }

    // Keep adding up to the current month
    while (startMonth.isBefore(DateTime(now.year, now.month + 1, 1))) {
      double incomeAmount;

      switch (budget.type.toLowerCase()) {
        case "monthly":
          incomeAmount = budget.amount;
          break;
        case "yearly":
          incomeAmount = budget.amount / 12;
          break;
        case "daily":
          final daysInMonth = DateTime(
            startMonth.year,
            startMonth.month + 1,
            0,
          ).day;
          incomeAmount = budget.amount * daysInMonth;
          break;
        default:
          incomeAmount = budget.amount;
      }

      await db.insertExpense(
        TransactionRecord(
          type: "Income",
          price: incomeAmount,
          categoryIds: [-1],
          note: "Budget Income",
          dateTime: DateTime(startMonth.year, startMonth.month, 1),
          isBudgetEntry: true,
        ),
      );

      // move to next month
      startMonth = DateTime(startMonth.year, startMonth.month + 1, 1);
      LogService.log(
        "StartupService",
        "Added budget income for ${startMonth.month - 1}/${startMonth.year}",
      );
    }
  }
}
