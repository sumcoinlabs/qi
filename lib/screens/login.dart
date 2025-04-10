import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/biometric_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricLogin();
  }

  Future<void> _checkBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('biometric_enabled') ?? false;
    final token = prefs.getString('token');

    if (enabled && token != null) {
      final didAuth = await BiometricHelper.authenticateWithBiometrics();
      if (didAuth && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _login() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showError('No internet connection.');
      return;
    }

    setState(() => _isLoading = true);

    const maxRetries = 3;
    const timeoutDuration = Duration(seconds: 10);
    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;
      try {
        success = await AuthService.login(
          _email.text,
          _password.text,
        ).timeout(timeoutDuration);
      } on TimeoutException {
        if (attempt == maxRetries) {
          _showError('Server not responding. Please try again shortly.');
        }
      } catch (e) {
        if (attempt == maxRetries) {
          _showError('Login failed. Please check your server or credentials.');
        }
      }
    }

    setState(() => _isLoading = false);

    if (success) {
      _promptEnableBiometrics();
    }
  }

  Future<void> _promptEnableBiometrics() async {
    final canUseBiometrics = await BiometricHelper.canCheckBiometrics();
    if (!canUseBiometrics) {
      _goToHome();
      return;
    }

    final shouldEnable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Biometric Login?'),
        content: const Text('Would you like to enable Face ID / Touch ID for future logins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', shouldEnable ?? false);

    _goToHome();
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sign in to QI Exchange', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      keyboardAppearance: Brightness.light,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      keyboardAppearance: Brightness.light,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text('Create an account'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/about'),
                      child: const Text('About this app'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
