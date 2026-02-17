class BitaxeDevice {
  final String ip;
  final String model;      // BM1370, etc
  final String hostname;

  // Live stats
  double hashRate;
  double temp;
  double errorPercentage;
  double power;

  // New fields
  double bestDifficulty; // 0 if unknown
  String poolName;

  BitaxeDevice({
    required this.ip,
    required this.model,
    required this.hostname,
    this.hashRate = 0,
    this.temp = 0,
    this.errorPercentage = 0,
    this.power = 0,
    this.bestDifficulty = 0,
    this.poolName = '--',
  });

  factory BitaxeDevice.fromJson(String ip, Map<String, dynamic> json) {
    return BitaxeDevice(
      ip: ip,
      model: json['ASICModel'] ?? 'Unknown',
      hostname: json['hostname'] ?? ip,
      hashRate: (json['hashRate'] as num?)?.toDouble() ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0,
      errorPercentage: (json['errorPercentage'] as num?)?.toDouble() ?? 0,
      power: (json['power'] as num?)?.toDouble() ?? 0,
      bestDifficulty: (json['bestDifficulty'] as num?)?.toDouble() ?? 0,
      poolName: json['poolName'] ?? '--',
    );
  }

  void updateFromJson(Map<String, dynamic> json) {
    hashRate = (json['hashRate'] as num?)?.toDouble() ?? hashRate;
    temp = (json['temp'] as num?)?.toDouble() ?? temp;
    errorPercentage = (json['errorPercentage'] as num?)?.toDouble() ?? errorPercentage;
    power = (json['power'] as num?)?.toDouble() ?? power;
    bestDifficulty = (json['bestDifficulty'] as num?)?.toDouble() ?? bestDifficulty;
    poolName = json['poolName'] ?? poolName;
  }
}
