import 'package:expenso/services/log_service.dart';
import 'package:expenso/services/startup_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'services/routing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StartupService.checkAndAddBudgetIncome();
  await CustomColors.init();

  await LogService.init();
  LogService.log("Info", "App started");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    CustomColors.themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final routing = RoutingService();

    return SafeArea(
      child: MaterialApp(
        title: 'Expenso',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: CustomColors.getColorSync('primary'),
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: routing.navigatorKey,
        initialRoute: RoutingService.dashboard,
        routes: routing.routes,
      ),
    );
  }
}
