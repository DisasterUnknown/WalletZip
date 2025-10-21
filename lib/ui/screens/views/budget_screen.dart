import 'package:expenso/ui/widgets/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:expenso/ui/widgets/status_card.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Budget",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              BudgetCard(
                title: "Total Difference",
                income: "54654",
                expense: "34120",
                remaining: "20534",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 4, showAdd: false),
    );
  }
}
