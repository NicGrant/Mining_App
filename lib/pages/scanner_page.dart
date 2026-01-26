// lib/pages/scanner_page.dart

import 'package:flutter/material.dart';
import '../models/bitaxe_device.dart';
import '../services/bitaxe_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final BitaxeScanner _scanner = BitaxeScanner();

  bool _scanning = false;
  List<BitaxeDevice> _devices = [];
  String _status = 'Tap scan to find Bitaxe miners';

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _devices.clear();
      _status = 'Scanning local network...';
    });

    final results = await _scanner.scan();

    setState(() {
      _devices = results;
      _scanning = false;
      _status = results.isEmpty
          ? 'No Bitaxe devices found'
          : 'Found ${results.length} device(s)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan for Miners')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _scanning ? null : _startScan,
                  child: Text(_scanning ? 'Scanning...' : 'Scan Network'),
                ),
                const SizedBox(height: 12),
                Text(_status),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  leading: const Icon(Icons.memory),
                  title: Text(device.hostname),
                  subtitle: Text('${device.model} • ${device.ip}'),
                  onTap: () {
                    // Return this miner to Dashboard
                    Navigator.pop(context, device);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
