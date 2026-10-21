import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/mandi_rate.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../services/mandi_service.dart';
import '../widgets/audio_speak_button.dart';

class MandiRatesScreen extends StatefulWidget {
  const MandiRatesScreen({super.key});

  @override
  State<MandiRatesScreen> createState() => _MandiRatesScreenState();
}

class _MandiRatesScreenState extends State<MandiRatesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: "50");

  List<MandiRate> _allRates = [];
  List<MandiRate> _filteredRates = [];
  List<Map<String, dynamic>> _profitResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredRates = _allRates.where((r) {
          return r.mandiName.toLowerCase().contains(query) ||
              r.mandiNameLocal.toLowerCase().contains(query) ||
              r.district.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  void _calculateProfits([String? originDistrict]) {
    final qty = double.tryParse(_qtyController.text) ?? 50.0;
    setState(() {
      _profitResults = MandiService().calculateBestMandiProfits(
        quantityQuintals: qty,
        originCity: originDistrict ?? "नाशिक (Nashik)",
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);

    if (_allRates.isEmpty) {
      _allRates = MandiService().getLiveMandiRates(originCity: appState.currentDistrict);
      _filteredRates = List.from(_allRates);
      _profitResults = MandiService().calculateBestMandiProfits(
        quantityQuintals: double.tryParse(_qtyController.text) ?? 50.0,
        originCity: appState.currentDistrict,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.translate("live_mandi"),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.onionPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.onionPurple,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(text: loc.translate("live_mandi")),
            Tab(text: loc.translate("profit_calculator")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Live Mandi List
          _buildLiveRatesTab(loc),

          // TAB 2: Smart Profit Calculator
          _buildProfitCalculatorTab(loc),
        ],
      ),
    );
  }

  Widget _buildLiveRatesTab(LocalizationService loc) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: loc.translate("search_mandi_hint"),
              prefixIcon: const Icon(Icons.search, color: AppColors.onionPurple),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ),

        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredRates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _filteredRates[index];
              final isPositive = item.dailyChange >= 0;
              final displayName = loc.currentLanguage == 'en' ? item.mandiName : item.mandiNameLocal;
              final audioText = loc.currentLanguage == 'en'
                  ? "$displayName Mandi. Modal rate ₹${item.modalPrice} per quintal. Minimum ₹${item.minPrice}, maximum ₹${item.maxPrice}."
                  : "$displayName. सरासरी भाव ₹${item.modalPrice} रुपये प्रति क्विंटल. किमान ₹${item.minPrice}, कमाल ₹${item.maxPrice}.";

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                "${item.district}, ${item.state} • ${loc.translate('arrivals')}: ${item.arrivalTons} ${loc.translate('tons')}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AudioSpeakButton(
                          textToSpeak: audioText,
                          size: 22,
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate("modal_price"),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹${item.modalPrice}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.onionPurple,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "${isPositive ? '+' : ''}₹${item.dailyChange}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isPositive ? Colors.green.shade800 : Colors.red.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              loc.translate("min_max"),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "₹${item.minPrice} - ₹${item.maxPrice}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfitCalculatorTab(LocalizationService loc) {
    if (_profitResults.isEmpty) return const SizedBox();

    final appState = Provider.of<AppStateProvider>(context);
    final best = _profitResults.first;
    final bestMandi = best['mandi'] as MandiRate;
    final bestNet = (best['net'] as double).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input card
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
                  loc.translate("enter_quantity"),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "50",
                          suffixText: loc.translate("quintal"),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onPressed: () => _calculateProfits(appState.currentDistrict),
                      child: Text(loc.translate("calculate"), style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recommendation Card
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
                        loc.translate("most_profitable_mandi"),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AudioSpeakButton(
                      textToSpeak: loc.currentLanguage == 'en'
                          ? "Recommendation. Selling in ${bestMandi.mandiName} gives you the highest net return of ₹$bestNet after deducting transport."
                          : "शिफारस. ${bestMandi.mandiNameLocal} मध्ये विक्री केल्यास वाहतूक खर्च वजा जाता तुम्हाला सर्वाधिक ₹$bestNet रुपये निव्वळ नफा मिळेल.",
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  loc.currentLanguage == 'en' ? bestMandi.mandiName : bestMandi.mandiNameLocal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${loc.translate('estimated_net_profit')}: ₹$bestNet (${loc.translate('after_transport')})",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${loc.translate('distance')}: ${bestMandi.distanceKm} km • ${loc.translate('rate')}: ₹${bestMandi.modalPrice}/${loc.translate('quintal')}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Comparison List
          Text(
            loc.translate("compare_all_mandis"),
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
            itemCount: _profitResults.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final p = _profitResults[index];
              final m = p['mandi'] as MandiRate;
              final net = (p['net'] as double).toInt();
              final transport = (p['transport'] as double).toInt();
              final mName = loc.currentLanguage == 'en' ? m.mandiName : m.mandiNameLocal;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: index == 0 ? Colors.green.shade50 : Colors.grey.shade100,
                      child: Text(
                        "#${index + 1}",
                        style: TextStyle(
                          color: index == 0 ? AppColors.agriGreen : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${loc.translate('distance')}: ${m.distanceKm} km • ${loc.translate('freight_cost')}: ₹$transport",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹$net",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: index == 0 ? AppColors.agriGreen : AppColors.textDark,
                          ),
                        ),
                        Text(
                          loc.translate("net_profit"),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
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
}
