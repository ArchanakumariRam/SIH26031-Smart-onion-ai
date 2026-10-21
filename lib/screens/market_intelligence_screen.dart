import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/mandi_rate.dart';
import '../models/market_trend.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../services/mandi_service.dart';
import '../widgets/animated_price_chart.dart';
import '../widgets/animated_selling_gauge.dart';
import '../widgets/audio_speak_button.dart';
import 'price_alert_screen.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() => _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _qtyController = TextEditingController(text: "50");
  String _selectedFarmerCity = AppConstants.majorDistricts[0];

  final MandiService _mandiService = MandiService();
  List<CityRateComparison> _cityRates = [];
  List<HistoricalPricePoint> _historicalData = [];
  List<Map<String, dynamic>> _netEarnings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _recalculateNetEarnings() {
    final qty = double.tryParse(_qtyController.text) ?? 50.0;
    setState(() {
      _netEarnings = _mandiService.calculateTrueNetEarnings(
        quantityQuintals: qty,
        originCity: _selectedFarmerCity,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);
    final lang = appState.currentLanguage;

    if (_selectedFarmerCity == AppConstants.majorDistricts[0] &&
        appState.currentDistrict != AppConstants.majorDistricts[0]) {
      _selectedFarmerCity = appState.currentDistrict;
    }

    final prediction = _mandiService.getSellingPrediction(languageCode: lang);
    _cityRates = _mandiService.getAllIndiaCityRates(originCity: _selectedFarmerCity);
    _historicalData = _mandiService.getHistoricalComparisonData();
    if (_netEarnings.isEmpty) {
      _netEarnings = _mandiService.calculateTrueNetEarnings(
        quantityQuintals: double.tryParse(_qtyController.text) ?? 50.0,
        originCity: _selectedFarmerCity,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.translate("market_intel"),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.onionPurple,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: AppColors.onionPurple,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: loc.translate("when_to_sell_tab")),
            Tab(text: loc.translate("cities_graph_tab")),
            Tab(text: loc.translate("true_net_tab")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: When Should I Sell? (Predictive Trend & Selling Score)
          _buildWhenToSellTab(loc, prediction),

          // TAB 2: Indian Onion Market: High/Low Cities & Graphs
          _buildCitiesAndGraphTab(loc),

          // TAB 3: Which Market Gives Best Price? (True Net Earnings with Transport)
          _buildTrueNetEarningsTab(loc),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: WHEN TO SELL MY ONION? (विक्री सल्ला)
  // ==========================================
  Widget _buildWhenToSellTab(LocalizationService loc, SellingPrediction prediction) {
    final audioText = """
${loc.translate("selling_score_title")}. 
${prediction.verdictTitle}.
${prediction.verdictDescription}
${loc.translate("forecast_15_days")}: ₹${prediction.expectedPriceIn15Days} ${loc.translate("per_quintal")}.
${loc.translate("forecast_30_days")}: ₹${prediction.expectedPriceIn30Days} ${loc.translate("per_quintal")}.
""";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card with Animated Radial Selling Gauge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.translate("selling_score_title"),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    AudioSpeakButton(textToSpeak: audioText),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSellingGauge(
                  score: prediction.sellingScore,
                  verdict: prediction.verdict,
                  verdictTitle: prediction.verdictTitle,
                ),
                const SizedBox(height: 16),
                Text(
                  prediction.verdictDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Price Forecast Target Cards
          Row(
            children: [
              Expanded(
                child: _buildForecastCard(
                  period: loc.translate("forecast_15_days"),
                  expectedPrice: "₹${prediction.expectedPriceIn15Days}",
                  changeText: "+₹350 - ₹500/${loc.translate('per_quintal')}",
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildForecastCard(
                  period: loc.translate("forecast_30_days"),
                  expectedPrice: "₹${prediction.expectedPriceIn30Days}",
                  changeText: "+₹600 - ₹800/${loc.translate('per_quintal')}",
                  icon: Icons.event,
                  iconColor: AppColors.onionPurple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Price Alert Banner
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PriceAlertScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_active, color: Colors.deepPurple, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.translate("price_alerts_title"),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        Text(
                          loc.currentLanguage == 'mr'
                              ? "भाव ₹२,८००+ झाल्यास त्वरित मेसेज मिळवा"
                              : loc.currentLanguage == 'hi'
                                  ? "भाव ₹२,८००+ होने पर तुरंत अलर्ट पाएं"
                                  : "Get push alert when rate crosses ₹2,800+",
                          style: TextStyle(fontSize: 11, color: Colors.purple.shade900),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.deepPurple),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Market Factor Drivers
          Text(
            loc.translate("market_drivers"),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prediction.factors.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final f = prediction.factors[index];
              final isPos = f.impact == "POSITIVE";

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isPos ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPos ? Colors.green.shade200 : Colors.red.shade200,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isPos ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                      color: isPos ? Colors.green.shade800 : Colors.red.shade800,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  f.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isPos ? Colors.green.shade900 : Colors.red.shade900,
                                  ),
                                ),
                              ),
                              Text(
                                "${isPos ? '+' : ''}${f.impactPoints} pts",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: isPos ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            f.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isPos ? Colors.green.shade900 : Colors.red.shade900,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildForecastCard({
    required String period,
    required String expectedPrice,
    required String changeText,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                period,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            expectedPrice,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.onionPurple,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            changeText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.agriGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: INDIAN ONION MARKET: HIGH/LOW CITIES & GRAPH
  // ==========================================
  Widget _buildCitiesAndGraphTab(LocalizationService loc) {
    final highest = _cityRates.firstWhere((c) => c.isHighest, orElse: () => _cityRates.first);
    final lowest = _cityRates.firstWhere((c) => c.isLowest, orElse: () => _cityRates.last);
    final priceGap = highest.modalPrice - lowest.modalPrice;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // High vs Low Summary Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF1A252F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.translate("national_overview"),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.goldAmber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${loc.translate('price_gap')}: ₹$priceGap",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Highest City
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate("highest_city"),
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              highest.cityName,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${highest.modalPrice}",
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Lowest City
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate("lowest_city"),
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lowest.cityName,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${lowest.modalPrice}",
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Interactive Historical Graph: Last Year vs This Year
          AnimatedPriceChart(data: _historicalData),

          const SizedBox(height: 20),

          // All India City Rankings List
          Text(
            loc.translate("national_overview"),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cityRates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final city = _cityRates[index];
              final diff = city.yearlyDifference;
              final isPos = diff >= 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: city.isHighest
                        ? Colors.green.shade400
                        : (city.isLowest ? Colors.orange.shade300 : Colors.grey.shade200),
                    width: (city.isHighest || city.isLowest) ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: city.isHighest
                          ? Colors.green.shade100
                          : (city.isLowest ? Colors.orange.shade100 : Colors.grey.shade100),
                      child: Text(
                        "#${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: city.isHighest ? Colors.green.shade900 : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                city.cityName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              if (city.isHighest) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.translate("highest_city"),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            "${city.mandiName} • ${loc.translate('distance')}: ${city.distanceKm} km",
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${city.modalPrice}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onionPurple,
                          ),
                        ),
                        Text(
                          "${loc.translate('last_year_2025')}: ₹${city.lastYearModalPrice} (${isPos ? '+' : ''}₹$diff)",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isPos ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: WHICH MARKET GIVES BEST PRICE? (TRUE NET EARNINGS)
  // ==========================================
  Widget _buildTrueNetEarningsTab(LocalizationService loc) {
    if (_netEarnings.isEmpty) return const SizedBox();

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final best = _netEarnings.first;
    final bestMandi = best['mandi'] as MandiRate;
    final bestNet = (best['net'] as double).toInt();
    final bestNetPerQtl = (best['netPerQuintal'] as double).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Farmer Origin & Quantity
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate("your_location"),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedFarmerCity,
                      items: AppConstants.majorDistricts.map((d) {
                        return DropdownMenuItem<String>(
                          value: d,
                          child: Text(d, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedFarmerCity = val;
                          });
                          appState.setDistrict(val);
                          _recalculateNetEarnings();
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  loc.translate("enter_quantity"),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "50",
                          suffixText: loc.translate("per_quintal"),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onionPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _recalculateNetEarnings,
                      child: Text(loc.translate("calculate_profit"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Recommended Best Mandi (True Net Winner)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.agriGreen, Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.agriGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldAmber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "★ ${loc.translate('best_mandi_suggestion')}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AudioSpeakButton(
                      textToSpeak:
                          "${bestMandi.mandiNameLocal}. ${loc.translate('net_profit')}: ₹$bestNet. ${loc.translate('net_per_qtl')}: ₹$bestNetPerQtl.",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  bestMandi.mandiNameLocal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${loc.translate('net_profit')}: ₹$bestNet",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${loc.translate('net_per_qtl')}: ₹$bestNetPerQtl (${loc.translate('modal_price')}: ₹${bestMandi.modalPrice})",
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Detailed Deductions Bill / Comparison
          Text(
            loc.translate("deduction_breakdown"),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _netEarnings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _netEarnings[index];
              final m = item['mandi'] as MandiRate;
              final gross = (item['gross'] as double).toInt();
              final freight = (item['freight'] as double).toInt();
              final labour = (item['labour'] as double).toInt();
              final cess = (item['cess'] as double).toInt();
              final net = (item['net'] as double).toInt();
              final netPerQtl = (item['netPerQuintal'] as double).toInt();

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: index == 0 ? AppColors.agriGreen : Colors.grey.shade200,
                    width: index == 0 ? 1.8 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${index + 1}. ${m.mandiNameLocal}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.green.shade50 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${loc.translate('net_profit')}: ₹$net",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: index == 0 ? AppColors.agriGreen : AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    // Bill breakdown row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBillItem(loc.translate("gross_revenue"), "₹$gross"),
                        _buildBillItem(loc.translate("freight_cost"), "-₹$freight"),
                        _buildBillItem(loc.translate("labour_cost"), "-₹$labour"),
                        _buildBillItem(loc.translate("mandi_cess"), "-₹$cess"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${loc.translate('distance')}: ${m.distanceKm} km • ${loc.translate('net_per_qtl')}: ₹$netPerQtl/${loc.translate('per_quintal')}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBillItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
