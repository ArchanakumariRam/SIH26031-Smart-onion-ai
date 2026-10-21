class HistoricalPricePoint {
  final String month;
  final String monthLocal;
  final int currentYearPrice;
  final int lastYearPrice;
  final double arrivalIndex;

  HistoricalPricePoint({
    required this.month,
    required this.monthLocal,
    required this.currentYearPrice,
    required this.lastYearPrice,
    required this.arrivalIndex,
  });
}

class SellingPrediction {
  final int sellingScore; // 0 to 100
  final String verdict; // "HOLD" | "SELL_NOW" | "SELL_PARTIAL"
  final String verdictTitle;
  final String verdictDescription;
  final int expectedPriceIn15Days;
  final int expectedPriceIn30Days;
  final double confidencePercentage;
  final List<MarketFactor> factors;

  SellingPrediction({
    required this.sellingScore,
    required this.verdict,
    required this.verdictTitle,
    required this.verdictDescription,
    required this.expectedPriceIn15Days,
    required this.expectedPriceIn30Days,
    required this.confidencePercentage,
    required this.factors,
  });
}

class MarketFactor {
  final String title;
  final String impact; // "POSITIVE" | "NEGATIVE" | "NEUTRAL"
  final String description;
  final int impactPoints; // e.g. +15 or -10

  MarketFactor({
    required this.title,
    required this.impact,
    required this.description,
    required this.impactPoints,
  });
}

class CityRateComparison {
  final String cityName;
  final String state;
  final String mandiName;
  final int modalPrice;
  final int minPrice;
  final int maxPrice;
  final int lastYearModalPrice;
  final int distanceKm;
  final bool isHighest;
  final bool isLowest;

  CityRateComparison({
    required this.cityName,
    required this.state,
    required this.mandiName,
    required this.modalPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.lastYearModalPrice,
    required this.distanceKm,
    this.isHighest = false,
    this.isLowest = false,
  });

  int get yearlyDifference => modalPrice - lastYearModalPrice;
  double get yearlyPercentageChange => ((modalPrice - lastYearModalPrice) / lastYearModalPrice) * 100;
}
