import 'package:expenso/services/routing_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

class FloatingAddBtn extends StatelessWidget {
  final String? month;
  final String? year;
  const FloatingAddBtn({super.key, this.month, this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.getThemeColor(context, 'secondary4'), width: 1),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D0D0D), Color(0xFF2B2B2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: CustomColors.getThemeColor(context, 'primary').withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: CustomColors.getThemeColor(context, 'transparent'),
        onPressed: () async {
          RoutingService().navigateTo(
            RoutingService.addUpdateTransaction,
            arguments: {'month': month, 'year': year},
          );
        },
        child: Icon(Icons.add, size: 30, color: CustomColors.getThemeColor(context, 'secondary')),
      ),
    );
  }
}
