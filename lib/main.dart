import 'package:flutter/material.dart';
import 'services/routing_service.dart';

void main() {
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
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        debugShowCheckedModeBanner: false,
        navigatorKey: routing.navigatorKey,
        initialRoute: RoutingService.expence_record,
        routes: routing.routes,
      ),
    );
  }
}
