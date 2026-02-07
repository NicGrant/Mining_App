import 'dart:async';
import 'package:flutter/material.dart';

import '../models/bitaxe_device.dart';
import '../models/graph_point.dart';
import '../ui/glass_card.dart';
import '../widgets/app_background.dart';
import '../widgets/hashrate_chart.dart';

class DashboardPage extends StatefulWidget {
  final List<BitaxeDevice> miners;

  const DashboardPage({super.key, required this.miners});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedGraphRange = '1H';

  final List<GraphPoint> hashrateHistory = [];
  static const int maxPoints = 120;

  Timer? _sampleTimer;

  @override
  void initState() {
    super.initState();

    // 🔁 Sample every 3 seconds
    _sampleTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _recordHashrateSample(),
    );
  }

  @override
  void dispose() {
    _sampleTimer?.cancel();
    super.dispose();
  }

  void _recordHashrateSample() {
    if (widget.miners.isEmpty) return;

    final totalHashrate = widget.miners.fold<double>(
      0,
      (sum, miner) => sum + miner.hashRate,
    );

    setState(() {
      hashrateHistory.add(
        GraphPoint(DateTime.now(), totalHashrate),
      );

      if (hashrateHistory.length > maxPoints) {
        hashrateHistory.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalHashrate =
        widget.miners.fold(0, (sum, miner) => sum + miner.hashRate);

    final double avgTemp = widget.miners.isEmpty
        ? 0
        : widget.miners.fold(0.0, (sum, miner) => sum + miner.temp) /
            widget.miners.length;

    final double errorPercentage = widget.miners.isEmpty
        ? 0
        : widget.miners.fold(0.0,
                (sum, miner) => sum + miner.errorPercentage) /
            widget.miners.length;

    return AppBackground(
      child: Column(
        children: [
          // ---------- Header ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(width: 48),
                Text(
                  'HashWatcher',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Icon(Icons.notifications, color: Colors.white),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ---------- GRAPH ----------
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hashrate (MH/s)',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 150,
                          child: HashrateChart(
                            data: hashrateHistory,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['1H', '6H', '24H', '7D', '30D']
                              .map(
                                (range) => ChoiceChip(
                                  label: Text(range),
                                  selected: selectedGraphRange == range,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedGraphRange = range;
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------- STATS ----------
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _statCard('Total Miners',
                          widget.miners.length.toString()),
                      _statCard('Total Hashrate',
                          totalHashrate.toStringAsFixed(2)),
                      _statCard('Avg Temp',
                          avgTemp.toStringAsFixed(1)),
                      _statCard('Error %',
                          errorPercentage.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return GlassCard(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
