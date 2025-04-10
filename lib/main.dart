import 'package:flutter/material.dart';
import 'package:qi_app/screens/splash.dart';
import 'package:qi_app/screens/login.dart';
import 'package:qi_app/screens/home.dart';
import 'package:qi_app/screens/about.dart';
import 'package:qi_app/screens/dashboard.dart';
import 'package:qi_app/screens/exchange_crud.dart';
import 'package:qi_app/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration.zero); // Allows UI to render cleanly
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QI Exchange',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/exchange-crud': (context) => const ExchangeCrudScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
