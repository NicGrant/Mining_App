import 'package:flutter/material.dart';
import '../models/bitaxe_device.dart';
import '../services/bitaxe_updater.dart';
import '../ui/glass_card.dart';
import '../widgets/app_background.dart';

class DashboardPage extends StatefulWidget {
  final List<BitaxeDevice> miners;
  const DashboardPage({super.key, required this.miners});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedGraphRange = '1H';

  @override
  Widget build(BuildContext context) {
    // Placeholder stats
    double totalHashrate = widget.miners.fold(0, (sum, miner) => sum + (miner.hashRate ?? 0));
    double avgTemp = widget.miners.isEmpty
        ? 0
        : widget.miners.fold(0.0, (sum, miner) => sum + (miner.temp ?? 0)) / widget.miners.length;
    double errorPercentage = widget.miners.isEmpty
        ? 0
        : widget.miners.fold(0.0, (sum, miner) => sum + (miner.errorPercentage ?? 0)) /
            widget.miners.length;

    return AppBackground(
      child: Column(
        children: [
          // Top AppBar with HashWatcher and Bell
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(width: 48), // Placeholder for alignment
                Text('HashWatcher', style: TextStyle(color: Colors.white, fontSize: 24)),
                Icon(Icons.notifications, color: Colors.white),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // ---------- Graph Card ----------
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hashrate (MH/s)', style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 8),
                        Container(
                          height: 150,
                          color: Colors.white.withOpacity(0.05), // placeholder graph
                          child: const Center(child: Text('Graph Placeholder', style: TextStyle(color: Colors.white54))),
                        ),
                        const SizedBox(height: 8),
                        // Graph toggles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['1H', '6H', '24H', '7D', '30D']
                              .map((range) => ChoiceChip(
                                    label: Text(range),
                                    selected: selectedGraphRange == range,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedGraphRange = range;
                                      });
                                    },
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------- Stats Cards ----------
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GlassCard(
                        child: Column(
                          children: [
                            const Text('Total Miners', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 8),
                            Text(widget.miners.length.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GlassCard(
                        child: Column(
                          children: [
                            const Text('Total Hashrate', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 8),
                            Text(totalHashrate.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GlassCard(
                        child: Column(
                          children: [
                            const Text('Avg Temp', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 8),
                            Text(avgTemp.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GlassCard(
                        child: Column(
                          children: [
                            const Text('Error %', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 8),
                            Text(errorPercentage.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ---------- Thermal Efficiency Card ----------
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Thermal Efficiency', style: TextStyle(color: Colors.white54)),
                        SizedBox(height: 8),
                        Center(child: Text('Placeholder: W/MH', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------- Recent Issues Card ----------
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Recent Issues', style: TextStyle(color: Colors.white54)),
                        SizedBox(height: 8),
                        Center(child: Text('No issues detected', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}