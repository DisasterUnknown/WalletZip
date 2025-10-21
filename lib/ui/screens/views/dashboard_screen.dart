import 'package:expenso/ui/widgets/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:expenso/ui/widgets/status_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Dashboard",
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
      bottomNavigationBar: BottomNavBar(
        tabIndex: 1,
        showAdd: false,
        onAddPressed: () {
          print("Add tapped on Home");
        },
      ),
    );
  }
}
