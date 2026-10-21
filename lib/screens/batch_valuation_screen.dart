import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/onion_grade_plus_models.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class BatchValuationScreen extends StatefulWidget {
  final double initialQuintals;
  final double gradeAPct;
  final double undersizedPct;
  final double cullPct;

  const BatchValuationScreen({
    super.key,
    this.initialQuintals = 50.0,
    this.gradeAPct = 72.0,
    this.undersizedPct = 16.0,
    this.cullPct = 12.0,
  });

  @override
  State<BatchValuationScreen> createState() => _BatchValuationScreenState();
}

class _BatchValuationScreenState extends State<BatchValuationScreen> {
  late double _quintals;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _quintals = widget.initialQuintals;
    _controller = TextEditingController(text: _quintals.toInt().toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    final valuation = BatchValuationResult.calculate(
      totalQuintals: _quintals,
      gradeAPct: widget.gradeAPct,
      undersizedPct: widget.undersizedPct,
      cullPct: widget.cullPct,
      modalPrice: 2650,
    );

    final netGainFormatted = valuation.netGain.round();
    final gainPctFormatted = valuation.netGainPercentage.toStringAsFixed(1);

    final audioText = loc.currentLanguage == 'hi'
        ? "प्याज ग्रेडिंग मूल्यांकन रिपोर्ट. कुल वजन: ${_quintals.toInt()} क्विंटल. ग्रेडिंग से अतिरिक्त वित्तीय लाभ: ₹$netGainFormatted रुपये (+$gainPctFormatted%)."
        : loc.currentLanguage == 'mr'
            ? "कांदा प्रतवारी मूल्यांकन अहवाल. एकूण आवक: ${_quintals.toInt()} क्विंटल. कांदा ग्रेडिंग केल्यामुळे मिळणारा निव्वळ जास्तीचा नफा: ₹$netGainFormatted रुपये (+$gainPctFormatted%)."
            : "Batch Monetary Valuation. Batch Weight: ${_quintals.toInt()} Quintals. Extra Financial Gain from Grading: ₹$netGainFormatted (+$gainPctFormatted%).";

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
          loc.translate("batch_valuation"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Extra Profit Highlight Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.agriGreen, Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.agriGreen.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldAmber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "★ FR-8 Valuation Formula",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      Text(
                        "+$gainPctFormatted% Extra",
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loc.translate("graded_gain"),
                    style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "+₹$netGainFormatted",
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.currentLanguage == 'mr'
                        ? "अवर्गीकृत (गोल्टी/खराब एकत्र) विकल्यास ₹४५०/क्विंटल नुकसान होते. ग्रेडिंग करून विकल्यास थेट नफा!"
                        : loc.currentLanguage == 'hi'
                            ? "बिना छांटे बेचने पर ₹४५०/क्विंटल कटौती होती है। ग्रेडिंग करके बेचने पर सीधा लाभ!"
                            : "Ungraded lots suffer ₹450/Qtl buyer penalty. Proper grading yields guaranteed extra returns!",
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9), height: 1.35),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Weight Input Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.translate("enter_quantity"),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      Text(
                        "${_quintals.toInt()} Quintals (${(_quintals * 100).toInt()} kg)",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onionPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.onionPurple,
                      thumbColor: AppColors.onionPurple,
                      overlayColor: AppColors.onionPurple.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _quintals,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      label: "${_quintals.toInt()} Qtl",
                      onChanged: (val) {
                        setState(() {
                          _quintals = val;
                          _controller.text = val.toInt().toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Comparison Summary Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Graded Lot Total", style: TextStyle(fontSize: 11, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(
                          "₹${valuation.gradedValue.round()}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.agriGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Ungraded (-₹450 Pen)", style: TextStyle(fontSize: 11, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(
                          "₹${valuation.ungradedValue.round()}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red.shade800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Detailed Revenue Breakdown Table
            Text(
              "Monetary Breakdown by Grade",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildBreakdownRow(
                    grade: "Grade A (Export / Super)",
                    pct: "${widget.gradeAPct}%",
                    weight: "${valuation.gradeAWeight.round()} Qtl",
                    rate: "₹2,850/Qtl",
                    revenue: "₹${valuation.gradeARevenue.round()}",
                    color: const Color(0xFF4CAF50),
                  ),
                  const Divider(height: 1),
                  _buildBreakdownRow(
                    grade: "Undersized (<35 mm)",
                    pct: "${widget.undersizedPct}%",
                    weight: "${valuation.undersizedWeight.round()} Qtl",
                    rate: "₹2,250/Qtl",
                    revenue: "₹${valuation.undersizedRevenue.round()}",
                    color: const Color(0xFF2196F3),
                  ),
                  const Divider(height: 1),
                  _buildBreakdownRow(
                    grade: "Cull (Rotten / Damaged)",
                    pct: "${widget.cullPct}%",
                    weight: "${valuation.cullWeight.round()} Qtl",
                    rate: "₹1,800/Qtl",
                    revenue: "₹${valuation.cullRevenue.round()}",
                    color: const Color(0xFFF44336),
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

  Widget _buildBreakdownRow({
    required String grade,
    required String pct,
    required String weight,
    required String rate,
    required String revenue,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grade, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text("$pct of batch • $weight @ $rate", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(revenue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
