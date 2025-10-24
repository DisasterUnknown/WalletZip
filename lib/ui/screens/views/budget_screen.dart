import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/status_card.dart';
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
            children: [BudgetCard(title: "Lifetime Summary", type: "lifetime")],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(tabIndex: 4, showAdd: false),
    );
  }
}
