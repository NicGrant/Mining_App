class BitaxeStats {
  final double hashRate;
  final double power;
  final double temp;
  final double errorPercentage;
  final double voltage;
  final double current;
  final int uptimeSeconds;
  final int fanRpm;
  final int wifiRssi;

  BitaxeStats({
    required this.hashRate,
    required this.power,
    required this.temp,
    required this.errorPercentage,
    required this.voltage,
    required this.current,
    required this.uptimeSeconds,
    required this.fanRpm,
    required this.wifiRssi,
  });

  factory BitaxeStats.fromJson(Map<String, dynamic> json) {
    return BitaxeStats(
      hashRate: (json['hashRate'] ?? 0).toDouble(),
      power: (json['power'] ?? 0).toDouble(),
      temp: (json['temp'] ?? 0).toDouble(),
      errorPercentage: (json['errorPercentage'] ?? 0).toDouble(),
      voltage: (json['voltage'] ?? 0).toDouble(),
      current: (json['current'] ?? 0).toDouble(),
      uptimeSeconds: json['uptimeSeconds'] ?? 0,
      fanRpm: json['fanrpm'] ?? 0,
      wifiRssi: json['wifiRSSI'] ?? 0,
    );
  }
}