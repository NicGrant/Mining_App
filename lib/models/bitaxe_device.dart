class BitaxeDevice {
  final String ip;
  final String model;      // BM1370, etc
  final String hostname;

  // Live stats
  double hashRate;
  double temp;
  double errorPercentage;
  double power;

  BitaxeDevice({
    required this.ip,
    required this.model,
    required this.hostname,
    this.hashRate = 0,
    this.temp = 0,
    this.errorPercentage = 0,
    this.power = 0,
  });

  /// Create device from API response
  factory BitaxeDevice.fromJson(String ip, Map<String, dynamic> json) {
    return BitaxeDevice(
      ip: ip,
      model: json['ASICModel'] ?? 'Unknown',
      hostname: json['hostname'] ?? ip,
      hashRate: (json['hashRate'] as num?)?.toDouble() ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0,
      errorPercentage:
          (json['errorPercentage'] as num?)?.toDouble() ?? 0,
      power: (json['power'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Update stats without replacing object (important for UI)
  void updateFromJson(Map<String, dynamic> json) {
    hashRate = (json['hashRate'] as num?)?.toDouble() ?? hashRate;
    temp = (json['temp'] as num?)?.toDouble() ?? temp;
    errorPercentage =
        (json['errorPercentage'] as num?)?.toDouble() ?? errorPercentage;
    power = (json['power'] as num?)?.toDouble() ?? power;
  }
}