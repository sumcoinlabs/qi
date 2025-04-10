import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    await Future.delayed(Duration.zero); // Allow first frame to render

    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('auth_token') != null;

    // Navigate after checking prefs
    Navigator.pushReplacementNamed(context, hasToken ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to QI Exchange', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
