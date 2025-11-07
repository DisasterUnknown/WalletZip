import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/month_data.dart';
import 'package:expenso/data/models/year_data.dart';
import 'package:expenso/services/routing_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class YearExpensesPage extends StatefulWidget {
  const YearExpensesPage({super.key});

  @override
  State<YearExpensesPage> createState() => _YearExpensesPageState();
}

class _YearExpensesPageState extends State<YearExpensesPage> {
  late String year;
  bool isLoading = true;
  Map<int, double> monthlyTotals = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    year = ModalRoute.of(context)?.settings.arguments as String? ?? "Unknown";
    _loadMonthlyTotals();
  }

  Future<void> _loadMonthlyTotals() async {
    setState(() => isLoading = true);

    final allData = await DBHelper().getAllDataStructured();

    final yearData = allData.firstWhere(
      (y) => y.year == year,
      orElse: () => YearData(year: year, months: []),
    );

    final Map<int, double> totals = {};
    for (var i = 1; i <= 12; i++) {
      totals[i] = 0.0;
      final monthData = yearData.months.firstWhere(
        (m) => int.parse(m.month) == i,
        orElse: () => MonthData(month: i.toString(), days: []),
      );
      for (var day in monthData.days) {
        for (var e in day.expenses) {
          if (e.type == "income") {
            totals[i] = totals[i]! + e.price;
          } else if (e.type == "expense") {
            totals[i] = totals[i]! - e.price;
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        monthlyTotals = totals;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: "Expenses $year",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 5),
                // 🔹 Shrunk summary card like in MonthlyExpensesScreen
                BudgetCard(
                  title: "Yearly Summary",
                  type: "year",
                  year: year,
                ),
                const SizedBox(height: 10),

                // 🔹 Scrollable list (like your monthly screen)
                Expanded(
                  child: ListView.builder(
                    itemCount: months.length + 1,
                    itemBuilder: (context, index) {
                      if (index == months.length) {
                        return const SizedBox(height: 80);
                      }

                      final monthIndex = index + 1;
                      final month = months[index];
                      final total = monthlyTotals[monthIndex] ?? 0.0;
                      final priceText = total == 0 ? "—" : formatNumber(total, convertFromLength: 10, showTrailingZeros: true);

                      final currentMonthIndex = DateTime.now().month;
                      final currentYear = DateTime.now().year;
                      final isOngoing = monthIndex == currentMonthIndex &&
                          int.parse(year) == currentYear;

                      String status;
                      if (int.parse(year) > currentYear ||
                          (int.parse(year) == currentYear &&
                              monthIndex > currentMonthIndex)) {
                        status = "Pending";
                      } else if (isOngoing) {
                        status = "Ongoing";
                      } else {
                        status = "Completed";
                      }

                      return GestureDetector(
                        onTap: () async {
                          await RoutingService().navigateTo(
                            RoutingService.monthlyExpenses,
                            arguments: [year, month],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(
                                color: isOngoing
                                    ? Colors.greenAccent
                                    : Colors.blueGrey.withValues(alpha: 0.8),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    month,
                                    style: TextStyle(
                                      color: CustomColors.getThemeColor(context, 'secondary'),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: status == "Pending"
                                          ? Colors.orangeAccent
                                          : status == "Ongoing"
                                              ? Colors.greenAccent
                                              : Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                priceText,
                                style: TextStyle(
                                  color: total == 0
                                      ? Colors.white54
                                      : total < 0
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
