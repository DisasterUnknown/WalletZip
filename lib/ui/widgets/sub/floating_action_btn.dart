import 'package:expenso/core/constants/app_constants.dart';
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
        border: Border.all(color: CustomColors.getThemeColor(context, AppColorData.secondary4), width: 1),
        gradient: LinearGradient(
          colors: [CustomColors.getThemeColor(context, AppColorData.floatingbtn1), CustomColors.getThemeColor(context, AppColorData.floatingbtn2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: CustomColors.getThemeColor(context, AppColorData.primary).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: CustomColors.getThemeColor(context, AppColorData.transparent),
        onPressed: () async {
          RoutingService().navigateTo(
            RoutingService.addUpdateTransaction,
            arguments: {'month': month, 'year': year},
          );
        },
        child: Icon(Icons.add, size: 30, color: CustomColors.getThemeColor(context, AppColorData.secondary)),
      ),
    );
  }
}
