import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/bitaxe_device.dart';

/// This class handles polling Bitaxe devices for updates
class BitaxeUpdater {
  final List<BitaxeDevice> devices;
  final Duration interval;
  Timer? _timer;

  /// Callback called whenever a device is updated
  final void Function(BitaxeDevice updatedDevice) onUpdate;

  BitaxeUpdater({
    required this.devices,
    required this.onUpdate,
    this.interval = const Duration(seconds: 3),
  });

  /// Start the updater
  void start() {
    _timer = Timer.periodic(interval, (_) async {
      for (var device in devices) {
        try {
          final updated = await _fetchDevice(device.ip);
          if (updated != null) {
            onUpdate(updated);
          }
        } catch (e) {
          debugPrint('❌ Error updating ${device.ip}: $e');
        }
      }
    });
  }

  /// Stop the updater
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Fetch latest info from a single device
  Future<BitaxeDevice?> _fetchDevice(String ip) async {
    final uri = Uri(scheme: 'http', host: ip, port: 80, path: '/api/system/info');

    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) return null;

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

    // Use your existing fromJson factory
    return BitaxeDevice.fromJson(ip, jsonData);
  }
}