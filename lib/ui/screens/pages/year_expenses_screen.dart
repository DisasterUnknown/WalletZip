import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class YearExpensesScreen extends StatelessWidget {
  const YearExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "YearExpensesScreen",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: Center(child: Text("Welcome to Expenso")),
    );
  }
}
