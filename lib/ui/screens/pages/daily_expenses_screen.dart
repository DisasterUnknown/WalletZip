import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DailyExpensesScreen extends StatelessWidget {
  const DailyExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "DailyExpensesScreen",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: Center(child: Text("Welcome to Expenso")),
    );
  }
}
