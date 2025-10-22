import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
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

      floatingActionButton: FloatingAddBtn(),

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
