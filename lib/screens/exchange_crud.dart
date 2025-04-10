import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class ExchangeCrudScreen extends StatelessWidget {
  const ExchangeCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Exchanges')),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderWidget(),
          Expanded(
            child: Center(
              child: Text(
                'Create, View, Edit, or Delete 1031 Exchange Records.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          FooterWidget(),
        ],
      ),
    );
  }
}
