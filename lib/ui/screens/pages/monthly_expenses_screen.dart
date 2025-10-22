import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/floating_action_btn.dart';
import 'package:flutter/material.dart';

class MonthlyExpensesScreen extends StatelessWidget {
  const MonthlyExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argu =
        ModalRoute.of(context)?.settings.arguments as List<String>? ?? ["Unknown", "Unknown"];
    return Scaffold(
      appBar: CustomAppBar(
        title: "${argu[1].substring(0, 3).toUpperCase()} Expenses ${argu[0]}",
        showBackButton: true,
        showHomeButton: false,
      ),
      body: Center(child: Text("${argu[0]} ${argu[1]}")),

      floatingActionButton: FloatingAddBtn(),
    );
  }
}
