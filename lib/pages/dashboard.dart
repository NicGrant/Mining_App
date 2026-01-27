import 'package:flutter/material.dart';
import '../pages/scanner_page.dart';
import '../main.dart'; // For minersList

// ---------- InfoBar Widget ----------
class InfoBar extends StatelessWidget {
  final String label;
  final double value;       // current value
  final double maxValue;    // maximum value for the bar
  final Color color;        // filled bar color

  const InfoBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.color = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (value / maxValue).clamp(0, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                )),
            Text(value.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        const SizedBox(height: 4),
        // Bar
        Container(
          height: 14,
          decoration: BoxDecoration(
            color: Colors.grey[800],   // background of bar
            borderRadius: BorderRadius.circular(7),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ---------- Dashboard Page ----------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    // Example values — replace with real miner stats later
    double totalHashrate = minersList.isEmpty ? 0 : 3500; // H/s
    double avgTemp = minersList.isEmpty ? 0 : 65;        // Celsius
    int alerts = minersList.isEmpty ? 0 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // ---------- Add Miner Button ----------
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
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),

          // ---------- Info Bars ----------
          InfoBar(
            label: 'Total Miners',
            value: minersList.length.toDouble(),
            maxValue: 20,
            color: Colors.orange,
          ),
          InfoBar(
            label: 'Total Hashrate',
            value: totalHashrate,
            maxValue: 10000,
            color: Colors.green,
          ),
          InfoBar(
            label: 'Average Temp',
            value: avgTemp,
            maxValue: 100,
            color: Colors.red,
          ),
          InfoBar(
            label: 'Alerts',
            value: alerts.toDouble(),
            maxValue: 10,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
