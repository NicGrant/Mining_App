class BitaxeDevice {
  final String ip;
  final String model;
  final String hostname;

  BitaxeDevice({
    required this.ip,
    required this.model,
    required this.hostname,
  });

  factory BitaxeDevice.fromJson(
    String ip,
    Map<String, dynamic> json,
  ) {
    return BitaxeDevice(
      ip: ip,
      model: json['model'] ?? 'Unknown',
      hostname: json['hostname'] ?? ip,
    );
  }
}
