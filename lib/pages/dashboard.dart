import 'package:flutter/material.dart';
import '../pages/scanner_page.dart';
import '../main.dart'; // For minersList

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add Miner button - bright accent
          ElevatedButton.icon(
            onPressed: () async {
              final newMiner = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScannerPage()),
              );

              if (newMiner != null) {
                setState(() {
                  minersList.add(newMiner);
                });
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Miner'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Bright button
              foregroundColor: Colors.white,   // Text color
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),

          // Dashboard Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardCard(title: 'Total Miners', value: '${minersList.length}'),
              DashboardCard(title: 'Total Hashrate', value: '0 H/s'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              DashboardCard(title: 'Average Temp', value: '0°C'),
              DashboardCard(title: 'Alerts', value: '0'),
            ],
          ),
        ],
      ),
    );
  }
}

// Dashboard Card for dark theme
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850], // Dark card
      shadowColor: Colors.black54,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70, // Slightly lighter text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
