import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int userCount = 0;
  int exchangeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final response = await http.get(Uri.parse('http://159.118.235.180:5000/admin/dashboard'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userCount = data['users'];
        exchangeCount = data['exchanges'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Admin Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('👤 Total Users: $userCount'),
            Text('📄 Total Exchanges: $exchangeCount'),
          ],
        ),
      ),
    );
  }
}
