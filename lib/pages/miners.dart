import 'package:flutter/material.dart';
import '../main.dart';

class MinersPage extends StatelessWidget {
  const MinersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Miners')),
      body: minersList.isEmpty
          ? const Center(child: Text('No miners added'))
          : ListView.builder(
              itemCount: minersList.length,
              itemBuilder: (context, index) {
                final miner = minersList[index];
                return ListTile(
                  leading: const Icon(Icons.memory),
                  title: Text(miner.hostname),
                  subtitle: Text('${miner.model} • ${miner.ip}'),
                );
              },
            ),
    );
  }
}
