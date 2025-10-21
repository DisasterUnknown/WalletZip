import 'dart:ui';
import 'package:expenso/services/routing_service.dart';
import 'package:expenso/ui/widgets/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:expenso/ui/widgets/status_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> yearCards = [
    {"year": "2025", "price": "2,500"},
    {"year": "2024", "price": "3,200"},
    {"year": "2023", "price": ""},
  ];

  void _addYearCard() {
    setState(() {
      final latestYear = int.parse(yearCards.first['year'] ?? "2025");
      yearCards.insert(0, {"year": (latestYear + 1).toString(), "price": ""});
    });
  }

  void _removeYearCard(int index) {
    if (yearCards[index]['price'] == null ||
        yearCards[index]['price']!.isEmpty) {
      setState(() {
        yearCards.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot remove a year with price!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Home",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),

              // BudgetCard 
              const BudgetCard(
                title: "Total Difference",
                income: "54,654",
                expense: "34,120",
                remaining: "20,534",
              ),
              const SizedBox(height: 10),

              // Year-Price Cards 
              ...List.generate(yearCards.length, (index) {
                final card = yearCards[index];
                final year = int.tryParse(card['year'] ?? "") ?? 0;
                final currentYear = DateTime.now().year;

                String status;
                if (year > currentYear) {
                  status = "Pending";
                } else if (year == currentYear) {
                  status = "Ongoing";
                } else {
                  status = "Closed";
                }

                return GestureDetector(
                  onTap: () async => await RoutingService().navigateWithoutAnimationTo(RoutingService.monthlyExpenses),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: Colors.greenAccent.withValues(alpha: 0.8),
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
                              card['year'] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (card['price']!.isNotEmpty)
                              Icon(
                                Icons.money_outlined,
                                color: Colors.greenAccent,
                              ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 6),
                              child: Text(
                                card['price']!.isEmpty ? "—" : card['price']!,
                                style: TextStyle(
                                  color: card['price']!.isEmpty
                                      ? Colors.white54
                                      : Colors.greenAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              onPressed: () => _removeYearCard(index),
                            ),
                          ],
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
      bottomNavigationBar: BottomNavBar(
        tabIndex: 6,
        showAdd: true,
        onAddPressed: _addYearCard,
      ),
    );
  }
}
