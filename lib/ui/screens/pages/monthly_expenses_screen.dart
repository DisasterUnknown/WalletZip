import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MonthlyExpensesScreen extends StatelessWidget {
  const MonthlyExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "MonthlyExpensesScreen",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: Center(child: Text("Welcome to Expenso")),
    );
  }
}
