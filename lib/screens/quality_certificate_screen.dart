import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/onion_grade_plus_models.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class QualityCertificateScreen extends StatelessWidget {
  final DigitalQualityCertificate certificate;

  const QualityCertificateScreen({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    final audioText = loc.currentLanguage == 'hi'
        ? "डिजिटल गुणवत्ता प्रमाणपत्र. प्रमाणपत्र संख्या: ${certificate.certificateId}. प्रामाणिकता: एसएचए-256 सत्यापित. कुल गुणवत्ता स्कोर: ${certificate.qualityScore}%."
        : loc.currentLanguage == 'mr'
            ? "डिजिटल गुणवत्ता प्रमाणपत्र. प्रमाणपत्र क्रमांक: ${certificate.certificateId}. सत्यता: एसएचए-२५६ प्रमाणित. एकूण गुणवत्ता स्कोर: ${certificate.qualityScore}%."
            : "Digital Quality Certificate. Certificate ID: ${certificate.certificateId}. Authenticity: SHA-256 Hash Verified. Quality Score: ${certificate.qualityScore}%.";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate("digital_certificate"),
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          AudioSpeakButton(textToSpeak: audioText),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Certificate Official Sheet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.goldAmber, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Official Header Seal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.agriGreen.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.agriGreen, width: 1.5),
                        ),
                        child: const Icon(Icons.verified_user, color: AppColors.agriGreen, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ONIONGRADE+ PLATFORM",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onionPurple,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            "APMC Tamper-Evident Quality Certificate",
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Divider(color: Colors.black12, thickness: 1.2),
                  const SizedBox(height: 14),

                  // Certificate ID & Validity Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.agriGreen, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "STATUS: VALID_AUTHENTIC",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    certificate.certificateId,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metadata Key-Values
                  _buildMetaRow("Sample Identifier", certificate.sampleId),
                  _buildMetaRow("Inspection Center", certificate.centerId),
                  _buildMetaRow("Issued Timestamp", "${certificate.timestamp.toIso8601String().substring(0, 19)}Z (UTC)"),
                  _buildMetaRow("AI Quality Score", "${certificate.qualityScore} / 100 (${certificate.qualityScore >= 80 ? 'Grade A Super' : 'Commercial Lot'})"),

                  const SizedBox(height: 14),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 12),

                  // Grade Distribution Chart / Bars
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Certified Grade Breakdown",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildGradeBar("Grade A (Export / Super)", certificate.gradeDistribution['Grade A'] ?? 72.0, const Color(0xFF4CAF50)),
                  _buildGradeBar("Damaged (Mechanical/Cuts)", certificate.gradeDistribution['Damaged'] ?? 8.0, const Color(0xFFF44336)),
                  _buildGradeBar("Sprouted (Shoot Emergence)", certificate.gradeDistribution['Sprouted'] ?? 6.0, const Color(0xFFFFEB3B)),
                  _buildGradeBar("Rotten (Soft/Wet Neck)", certificate.gradeDistribution['Rotten'] ?? 4.0, const Color(0xFFFF9800)),
                  _buildGradeBar("Undersized (<35 mm)", certificate.gradeDistribution['Undersized'] ?? 10.0, const Color(0xFF2196F3)),

                  const SizedBox(height: 18),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 14),

                  // QR Code & SHA-256 Ledger Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Simulated QR Code Frame
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_2, size: 52, color: AppColors.textDark),
                            Text(
                              "SCAN VERIFY",
                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate("tamper_evident"),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onionPurple),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                certificate.recordHashSha256,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontFamily: 'monospace',
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Chain Link: ${certificate.prevHash.substring(0, 16)}...",
                              style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Share & PDF Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onionPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("PDF Quality Certificate Exported (SHA-256 Ledger Stamped)"),
                          backgroundColor: AppColors.agriGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text(
                      "Export PDF",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.onionPurple),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Certificate Link & Verification QR shared with APMC Trader"),
                          backgroundColor: AppColors.onionPurple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, color: AppColors.onionPurple),
                    label: const Text(
                      "Share Link",
                      style: TextStyle(color: AppColors.onionPurple, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildGradeBar(String label, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text("${pct.toStringAsFixed(1)}%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
