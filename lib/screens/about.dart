import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'This app was built to help Qualified Intermediaries manage 1031 Exchanges.\n\nIt supports automated workflows, client dashboards, and document handling, all in one place.',
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
