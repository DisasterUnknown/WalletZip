import 'package:expenso/services/routing_service.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // << add this

class YearExpensesScreen extends StatelessWidget {
  const YearExpensesScreen({super.key});

  // Helper to format numbers
  String formatNumber(String value) {
    if (value.isEmpty) return value;
    final n = int.tryParse(value.replaceAll(',', '')) ?? 0;
    return NumberFormat.decimalPattern().format(n);
  }

  @override
  Widget build(BuildContext context) {
    final year =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Unknown";

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

    // Sample prices
    final prices = List.generate(
      months.length,
      (index) => index.isEven ? "${(index + 1) * 100}" : "",
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Expenses $year",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),

              // BudgetCard at the top
              const BudgetCard(
                title: "Total Difference",
                income: "54,654",
                expense: "34,120",
                remaining: "20,534",
              ),
              const SizedBox(height: 10),

              ...List.generate(months.length, (index) {
                final month = months[index];
                final price = prices[index];

                final monthIndex = index + 1;
                final currentMonthIndex = DateTime.now().month;
                final currentYear = DateTime.now().year;
                final isOngoing =
                    monthIndex == currentMonthIndex &&
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
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
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
                        // Month + Status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              month,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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

                        // Price formatted
                        Text(
                          price.isEmpty ? "—" : formatNumber(price),
                          style: TextStyle(
                            color: price.isEmpty
                                ? Colors.white54
                                : Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
