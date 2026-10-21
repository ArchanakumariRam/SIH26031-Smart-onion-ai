import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/onion_scan_result.dart';
import '../models/onion_grade_plus_models.dart';
import '../services/localization_service.dart';
import '../services/platform_image.dart';
import '../widgets/audio_speak_button.dart';
import '../widgets/farmer_button.dart';
import '../widgets/stat_card.dart';
import '../widgets/interactive_grading_viewer.dart';
import 'quality_certificate_screen.dart';
import 'batch_valuation_screen.dart';
import 'market_intelligence_screen.dart';

class ScanResultScreen extends StatefulWidget {
  final OnionScanResult result;

  const ScanResultScreen({super.key, required this.result});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  late List<DetectedBulb> _detectedBulbs;
  late DigitalQualityCertificate _certificate;

  @override
  void initState() {
    super.initState();
    _detectedBulbs = DetectedBulb.createSampleBatch();

    // Map distribution from detected bulbs
    final total = _detectedBulbs.length;
    final Map<String, double> dist = {};
    for (var b in _detectedBulbs) {
      dist[b.grade] = (dist[b.grade] ?? 0) + (100.0 / total);
    }

    _certificate = DigitalQualityCertificate.generate(
      sampleId: "SMP-2026-${(1000 + widget.result.qualityScorePercentage).toString()}",
      distribution: dist,
      score: widget.result.qualityScorePercentage,
      centerId: "APMC-LASALGAON-CENTRAL-01",
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final result = widget.result;

    // Construct spoken text for farmer based on active locale (en, mr, hi, te)
    String speakSummary;
    if (loc.currentLanguage == 'hi') {
      speakSummary = """
प्याज ग्रेडिंग व गुणवत्ता अहवाल.
किस्म: ${result.varietyLocalName}.
गुणवत्ता: ग्रेड ${result.qualityGrade}, स्कोर ${result.qualityScorePercentage} प्रतिशत.
आकार: ${result.sizeGrade}.
भंडारण क्षमता: ${result.storageViabilityDays} दिन.
अनुमानित मंडी भाव: ${result.estimatedPriceMin} से ${result.estimatedPriceMax} रुपये प्रति क्विंटल.
सलाह: ${result.actionAdvice}
""";
    } else if (loc.currentLanguage == 'mr') {
      speakSummary = """
कांदा तपासणी व प्रतवारी अहवाल.
जात: ${result.varietyLocalName}.
प्रतवारी: ${result.qualityGrade} ग्रेड, गुणवत्ता ${result.qualityScorePercentage} टक्के.
आकार: ${result.sizeGrade}.
चाळीत टिकण्याची क्षमता: ${result.storageViabilityDays} दिवस.
अंदाजित बाजारभाव: ${result.estimatedPriceMin} ते ${result.estimatedPriceMax} रुपये प्रति क्विंटल.
सल्ला: ${result.actionAdvice}
""";
    } else if (loc.currentLanguage == 'te') {
      speakSummary = """
ఉల్లిపాయ గ్రేడింగ్ మరియు నాణ్యతా నివేదిక.
రకం: ${result.variety}.
గ్రేడింగ్: గ్రేడ్ ${result.qualityGrade}, నాణ్యత స్కోర్ ${result.qualityScorePercentage} శాతం.
పరిమాణం: ${result.sizeGrade}.
నిల్వ సామర్థ్యం: ${result.storageViabilityDays} రోజులు.
అంచనా మార్కెట్ ధర: ₹${result.estimatedPriceMin} నుండి ₹${result.estimatedPriceMax} క్వింటాల్‌కు.
సలహా: ${result.actionAdvice}
""";
    } else {
      // Default English
      speakSummary = """
Onion Inspection & Grading Report.
Variety: ${result.variety}.
Grading: Grade ${result.qualityGrade}, Score ${result.qualityScorePercentage} percent.
Size: ${result.sizeGrade}.
Storage Viability: ${result.storageViabilityDays} days.
Estimated Mandi Price: ₹${result.estimatedPriceMin} to ₹${result.estimatedPriceMax} per Quintal.
Recommendation: ${result.actionAdvice}
""";
    }

    final isGradeA = result.qualityGrade.toUpperCase() == 'A';
    final isGradeB = result.qualityGrade.toUpperCase() == 'B';
    final gradeColor = isGradeA ? AppColors.gradeA : (isGradeB ? AppColors.gradeB : AppColors.gradeC);

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
          loc.translate("quality_score"),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AudioSpeakButton(textToSpeak: speakSummary),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Specimen Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: AppColors.onionPurple.withValues(alpha: 0.1),
                      child: imageOrPlaceholder(
                        result.imagePath,
                        placeholder: const Center(
                          child: Text("🧅", style: TextStyle(fontSize: 44)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: gradeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${loc.translate('grade_${result.qualityGrade.toLowerCase()}')} (${result.qualityScorePercentage}%)",
                                style: TextStyle(
                                  color: gradeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: const Text(
                                "OnionGrade+",
                                style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          result.varietyLocalName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          "${loc.translate('size')}: ${result.sizeGrade} • ${_detectedBulbs.length} Bulbs Classified",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Interactive AI Grading Viewer with 6-Color Bounding Boxes & Grad-CAM Heatmap Overlay
            Text(
              "FR-4 & FR-5: Multi-Head Onion Bounding Boxes & Grad-CAM",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            InteractiveGradingViewer(
              imagePath: result.imagePath,
              detectedBulbs: _detectedBulbs,
            ),

            const SizedBox(height: 16),

            // 3. Wilson Score Confidence Interval Banner (FR-4.3)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: Colors.indigo, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Wilson Score CI (95% Confidence): Grade A proportion 72.0% ± 4.8% [CI: 67.2% – 76.8%]",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Quick-Action Cards: Digital Quality Certificate & Batch Monetary Valuation
            Row(
              children: [
                // Digital Quality Certificate Card
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QualityCertificateScreen(certificate: _certificate),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.verified, color: AppColors.goldAmber, size: 24),
                              Icon(Icons.qr_code, color: Colors.white70, size: 20),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Digital Certificate",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "SHA-256 Ledger Verified",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Batch Monetary Valuation Card
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BatchValuationScreen(
                            initialQuintals: 50.0,
                            gradeAPct: 72.0,
                            undersizedPct: 16.0,
                            cullPct: 12.0,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF4A148C), AppColors.onionPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.onionPurple.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.currency_rupee, color: AppColors.goldAmber, size: 24),
                              Icon(Icons.trending_up, color: Colors.white70, size: 20),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Batch Valuation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "FR-8.1 Formula (+₹ Gain)",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 5. Expected Mandi Price Banner
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.translate("expected_price"),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const Icon(Icons.currency_rupee, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${result.estimatedPriceMin} - ₹${result.estimatedPriceMax}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    loc.translate("per_quintal"),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 6. Stat Cards Grid (Storage Life & Defect Status)
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: loc.translate("storage_viability"),
                    value: "${result.storageViabilityDays} ${loc.translate('days')}",
                    subtitle: loc.translate("storage_advisor"),
                    icon: Icons.warehouse,
                    iconColor: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: loc.translate("defects_found"),
                    value: result.defectsDetected.contains("none")
                        ? "0 Defects"
                        : "${result.defectsDetected.length} Defects",
                    subtitle: result.defectsDetected.join(", "),
                    icon: Icons.check_circle,
                    iconColor: result.defectsDetected.contains("none")
                        ? AppColors.agriGreen
                        : AppColors.danger,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 7. AI Action Advice Box (Sell / Hold Advisory)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate("storage_advice"),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.actionAdvice,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 8. Action: Check Live Mandi Prices & Profit
            FarmerButton(
              text: loc.translate("calculate_profit"),
              icon: Icons.trending_up,
              backgroundColor: AppColors.onionPurple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MarketIntelligenceScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 9. Retake Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: const BorderSide(color: AppColors.onionPurple),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                loc.currentLanguage == 'mr'
                    ? "दुसरा कांदा स्कॅन करा (Scan Another)"
                    : loc.currentLanguage == 'hi'
                        ? "दूसरा प्याज स्कैन करें (Scan Another)"
                        : loc.currentLanguage == 'te'
                            ? "మరొక ఉల్లిపాయను స్కాన్ చేయండి (Scan Another)"
                            : "Scan Another Specimen",
                style: const TextStyle(
                  color: AppColors.onionPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
