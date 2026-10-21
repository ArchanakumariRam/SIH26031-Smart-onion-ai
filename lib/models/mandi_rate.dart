class MandiRate {
  final String id;
  final String mandiName;
  final String mandiNameLocal;
  final String district;
  final String state;
  final String variety;
  final int minPrice;
  final int maxPrice;
  final int modalPrice;
  final int dailyChange; // e.g. +50 or -30
  final double arrivalTons;
  final double distanceKm;
  final DateTime lastUpdated;

  MandiRate({
    required this.id,
    required this.mandiName,
    required this.mandiNameLocal,
    required this.district,
    required this.state,
    required this.variety,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.dailyChange,
    required this.arrivalTons,
    required this.distanceKm,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  // Calculate estimated net profit after transport
  // Assuming average transport & handling cost: ₹2.5 per quintal per km + ₹40 loading/labour
  double calculateNetProfit({
    required double quantityQuintals,
    double costPerKmPerQuintal = 2.5,
    double handlingPerQuintal = 40.0,
  }) {
    final grossRevenue = modalPrice * quantityQuintals;
    final transportCost = (distanceKm * costPerKmPerQuintal + handlingPerQuintal) * quantityQuintals;
    return grossRevenue - transportCost;
  }
}
