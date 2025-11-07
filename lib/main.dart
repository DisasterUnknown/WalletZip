import 'package:expenso/services/startup_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'services/routing_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StartupService.checkAndAddBudgetIncome();
  await CustomColors.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routing = RoutingService();

    return SafeArea(
      child: MaterialApp(
        title: 'Expenso',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: CustomColors.getThemeColor(
            context,
            'primary',
          ),
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: routing.navigatorKey,
        initialRoute: RoutingService.dashboard,
        routes: routing.routes,
      ),
    );
  }
}
