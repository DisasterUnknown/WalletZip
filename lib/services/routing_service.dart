import 'package:flutter/material.dart';
import '../ui/screens/views/home_screen.dart';
import '../ui/screens/pages/year_expenses_screen.dart';
import '../ui/screens/pages/monthly_expenses_screen.dart';
import '../ui/screens/pages/daily_expenses_screen.dart';
import '../ui/screens/views/categories_screen.dart';
import '../ui/screens/views/settings_screen.dart';
import '../ui/screens/views/budget_screen.dart';
import '../ui/screens/views/dashboard_screen.dart';

class RoutingService {
  static final RoutingService _instance = RoutingService._internal();
  factory RoutingService() => _instance;
  RoutingService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String yearExpenses = '/year-expenses';
  static const String monthlyExpenses = '/monthly-expenses';
  static const String dailyExpenses = '/daily-expenses';
  static const String categories = '/categories';
  static const String settings = '/settings';
  static const String budget = '/budget';
  static const String dashboard = '/dashboard';

  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? navigateWithoutAnimationTo(String routeName) {
    final routeBuilder = routes[routeName];
    if (routeBuilder == null) return null;

    return navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => routeBuilder(context),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }

  Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        yearExpenses: (context) => const YearExpensesScreen(),
        monthlyExpenses: (context) => const MonthlyExpensesScreen(),
        dailyExpenses: (context) => const DailyExpensesScreen(),
        categories: (context) => const CategoriesScreen(),
        settings: (context) => const SettingsScreen(),
        budget: (context) => const BudgetScreen(),
        dashboard: (context) => const DashboardScreen(),
      };
}
