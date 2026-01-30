import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import '../models/bitaxe_device.dart';

class BitaxeScanner {
  static const Duration timeout = Duration(seconds: 5);
  static const int batchSize = 15; // number of concurrent requests

  /// Scan the local subnet
  Future<List<BitaxeDevice>> scan() async {
    final subnet = await _getSubnet();
    if (subnet == null) {
      debugPrint('❌ Could not determine subnet');
      return [];
    }

    debugPrint('🔍 Scanning subnet: ${subnet}0/24');

    final results = <BitaxeDevice>[];

    // Generate all possible IPs in subnet
    final ips = List.generate(254, (i) => '$subnet${i + 1}');

    for (int i = 0; i < ips.length; i += batchSize) {
      final batch = ips.skip(i).take(batchSize);

      final futures = batch.map(scanSingleIp).toList();
      final devices = await Future.wait(futures);

      results.addAll(devices.whereType<BitaxeDevice>());
    }

    debugPrint('✅ Scan complete. Found ${results.length} device(s)');
    return results;
  }

  /// Scan a single IP
  Future<BitaxeDevice?> scanSingleIp(String ipOrHost) async {
    try {
      String host = ipOrHost;
      int port = 80;

      if (ipOrHost.contains(':')) {
        final parts = ipOrHost.split(':');
        host = parts[0];
        port = int.tryParse(parts[1]) ?? 80;
      }

      final uri = Uri(scheme: 'http', host: host, port: port, path: '/api/system/info');
      debugPrint('➡️ Probing $uri');

      final response = await http.get(uri).timeout(timeout);

      if (response.statusCode != 200) {
        debugPrint('⚠️ $ipOrHost returned status ${response.statusCode}');
        return null;
      }

      final json = jsonDecode(response.body);

      if (!_looksLikeBitaxe(json)) {
        debugPrint('⚠️ $ipOrHost is not a Bitaxe device');
        return null;
      }

      debugPrint('✅ Bitaxe found at $ipOrHost');
      return BitaxeDevice.fromJson(ipOrHost, json);
    } catch (e) {
      debugPrint('❌ Error probing $ipOrHost: $e');
      return null;
    }
  }

  /// Manual probe (single IP or IP:port)
  Future<BitaxeDevice?> probeManual(String ipOrHost) async {
    return await scanSingleIp(ipOrHost);
  }

  /// Determine if response matches Bitaxe structure
  bool _looksLikeBitaxe(Map<String, dynamic> json) {
    return json.containsKey('model') && json.containsKey('hostname') || json.containsKey('ASICModel');
  }

  /// Determine local subnet from Wi-Fi IP
  Future<String?> _getSubnet() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    debugPrint('iPhone Wi-Fi IP: $ip');

    if (ip == null || !ip.contains('.')) return null;
    return ip.substring(0, ip.lastIndexOf('.') + 1);
  }
}
