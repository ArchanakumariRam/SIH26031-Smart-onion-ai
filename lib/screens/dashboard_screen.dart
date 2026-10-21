import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';
import '../widgets/mandi_ticker.dart';
import 'scanner_screen.dart';
import 'mandi_rates_screen.dart';
import 'crop_doctor_screen.dart';
import 'storage_advisor_screen.dart';
import 'market_intelligence_screen.dart';
import 'my_records_screen.dart';
import 'weather_alert_screen.dart';
import 'price_alert_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onTabChange;

  const DashboardScreen({super.key, this.onTabChange});

  void _showLocationPicker(BuildContext context, AppStateProvider appState, LocalizationService loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_city, color: AppColors.onionPurple),
                  const SizedBox(width: 8),
                  Text(
                    loc.translate("select_district"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: AppConstants.majorDistricts.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (c, index) {
                    final dist = AppConstants.majorDistricts[index];
                    final isSelected = appState.currentDistrict == dist;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.location_on_outlined,
                        color: isSelected ? AppColors.agriGreen : Colors.grey,
                      ),
                      title: Text(
                        dist,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.agriGreen : AppColors.textDark,
                        ),
                      ),
                      trailing: isSelected
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Active",
                                style: TextStyle(fontSize: 11, color: AppColors.agriGreen, fontWeight: FontWeight.bold),
                              ),
                            )
                          : null,
                      onTap: () {
                        appState.setDistrict(dist);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Location changed to $dist"),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.agriGreen,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);
    final mandiRates = appState.getMandiRates();

    final welcomeAudioText =
        "${loc.translate('app_name')}. ${loc.translate('tagline')}. ${loc.translate('quick_scan_banner')}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.onionPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("🧅", style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate("app_name"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onionPurple,
                  ),
                ),
                InkWell(
                  onTap: () => _showLocationPicker(context, appState, loc),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 12, color: AppColors.agriGreen),
                        const SizedBox(width: 2),
                        Text(
                          appState.currentDistrict,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.agriGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 14, color: AppColors.agriGreen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Audio Read-aloud button
          AudioSpeakButton(textToSpeak: welcomeAudioText),

          // Language Switcher dropdown / popup
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.onionPurple.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16, color: AppColors.onionPurple),
                  const SizedBox(width: 4),
                  Text(
                    appState.currentLanguage.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onionPurple,
                    ),
                  ),
                ],
              ),
            ),
            onSelected: (String lang) {
              appState.changeLanguage(lang);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'en', child: Text("English (Default)")),
              const PopupMenuItem(value: 'mr', child: Text("मराठी (Marathi)")),
              const PopupMenuItem(value: 'hi', child: Text("हिंदी (Hindi)")),
              const PopupMenuItem(value: 'te', child: Text("తెలుగు (Telugu)")),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Action Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.onionPurple, Color(0xFF8B265E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onionPurple.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.goldAmber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "AI Scanner",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text("📷 🧅", style: TextStyle(fontSize: 28)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      loc.translate("tagline"),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      loc.translate("quick_scan_banner"),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldAmber,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ScannerScreen()),
                            );
                          },
                          icon: const Icon(Icons.camera_alt, color: Colors.black87),
                          label: Text(
                            loc.translate("scan_onion"),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MyRecordsScreen()),
                            );
                          },
                          icon: const Icon(Icons.history, color: Colors.white, size: 18),
                          label: Text(
                            loc.translate("my_records"),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Live Mandi Ticker
            MandiTicker(
              mandiRates: mandiRates,
              onTapViewAll: () {
                if (onTabChange != null) {
                  onTabChange!(2);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // Weather & Chawl Humidity Alert Banner (Interactive!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeatherAlertScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.water_drop, color: Colors.orange, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "🌦️ ${loc.translate('weather_alerts_title')}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loc.translate("humidity_warning"),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI Market Intelligence & "When to Sell?" Feature Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MarketIntelligenceScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.analytics, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.goldAmber,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.translate("selling_score_title"),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc.translate("when_to_sell_tab"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.translate("market_intel"),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${loc.translate('cities_graph_tab')} • ${loc.translate('true_net_tab')}",
                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Service Cards Grid (6 Essential Modules)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  // 1. My Records (Farmer Diary)
                  _buildQuickCard(
                    context: context,
                    icon: Icons.history_edu,
                    iconBg: AppColors.onionPurple.withValues(alpha: 0.1),
                    iconColor: AppColors.onionPurple,
                    badgeText: "${appState.scanHistory.length} Scans",
                    badgeColor: AppColors.onionPurple,
                    title: loc.translate("my_records"),
                    subtitle: "Saved Inspections",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyRecordsScreen()),
                      );
                    },
                  ),

                  // 2. Market Trend & Price Alerts
                  _buildQuickCard(
                    context: context,
                    icon: Icons.add_alert,
                    iconBg: Colors.purple.shade50,
                    iconColor: Colors.deepPurple,
                    badgeText: "${appState.priceAlerts.length} Active",
                    badgeColor: Colors.deepPurple,
                    title: loc.translate("set_alert"),
                    subtitle: "Trend Push Alerts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PriceAlertScreen()),
                      );
                    },
                  ),

                  // 3. Live Mandi Rates
                  _buildQuickCard(
                    context: context,
                    icon: Icons.trending_up,
                    iconBg: Colors.green.shade50,
                    iconColor: AppColors.agriGreen,
                    title: loc.translate("live_mandi"),
                    subtitle: loc.translate("today_lasalgaon"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                      );
                    },
                  ),

                  // 4. Agriculture Weather
                  _buildQuickCard(
                    context: context,
                    icon: Icons.wb_sunny,
                    iconBg: Colors.blue.shade50,
                    iconColor: Colors.blue.shade800,
                    badgeText: "78% RH Risk",
                    badgeColor: Colors.orange,
                    title: "Weather Alerts",
                    subtitle: "Field & Chawl Climate",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherAlertScreen()),
                      );
                    },
                  ),

                  // 5. Storage Chawl Advisor
                  _buildQuickCard(
                    context: context,
                    icon: Icons.warehouse,
                    iconBg: Colors.orange.shade50,
                    iconColor: Colors.orange.shade800,
                    title: loc.translate("storage_advisor"),
                    subtitle: loc.translate("storage_viability"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StorageAdvisorScreen()),
                      );
                    },
                  ),

                  // 6. Crop Doctor (Disease Diagnosis)
                  _buildQuickCard(
                    context: context,
                    icon: Icons.healing,
                    iconBg: Colors.red.shade50,
                    iconColor: Colors.red.shade700,
                    title: loc.translate("crop_doctor"),
                    subtitle: loc.translate("crop_doctor_title"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CropDoctorScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? iconColor).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor ?? iconColor,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
