import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/year_data.dart';
import 'package:expenso/services/routing_service.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<YearData> yearCards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadYearCards();

    // Listen to DB changes
    DBHelper().expenseCountNotifier.addListener(() {
      _loadYearCards();
    });
  }

  Future<void> _loadYearCards() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final allData = await DBHelper().getAllDataStructured();

    List<YearData> years = List.from(allData);
    final currentYear = DateTime.now().year.toString();

    // Add current year if not present
    if (!years.any((y) => y.year == currentYear)) {
      years.insert(0, YearData(year: currentYear, months: []));
    }

    if (mounted) {
      setState(() {
        yearCards = years;
        isLoading = false;
      });
    }
  }

  String getYearTotal(YearData yearData) {
    double total = 0;
    for (var month in yearData.months) {
      for (var day in month.days) {
        for (var e in day.expenses) {
          if (e.type == "expense") {
            total -= e.price;
          } else if (e.type == "income") {
            total += e.price;
          }
        }
      }
    }
    return total == 0 ? "" : NumberFormat('#,##0.00').format(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Expense Records",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 5),

                // 🔹 Compact top summary card
                const BudgetCard(title: "Lifetime Summary", type: "lifetime"),
                const SizedBox(height: 10),

                // 🔹 Scrollable list of years
                Expanded(
                  child: ListView.builder(
                    itemCount: yearCards.length + 1,
                    itemBuilder: (context, index) {
                      if (index == yearCards.length) {
                        return const SizedBox(height: 80);
                      }

                      final yearData = yearCards[index];
                      final year = int.tryParse(yearData.year) ?? 0;
                      final currentYearInt = DateTime.now().year;
                      final isOngoing = year == currentYearInt;

                      String status;
                      if (year > currentYearInt) {
                        status = "Pending";
                      } else if (year == currentYearInt) {
                        status = "Ongoing";
                      } else {
                        status = "Completed";
                      }

                      final total = getYearTotal(yearData);
                      final double totalValue =
                          double.tryParse(total.replaceAll(',', '')) ?? 0;

                      return GestureDetector(
                        onTap: () async {
                          await RoutingService().navigateTo(
                            RoutingService.yearExpenses,
                            arguments: yearData.year,
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
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(
                                color: isOngoing
                                    ? Colors.greenAccent
                                    : Colors.blueGrey.withOpacity(0.8),
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
                                    yearData.year,
                                    style: const TextStyle(
                                      color: Colors.white,
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
                                total.isEmpty ? "—" : total,
                                style: TextStyle(
                                  color: total.isEmpty
                                      ? Colors.white54
                                      : totalValue < 0
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
      floatingActionButton: const FloatingAddBtn(),
      bottomNavigationBar: const BottomNavBar(tabIndex: 5, showAdd: false),
    );
  }
}
