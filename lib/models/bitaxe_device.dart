class BitaxeDevice {
  final String ip;
  final String model;
  final String hostname;

  // New fields for stats
  double? hashRate;          // current hashrate
  double? temp;              // current temperature
  double? errorPercentage;   // error %

  BitaxeDevice({
    required this.ip,
    required this.model,
    required this.hostname,
    this.hashRate,
    this.temp,
    this.errorPercentage,
  });

  factory BitaxeDevice.fromJson(String ip, Map<String, dynamic> json) {
    return BitaxeDevice(
      ip: ip,
      model: json['model'] ?? 'Unknown',
      hostname: json['hostname'] ?? ip,
      hashRate: (json['hashRate'] as num?)?.toDouble() ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0,
      errorPercentage: (json['errorPercentage'] as num?)?.toDouble() ?? 0,
    );
  }

  // Method to update stats from API response
  void updateFromJson(Map<String, dynamic> json) {
    hashRate = (json['hashRate'] as num?)?.toDouble() ?? hashRate;
    temp = (json['temp'] as num?)?.toDouble() ?? temp;
    errorPercentage = (json['errorPercentage'] as num?)?.toDouble() ?? errorPercentage;
  }
}
