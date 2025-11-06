import 'package:expenso/ui/screens/pages/add_new_transaction_record_page.dart';
import 'package:flutter/material.dart';
import '../ui/screens/views/expence_record_screen.dart';
import '../ui/screens/pages/year_expenses_page.dart';
import '../ui/screens/pages/monthly_expenses_page.dart';
import '../ui/screens/views/categories_screen.dart';
import '../ui/screens/views/settings_screen.dart';
import '../ui/screens/views/budget_screen.dart';
import '../ui/screens/views/dashboard_screen.dart';

class RoutingService {
  static final RoutingService _instance = RoutingService._internal();
  factory RoutingService() => _instance;
  RoutingService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String dashboard = '/';
  static const String addUpdateTransaction = '/add-update-transaction';
  static const String expenceRecord = '/expence-record';
  static const String yearExpenses = '/year-expenses';
  static const String monthlyExpenses = '/monthly-expenses';
  static const String categories = '/categories';
  static const String settings = '/settings';
  static const String budget = '/budget';

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
        expenceRecord: (context) => const HomeScreen(),
        addUpdateTransaction: (context) => const AddNewTransactionRecordPage(),
        yearExpenses: (context) => const YearExpensesPage(),
        monthlyExpenses: (context) => const MonthlyExpensesPage(),
        categories: (context) => const CategoriesScreen(),
        settings: (context) => const SettingsScreen(),
        budget: (context) => const BudgetScreen(),
        dashboard: (context) => const DashboardScreen(),
      };
}
