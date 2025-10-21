import 'dart:ui';
import 'package:expenso/services/routing_service.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int tabIndex; 
  final Function()? onAddPressed; 
  final bool showAdd;

  const BottomNavBar({
    super.key,
    this.tabIndex = 1,
    this.onAddPressed,
    this.showAdd = true,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.white;
    const Color inactiveColor = Colors.white38;

    Widget buildTab(IconData icon, String route, int index) {
      bool isActive = index == tabIndex;
      return GestureDetector(
        onTap: () => RoutingService().navigateWithoutAnimationTo(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isActive
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 28,
          ),
        ),
      );
    }

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTab(Icons.dashboard_customize_outlined, RoutingService.dashboard, 1),
              buildTab(Icons.category_outlined, RoutingService.categories, 2),

              if (showAdd)
                GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(color: Colors.white24, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),

              buildTab(Icons.badge_outlined, RoutingService.budget, 4),
              buildTab(Icons.settings_outlined, RoutingService.settings, 5),
            ],
          ),
        ),
      ),
    );
  }
}
