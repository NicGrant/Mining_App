import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

import '../models/bitaxe_device.dart';

class BitaxeScanner {
  static const Duration timeout = Duration(seconds: 1);
  static const int batchSize = 20;

  /// Scan entire local subnet
  Future<List<BitaxeDevice>> scan() async {
    final subnet = await _getSubnet();
    if (subnet == null) {
      debugPrint('❌ Could not determine subnet');
      return [];
    }

    debugPrint('🔍 Scanning subnet: ${subnet}0/24');

    final results = <BitaxeDevice>[];

    // Generate IP list
    final ips = List.generate(254, (i) => '$subnet${i + 1}');

    // Scan in batches to limit concurrency
    for (int i = 0; i < ips.length; i += batchSize) {
      final batch = ips.skip(i).take(batchSize);

      final futures = batch.map(scanSingleIp).toList();
      final devices = await Future.wait(futures);

      results.addAll(devices.whereType<BitaxeDevice>());
    }

    debugPrint('✅ Scan complete. Found ${results.length} device(s)');
    return results;
  }

  /// Scan a single IP (manual or automated)
Future<BitaxeDevice?> scanSingleIp(String ipOrHost) async {
  Uri uri;

  try {
    // Parse optional port
    String host = ipOrHost;
    int port = 80; // default HTTP port

    if (ipOrHost.contains(':')) {
      final parts = ipOrHost.split(':');
      host = parts[0];
      port = int.tryParse(parts[1]) ?? 80;
    }

    // Proper Uri with host and port separated
    uri = Uri(scheme: 'http', host: host, port: port, path: '/api/system');

    debugPrint('➡️ Probing $uri');

    final response = await http.get(uri).timeout(const Duration(seconds: 2));

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);

    if (!_looksLikeBitaxe(json)) return null;

    debugPrint('✅ Bitaxe found at $ipOrHost');
    return BitaxeDevice.fromJson(ipOrHost, json);
  } catch (e) {
    debugPrint('❌ Error probing $ipOrHost: $e');
    return null;
  }
}



  /// Determine if response matches Bitaxe structure
  bool _looksLikeBitaxe(Map<String, dynamic> json) {
    return json.containsKey('model') &&
        json.containsKey('hostname');
  }

  /// Determine local subnet
  Future<String?> _getSubnet() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();

    if (ip == null || !ip.contains('.')) return null;

    return ip.substring(0, ip.lastIndexOf('.') + 1);
  }
}
