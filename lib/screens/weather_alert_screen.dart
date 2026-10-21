import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class WeatherAlertScreen extends StatelessWidget {
  const WeatherAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);

    final advisoryAudioText = loc.currentLanguage == 'hi'
        ? """
कृषि मौसम व भंडारण चेतावनी:
जिला: ${appState.currentDistrict}.
वर्तमान तापमान: 28°C. हवा में नमी 78% है, जो सामान्य 65% से अधिक है।
चेतावनी: चाली में नमी अधिक होने से फंगस और सड़न का खतरा है।
सलाह: चाली के नीचे के एग्जॉस्ट पंखे ४ से ५ घंटे चलाएं। डहाळे प्याज को तुरंत अलग करें।
"""
        : loc.currentLanguage == 'mr'
            ? """
शेती हवामान व कांदा चाळ सल्ला:
जिल्हा: ${appState.currentDistrict}.
सध्याचे तापमान: २८°C. हवेतील आर्द्रता ७८% असून ती चाळीच्या ६५% मर्यादेपेक्षा जास्त आहे.
धोका: कांदा चाळीत काजळी (Black mold) व सड लागण्याची दाट शक्यता.
सल्ला: चाळीचे तळभागातील एक्झॉस्ट पंखे ४-५ तास सुरू ठेवा. ओलसर व डहाळे कांदे लगेच वेगळे करा.
"""
            : """
Agricultural Weather & Storage Advisory:
District: ${appState.currentDistrict}.
Temperature: 28°C. Relative Humidity: 78% (Exceeds optimal 65% threshold).
Warning: High moisture increases risk of Aspergillus Black Mold and bulb sprouting.
Action: Run lower ventilation fans for 4-5 hours. Segregate any thick-necked bulbs immediately.
""";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate("weather_alerts_title"),
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          AudioSpeakButton(textToSpeak: advisoryAudioText),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Climate Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D47A1).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.amberAccent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            appState.currentDistrict,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "🌦️ Monsoon Moisture",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "28°C",
                            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          Text(
                            loc.currentLanguage == 'mr'
                                ? "ढगाळ वातावरण • हलक्या सरी"
                                : loc.currentLanguage == 'hi'
                                    ? "बादल छाए • हल्की बारिश"
                                    : "Cloudy Overcast • Passing Showers",
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                      const Text("🌧️", style: TextStyle(fontSize: 48)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherStat(
                        icon: Icons.water_drop,
                        label: loc.translate("humidity"),
                        value: "78% RH",
                        isAlert: true,
                      ),
                      _buildWeatherStat(
                        icon: Icons.air,
                        label: loc.translate("wind_speed"),
                        value: "14 km/h",
                      ),
                      _buildWeatherStat(
                        icon: Icons.umbrella,
                        label: loc.translate("rain_chance"),
                        value: "45%",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Storage Chawl Health Index Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade400, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate("storage_chawl_status"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                            Text(
                              loc.currentLanguage == 'mr'
                                  ? "जास्त दमट हवेमुळे सडण्याचा धोका (Critical 78% RH)"
                                  : loc.currentLanguage == 'hi'
                                      ? "उच्च आर्द्रता से सड़न का खतरा (Critical 78% RH)"
                                      : "High Moisture Spoilage Alert (Critical 78% RH)",
                              style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.78,
                    backgroundColor: Colors.amber.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.currentLanguage == 'mr'
                        ? "तात्काळ उपाय: चाळीचे खालचे एक्झॉस्ट पंखे दररोज दुपारी ४ तास चालू ठेवा. बाहेरील पाऊस सुरू असताना खिडक्या बंद ठेवा."
                        : loc.currentLanguage == 'hi'
                            ? "तत्काल उपाय: चाली के नीचे के पंखे रोज दोपहर ४ घंटे चलाएं। बारिश के दौरान बाहरी खिड़कियां बंद रखें।"
                            : "Immediate Action: Run bottom exhaust ventilation fans for 4 hours during dry afternoons. Keep outer shutters closed during active rainfall.",
                    style: TextStyle(fontSize: 13, height: 1.4, color: Colors.amber.shade900, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Agronomic Action Guidelines
            Text(
              loc.currentLanguage == 'mr'
                  ? "कांदा पिकासाठी शेती सल्ला (Agronomy Advisory)"
                  : loc.currentLanguage == 'hi'
                      ? "प्याज फसल के लिए कृषि सलाह (Agronomy Advisory)"
                      : "Onion Crop Weather Guidelines",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            _buildAdvisoryCard(
              icon: Icons.science,
              iconColor: Colors.purple,
              title: loc.currentLanguage == 'mr'
                  ? "फवारणी सल्ला (Spray Timing)"
                  : loc.currentLanguage == 'hi'
                      ? "छिड़काव सलाह (Spray Timing)"
                      : "Foliar Spray Advisory",
              desc: loc.currentLanguage == 'mr'
                  ? "वाऱ्याचा वेग मंदावल्यास (सकाळी ७:३० ते १०:३०) करपा व थ्रिप्स नियंत्रणासाठी फवारणी करा. पाऊस येण्याआधी स्टिकर (स्प्रेडर) नक्की वापरा."
                  : loc.currentLanguage == 'hi'
                      ? "सुबह ७:३० से १०:३० के बीच करपा व थ्रिप्स नियंत्रण के लिए छिड़काव करें। स्टिकर (स्प्रेडर) का प्रयोग अवश्य करें।"
                      : "Spray for Purple Blotch & Thrips between 7:30 AM - 10:30 AM when wind speed is under 12 km/h. Always add an agricultural spreading sticker.",
            ),
            const SizedBox(height: 10),

            _buildAdvisoryCard(
              icon: Icons.agriculture,
              iconColor: AppColors.agriGreen,
              title: loc.currentLanguage == 'mr'
                  ? "काढणी व सुकवणी (Harvest & Curing)"
                  : loc.currentLanguage == 'hi'
                      ? "खुदाई व सुखाना (Harvest & Curing)"
                      : "Harvesting & Field Curing",
              desc: loc.currentLanguage == 'mr'
                  ? "पावसाची शक्यता ४५% असल्याने काढलेला कांदा शेतात उघड्यावर ठेवू नका. झाकलेल्या शेडमध्ये पात सुकवा."
                  : loc.currentLanguage == 'hi'
                      ? "बारिश की संभावना होने से खेत में प्याज खुला न छोड़ें। छांव वाले शेड में सुखाएं।"
                      : "With a 45% rain chance, do not leave harvested onions exposed in the open field. Move to shaded curing sheds.",
            ),

            const SizedBox(height: 20),

            // 5-Day Agriculture Forecast
            Text(
              loc.currentLanguage == 'mr'
                  ? "पुढील ५ दिवसांचा हवामान अंदाज (5-Day Forecast)"
                  : loc.currentLanguage == 'hi'
                      ? "अगले ५ दिनों का मौसम पूर्वानुमान (5-Day Forecast)"
                      : "5-Day Agriculture Forecast",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            _buildForecastRow(day: "Today (आज)", icon: "🌧️", temp: "28°C / 21°C", humidity: "78% RH", risk: "High Moisture"),
            _buildForecastRow(day: "Tomorrow (उद्या)", icon: "🌦️", temp: "29°C / 22°C", humidity: "72% RH", risk: "Moderate"),
            _buildForecastRow(day: "Day 3 (तिसरा दिवस)", icon: "⛅", temp: "31°C / 20°C", humidity: "65% RH", risk: "Optimal Chawl"),
            _buildForecastRow(day: "Day 4 (चौथा दिवस)", icon: "☀️", temp: "32°C / 19°C", humidity: "58% RH", risk: "Best for Curing"),
            _buildForecastRow(day: "Day 5 (पाचवा दिवस)", icon: "☀️", temp: "33°C / 20°C", humidity: "55% RH", risk: "Dry & Clear"),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStat({
    required IconData icon,
    required String label,
    required String value,
    bool isAlert = false,
  }) {
    return Column(
      children: [
        Icon(icon, color: isAlert ? Colors.amberAccent : Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isAlert ? Colors.amberAccent : Colors.white,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }

  Widget _buildAdvisoryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(fontSize: 12, height: 1.4, color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastRow({
    required String day,
    required String icon,
    required String temp,
    required String humidity,
    required String risk,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: Text(day, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: Text(temp, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Text(
              "$humidity • $risk",
              style: TextStyle(
                fontSize: 11,
                color: risk.contains("High") ? Colors.red.shade700 : AppColors.agriGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
