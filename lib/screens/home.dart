import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = '';
  String role = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadUser);
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedEmail = prefs.getString('auth_email') ?? '';
    final loadedRole = prefs.getString('auth_role') ?? '';

    print('[DEBUG] Loaded email: $loadedEmail');
    print('[DEBUG] Loaded role: $loadedRole');

    setState(() {
      email = loadedEmail;
      role = loadedRole;
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QI Exchange - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back, $email', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Role: ${role.isEmpty ? '(not set)' : role}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    child: Text(role == 'admin' ? 'Go to Admin Dashboard' : 'Go to User Dashboard'),
                  ),
                ],
              ),
      ),
    );
  }
}
