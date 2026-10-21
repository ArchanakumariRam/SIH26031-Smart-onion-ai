import 'dart:convert';
import 'package:crypto/crypto.dart';

class QualityGateResult {
  final double blurScore;
  final double brightnessScore;
  final double contrastScore;
  final bool isPassed;
  final String status; // 'PASSED' or 'REJECTED'
  final String feedbackMessage;

  QualityGateResult({
    required this.blurScore,
    required this.brightnessScore,
    required this.contrastScore,
    required this.isPassed,
    required this.status,
    required this.feedbackMessage,
  });

  factory QualityGateResult.simulatePass() {
    return QualityGateResult(
      blurScore: 142.5, // >= 80
      brightnessScore: 128.0, // 40-220
      contrastScore: 54.2, // >= 30
      isPassed: true,
      status: 'PASSED',
      feedbackMessage: 'Image quality optimal: Sharp, well-lit specimen.',
    );
  }
}

class DetectedBulb {
  final int id;
  final double x; // normalized 0..1
  final double y;
  final double width;
  final double height;
  final String grade; // 'Grade A', 'Damaged', 'Sprouted', 'Rotten', 'Undersized', 'Discolored'
  final String hexColor;
  final double confidence;
  final String confidenceBadge; // 'High', 'Medium', 'Uncertain'
  final double diameterMm;
  final double damageAreaPct;
  final String damageLocation;
  final Map<String, String> reasonTexts;
  bool isUncertain;

  DetectedBulb({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.grade,
    required this.hexColor,
    required this.confidence,
    required this.confidenceBadge,
    required this.diameterMm,
    required this.damageAreaPct,
    required this.damageLocation,
    required this.reasonTexts,
    this.isUncertain = false,
  });

  String getReason(String langCode) {
    return reasonTexts[langCode] ?? reasonTexts['en'] ?? '';
  }

  static List<DetectedBulb> createSampleBatch() {
    return [
      DetectedBulb(
        id: 1,
        x: 0.12,
        y: 0.16,
        width: 0.36,
        height: 0.36,
        grade: "Grade A",
        hexColor: "#4CAF50",
        confidence: 0.94,
        confidenceBadge: "High",
        diameterMm: 62.4,
        damageAreaPct: 0.0,
        damageLocation: "none",
        reasonTexts: {
          "en": "Grade A: Uniform globe shape, firm dry outer skin, zero mold or defects detected, confidence 94.0%.",
          "hi": "ग्रेड A: एकसमान गोल आकार, मजबूत सूखा छिलका, कोई दाग या फफूंद नहीं, विश्वसनीयता 94.0%।",
          "mr": "ग्रेड A: एकसमान गोल आकार, कडक सुका पापुद्रा, कोणताही बुरशी किंवा डाग नाही, विश्वासार्हता 94.0%.",
          "te": "గ్రేడ్ A: ఏకరీతి గుండ్రని ఆకారం, పొడి తొక్క, ఎటువంటి తెగులు లేదా మచ్చలు లేవు, విశ్వాసం 94.0%.",
        },
      ),
      DetectedBulb(
        id: 2,
        x: 0.54,
        y: 0.14,
        width: 0.35,
        height: 0.35,
        grade: "Damaged",
        hexColor: "#F44336",
        confidence: 0.87,
        confidenceBadge: "High",
        diameterMm: 58.1,
        damageAreaPct: 8.3,
        damageLocation: "left side",
        reasonTexts: {
          "en": "Damaged: left side mechanical cut damage covering ~8.3% of surface, confidence 87.0%.",
          "hi": "क्षतिग्रस्त: बाईं ओर यांत्रिक कट क्षति, सतह का ~8.3% प्रभावित, विश्वसनीयता 87.0%।",
          "mr": "खराब: डाव्या बाजूला यांत्रिक कापलेले नुकसान, पृष्ठभागाचा ~8.3% भाग बाधित, विश्वासार्हता 87.0%.",
          "te": "దెబ్బతిన్నది: ఎడమ వైపు కోత నష్టం, ఉపరితలంలో ~8.3% దెబ్బతిన్నది, విశ్వాసం 87.0%.",
        },
      ),
      DetectedBulb(
        id: 3,
        x: 0.10,
        y: 0.56,
        width: 0.38,
        height: 0.38,
        grade: "Sprouted",
        hexColor: "#FFEB3B",
        confidence: 0.89,
        confidenceBadge: "High",
        diameterMm: 55.0,
        damageAreaPct: 4.2,
        damageLocation: "top neck",
        reasonTexts: {
          "en": "Sprouted: Apical shoot emergence ~14 mm at top neck, storage life expired, confidence 89.0%.",
          "hi": "अंकुरित: शीर्ष गर्दन से ~14 मिमी का अंकुरण, भंडारण क्षमता समाप्त, विश्वसनीयता 89.0%।",
          "mr": "मोड आलेला (कोंब): कांद्याच्या मानेतून ~14 मिमी कोंब बाहेर आलेला, साठवण क्षमता संपली, विश्वासार्हता 89.0%.",
          "te": "మొలకెత్తినది: పై భాగం నుండి ~14 మిమీ మొలక వచ్చింది, నిల్వ సామర్థ్యం తగ్గింది, విశ్వాసం 89.0%.",
        },
      ),
      DetectedBulb(
        id: 4,
        x: 0.52,
        y: 0.54,
        width: 0.37,
        height: 0.37,
        grade: "Undersized",
        hexColor: "#2196F3",
        confidence: 0.95,
        confidenceBadge: "High",
        diameterMm: 31.2,
        damageAreaPct: 0.0,
        damageLocation: "none",
        reasonTexts: {
          "en": "Undersized: Bulb diameter 31.2 mm below 35 mm APMC standard threshold, confidence 95.0%.",
          "hi": "छोटा आकार: प्याज का व्यास 31.2 मिमी (मानक 35 मिमी से कम), विश्वसनीयता 95.0%।",
          "mr": "अल्प आकार (गोलटी): कांद्याचा व्यास 31.2 मिमी (किमान 35 मिमी पेक्षा कमी), विश्वासार्हता 95.0%.",
          "te": "చిన్న పరిమాణం: ఉల్లి వ్యాసం 31.2 మిమీ (ప్రామాణిక 35 మిమీ కంటే తక్కువ), విశ్వాసం 95.0%.",
        },
      ),
      DetectedBulb(
        id: 5,
        x: 0.32,
        y: 0.36,
        width: 0.34,
        height: 0.34,
        grade: "Rotten",
        hexColor: "#FF9800",
        confidence: 0.62,
        confidenceBadge: "Uncertain",
        isUncertain: true,
        diameterMm: 52.8,
        damageAreaPct: 12.5,
        damageLocation: "center neck",
        reasonTexts: {
          "en": "Rotten: Wet neck bacterial soft rot ~12.5%, confidence 62.0% (Uncertain - Routed to Grader Review).",
          "hi": "सड़ा हुआ: गीली गर्दन जीवाणु सड़ांध ~12.5%, विश्वसनीयता 62.0% (समीक्षा कतार में भेजा गया)।",
          "mr": "सडलेला: मान मऊ पडून जिवाणू कुज ~12.5%, विश्वासार्हता 62.0% (तपासणीसाठी पुनरावलोकन रांगेत).",
          "te": "కుళ్ళినది: మెడ భాగం తడిగా మారి బాక్టీరియల్ కుళ్ళు ~12.5%, విశ్వాసం 62.0% (పునఃపరిశీలనకు పంపబడింది).",
        },
      ),
    ];
  }
}

class DigitalQualityCertificate {
  final String certificateId; // e.g. CERT-2026-F9A27E14
  final String sampleId; // e.g. SMP-2026-0842
  final String centerId; // e.g. APMC-LASALGAON-01
  final String recordHashSha256;
  final String prevHash;
  final DateTime timestamp;
  final Map<String, double> gradeDistribution; // {'Grade A': 74.0, ...}
  final int qualityScore;
  final bool tamperDetected;

  DigitalQualityCertificate({
    required this.certificateId,
    required this.sampleId,
    required this.centerId,
    required this.recordHashSha256,
    required this.prevHash,
    required this.timestamp,
    required this.gradeDistribution,
    required this.qualityScore,
    this.tamperDetected = false,
  });

  static DigitalQualityCertificate generate({
    required String sampleId,
    required Map<String, double> distribution,
    required int score,
    String centerId = "APMC-LASALGAON-DIST-01",
  }) {
    final now = DateTime.now();
    final certSuffix = now.millisecondsSinceEpoch.toRadixString(16).toUpperCase().padLeft(8, '0');
    final certId = "CERT-2026-$certSuffix";
    const prevHash = "0000a4b7e891c923f104d5e89a31bc4028fa687b120cde8823f9821034ba9821";

    final payload = "$certId-$sampleId-$centerId-$distribution-$prevHash-${now.toIso8601String()}";
    final sha = sha256.convert(utf8.encode(payload)).toString();

    return DigitalQualityCertificate(
      certificateId: certId,
      sampleId: sampleId,
      centerId: centerId,
      recordHashSha256: sha,
      prevHash: prevHash,
      timestamp: now,
      gradeDistribution: distribution,
      qualityScore: score,
      tamperDetected: false,
    );
  }
}

class BatchValuationResult {
  final double totalWeightQuintals;
  final double gradedValue;
  final double ungradedValue;
  final double netGain;
  final double netGainPercentage;
  final double gradeAWeight;
  final double gradeARevenue;
  final double undersizedWeight;
  final double undersizedRevenue;
  final double cullWeight;
  final double cullRevenue;

  BatchValuationResult({
    required this.totalWeightQuintals,
    required this.gradedValue,
    required this.ungradedValue,
    required this.netGain,
    required this.netGainPercentage,
    required this.gradeAWeight,
    required this.gradeARevenue,
    required this.undersizedWeight,
    required this.undersizedRevenue,
    required this.cullWeight,
    required this.cullRevenue,
  });

  /// Formula from FR-8.1:
  /// Graded Value = W_total × [(%Grade A × P_A) + (%Undersized × P_small) + (%Cull × P_cull)]
  /// Ungraded Value = W_total × P_ungraded (modal price − ₹450 penalty)
  static BatchValuationResult calculate({
    required double totalQuintals,
    required double gradeAPct,
    required double undersizedPct,
    required double cullPct,
    double modalPrice = 2650,
  }) {
    final priceA = modalPrice + 200; // Premium for Grade A
    final priceSmall = modalPrice - 400; // Undersized price
    final priceCull = modalPrice - 850; // Cull / Damaged
    final priceUngraded = modalPrice - 450; // Buyer penalty for ungraded lots

    final wA = totalQuintals * (gradeAPct / 100);
    final wSmall = totalQuintals * (undersizedPct / 100);
    final wCull = totalQuintals * (cullPct / 100);

    final revA = wA * priceA;
    final revSmall = wSmall * priceSmall;
    final revCull = wCull * priceCull;

    final gradedTotal = revA + revSmall + revCull;
    final ungradedTotal = totalQuintals * priceUngraded;
    final gain = gradedTotal - ungradedTotal;
    final gainPct = ungradedTotal > 0 ? (gain / ungradedTotal) * 100 : 0.0;

    return BatchValuationResult(
      totalWeightQuintals: totalQuintals,
      gradedValue: gradedTotal,
      ungradedValue: ungradedTotal,
      netGain: gain,
      netGainPercentage: gainPct,
      gradeAWeight: wA,
      gradeARevenue: revA,
      undersizedWeight: wSmall,
      undersizedRevenue: revSmall,
      cullWeight: wCull,
      cullRevenue: revCull,
    );
  }
}
