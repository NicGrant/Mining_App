import 'package:flutter/material.dart';
import '../models/bitaxe_device.dart';
import '/ui/glass_card.dart';

class MinerCard extends StatelessWidget {
  final BitaxeDevice miner;

  const MinerCard({super.key, required this.miner});

  Color _tempColor(double temp) {
    if (temp < 55) return Colors.greenAccent;
    if (temp < 75) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Color _statusColor() {
    if (miner.hashRate <= 0) return Colors.grey;
    return Colors.greenAccent;
  }

  double _tempProgress() {
    return (miner.temp / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final tempColor = _tempColor(miner.temp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // space between cards
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Row: Status + Hostname + Hashrate
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor(),
                      boxShadow: [
                        BoxShadow(
                          color: _statusColor().withOpacity(0.6),
                          blurRadius: 8,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      miner.hostname,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "${miner.hashRate.toStringAsFixed(1)} H/s",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Temperature Bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _tempProgress(),
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation(tempColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${miner.temp.toStringAsFixed(1)}°C",
                    style: TextStyle(
                      fontSize: 13,
                      color: tempColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// Best Diff and Pool on the same line (compact)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Best Diff: ${miner.bestDifficulty.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    "Pool: ${miner.poolName.isNotEmpty && miner.poolName != '--' ? miner.poolName : 'Unknown'}",
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
