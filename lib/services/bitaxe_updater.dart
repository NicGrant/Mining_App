import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/bitaxe_device.dart';

/// Polls Bitaxe devices for live updates
class BitaxeUpdater {
  final List<BitaxeDevice> devices;
  final Duration interval;
  Timer? _timer;

  /// Called after a device is updated
  final VoidCallback onUpdate;

  BitaxeUpdater({
    required this.devices,
    required this.onUpdate,
    this.interval = const Duration(seconds: 3),
  });

  /// Start polling
  void start() {
    stop(); // safety
    _timer = Timer.periodic(interval, (_) => _updateAll());
    debugPrint('⏱ Bitaxe updater started');
  }

  /// Stop polling
  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint('⏹ Bitaxe updater stopped');
  }

  Future<void> _updateAll() async {
    for (final device in devices) {
      await _updateDevice(device);
    }
    onUpdate(); // 🔥 notify UI once per cycle
  }

  Future<void> _updateDevice(BitaxeDevice device) async {
    try {
      final uri = Uri(
        scheme: 'http',
        host: device.ip,
        port: 80,
        path: '/api/system/info',
      );

      final response =
          await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return;

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      // 🔥 Update existing device instead of replacing it
      device.updateFromJson(jsonData);

    } catch (e) {
      debugPrint('❌ Error updating ${device.ip}: $e');
    }
  }
}
