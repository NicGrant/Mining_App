import 'package:flutter/material.dart';
import '../models/bitaxe_device.dart';
import '../widgets/miner_card.dart';

class MinersPage extends StatelessWidget {
  final List<BitaxeDevice> miners;

  const MinersPage({super.key, required this.miners});

  @override
  Widget build(BuildContext context) {
    if (miners.isEmpty) {
      return const Center(
        child: Text('No miners added yet'),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: miners.length,
        itemBuilder: (context, index) {
          final miner = miners[index];
          return MinerCard(miner: miner);
        },
      ),
    );
  }
}
