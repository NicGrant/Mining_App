import 'package:flutter/material.dart';
import '../models/bitaxe_device.dart';
import '../pages/scanner_page.dart';
import '/main.dart';

class MinersPage extends StatefulWidget {
  const MinersPage({super.key});

  @override
  State<MinersPage> createState() => _MinersPageState();
}

class _MinersPageState extends State<MinersPage> {
  Future<void> _openScanner() async {
    final BitaxeDevice? device = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerPage(),
      ),
    );

    if (device == null) return;

    // Prevent duplicates
    final exists = minersList.any((m) => m.ip == device.ip);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Miner already added')),
      );
      return;
    }

    setState(() {
      minersList.add(device);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openScanner,
          ),
        ],
      ),
      body: minersList.isEmpty
          ? const Center(child: Text('No miners added yet'))
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
