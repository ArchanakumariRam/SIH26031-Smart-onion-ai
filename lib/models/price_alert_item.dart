class PriceAlertItem {
  final String id;
  final String mandiName;
  final int targetPrice;
  final String condition; // 'ABOVE' or 'BELOW'
  bool isEnabled;
  final DateTime createdAt;

  PriceAlertItem({
    required this.id,
    required this.mandiName,
    required this.targetPrice,
    required this.condition,
    this.isEnabled = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'mandiName': mandiName,
        'targetPrice': targetPrice,
        'condition': condition,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PriceAlertItem.fromJson(Map<String, dynamic> json) => PriceAlertItem(
        id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        mandiName: json['mandiName']?.toString() ?? 'Lasalgaon APMC',
        targetPrice: (json['targetPrice'] is num) ? (json['targetPrice'] as num).toInt() : 2500,
        condition: json['condition']?.toString() ?? 'ABOVE',
        isEnabled: json['isEnabled'] == true || json['isEnabled'] == 'true',
        createdAt: json['createdAt'] != null
            ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
            : DateTime.now(),
      );
}
