import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int userCount = 0;
  int exchangeCount = 0;
  String role = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRole = prefs.getString('auth_role') ?? 'user';

      setState(() {
        role = savedRole;
      });

      if (savedRole == 'admin') {
        await fetchAdminStats();
      }
    } catch (e) {
      print('[ERROR] Failed to load shared preferences: $e');
      setState(() {
        role = 'user';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAdminStats() async {
    try {
      final response = await http.get(Uri.parse('http://159.118.235.180:5000/admin/dashboard'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userCount = data['users'];
          exchangeCount = data['exchanges'];
        });
      }
    } catch (e) {
      print('[ERROR] Failed to fetch admin stats: $e');
    }
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
        title: Text(role == 'admin' ? 'Admin Dashboard' : 'User Dashboard'),
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
            : role == 'admin'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Admin Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text('👤 Total Users: $userCount'),
                      Text('📄 Total Exchanges: $exchangeCount'),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Welcome to your user dashboard!', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Here you’ll eventually manage your own exchanges.'),
                    ],
                  ),
      ),
    );
  }
}
