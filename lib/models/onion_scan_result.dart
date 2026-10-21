class OnionScanResult {
  final String variety;
  final String varietyLocalName;
  final String sizeGrade;
  final String qualityGrade;
  final int qualityScorePercentage;
  final List<String> defectsDetected;
  final int storageViabilityDays;
  final String actionAdvice;
  final int estimatedPriceMin;
  final int estimatedPriceMax;
  final String? imagePath;
  final DateTime timestamp;

  OnionScanResult({
    required this.variety,
    required this.varietyLocalName,
    required this.sizeGrade,
    required this.qualityGrade,
    required this.qualityScorePercentage,
    required this.defectsDetected,
    required this.storageViabilityDays,
    required this.actionAdvice,
    required this.estimatedPriceMin,
    required this.estimatedPriceMax,
    this.imagePath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory OnionScanResult.fromJson(Map<String, dynamic> json, {String? imagePath}) {
    final priceMap = json['estimated_price_range_per_quintal'] as Map<String, dynamic>? ?? {};
    final rawDefects = json['defects_detected'];
    List<String> defects = [];
    if (rawDefects is List) {
      defects = rawDefects.map((e) => e.toString()).toList();
    }

    return OnionScanResult(
      variety: json['variety']?.toString() ?? 'Garwa',
      varietyLocalName: json['variety_local_name']?.toString() ?? 'उन्हाळ कांदा',
      sizeGrade: json['size_grade']?.toString() ?? 'Medium',
      qualityGrade: json['quality_grade']?.toString() ?? 'A',
      qualityScorePercentage: (json['quality_score_percentage'] is num)
          ? (json['quality_score_percentage'] as num).toInt()
          : 88,
      defectsDetected: defects.isEmpty ? ['none'] : defects,
      storageViabilityDays: (json['storage_viability_days'] is num)
          ? (json['storage_viability_days'] as num).toInt()
          : 60,
      actionAdvice: json['action_advice']?.toString() ?? 'कांद्याची प्रत समाधानकारक आहे.',
      estimatedPriceMin: (priceMap['min'] is num) ? (priceMap['min'] as num).toInt() : 2200,
      estimatedPriceMax: (priceMap['max'] is num) ? (priceMap['max'] as num).toInt() : 2650,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variety': variety,
      'variety_local_name': varietyLocalName,
      'size_grade': sizeGrade,
      'quality_grade': qualityGrade,
      'quality_score_percentage': qualityScorePercentage,
      'defects_detected': defectsDetected,
      'storage_viability_days': storageViabilityDays,
      'action_advice': actionAdvice,
      'estimated_price_range_per_quintal': {
        'min': estimatedPriceMin,
        'max': estimatedPriceMax,
      },
      'image_path': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
