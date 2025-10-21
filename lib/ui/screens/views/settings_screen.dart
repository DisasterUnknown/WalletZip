import 'package:expenso/ui/widgets/bottom_nav_bar.dart';
import 'package:expenso/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Settings",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: const Center(child: Text("Welcome to Expenso")),
      bottomNavigationBar: BottomNavBar(
        tabIndex: 5,
        showAdd: false,
        onAddPressed: () {
          print("Add tapped");
        },
      ),
    );
  }
}
