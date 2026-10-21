import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/onion_grade_plus_models.dart';
import '../services/localization_service.dart';
import '../services/platform_image.dart';

class InteractiveGradingViewer extends StatefulWidget {
  final String? imagePath;
  final List<DetectedBulb> detectedBulbs;

  const InteractiveGradingViewer({
    super.key,
    this.imagePath,
    required this.detectedBulbs,
  });

  @override
  State<InteractiveGradingViewer> createState() => _InteractiveGradingViewerState();
}

class _InteractiveGradingViewerState extends State<InteractiveGradingViewer> {
  bool _showHeatmap = false;
  DetectedBulb? _selectedBulb;

  @override
  void initState() {
    super.initState();
    if (widget.detectedBulbs.isNotEmpty) {
      _selectedBulb = widget.detectedBulbs.first;
    }
  }

  void _showBulbDetailSheet(BuildContext context, DetectedBulb bulb, LocalizationService loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),

              // Title & Grade Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bulb #${bulb.id} Inspection", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(int.parse(bulb.hexColor.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${bulb.grade} (${(bulb.confidence * 100).toInt()}%)",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Measurement Metrics
              Row(
                children: [
                  _buildMetricBadge("Diameter", "${bulb.diameterMm.toStringAsFixed(1)} mm"),
                  const SizedBox(width: 8),
                  _buildMetricBadge("Confidence", "${bulb.confidenceBadge} (${(bulb.confidence * 100).toInt()}%)"),
                  const SizedBox(width: 8),
                  if (bulb.damageAreaPct > 0)
                    _buildMetricBadge("Damage Area", "${bulb.damageAreaPct.toStringAsFixed(1)}% (${bulb.damageLocation})"),
                ],
              ),
              const SizedBox(height: 14),

              // Reason Explanations across 4 languages
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Explainable AI (XAI) Reason Audit:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onionPurple)),
                    const SizedBox(height: 4),
                    Text(bulb.getReason(loc.currentLanguage), style: const TextStyle(fontSize: 13, height: 1.35, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Grader Review Active Learning Queue Actions
              Text("Grader Review Action (Active Learning):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.agriGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Bulb #${bulb.id} marked as Correct Grade ✅")),
                        );
                      },
                      icon: const Icon(Icons.check, size: 16, color: Colors.white),
                      label: const Text("Correct", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.deepOrange), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Bulb #${bulb.id} flagged for Review Queue ✏️")),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16, color: Colors.deepOrange),
                      label: const Text("Edit Grade", style: TextStyle(color: Colors.deepOrange, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    return Column(
      children: [
        // Mode Toggle Bar (Boxes vs Grad-CAM Heatmap)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showHeatmap ? "Grad-CAM Heatmap Overlay (XAI)" : "Interactive Bounding Boxes (${widget.detectedBulbs.length} Bulbs)",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() => _showHeatmap = !_showHeatmap),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _showHeatmap ? Colors.deepOrange : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.blur_on,
                        size: 16,
                        color: _showHeatmap ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showHeatmap ? "Heatmap ON" : "Heatmap OFF",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _showHeatmap ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Specimen Canvas with Bounding Boxes & Heatmap
        Container(
          height: 280,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base Image / Onion specimen
                imageOrPlaceholder(
                  widget.imagePath,
                  placeholder: const Center(
                    child: Text("🧅", style: TextStyle(fontSize: 72)),
                  ),
                ),

                // Simulated Grad-CAM Heatmap Overlay
                if (_showHeatmap)
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.2, 0.1),
                        radius: 0.65,
                        colors: [
                          Colors.red.withValues(alpha: 0.65),
                          Colors.orange.withValues(alpha: 0.5),
                          Colors.yellow.withValues(alpha: 0.35),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.filter_center_focus, size: 28, color: Colors.white),
                    ),
                  ),

                // Bounding Boxes Layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: widget.detectedBulbs.map((bulb) {
                        final boxColor = Color(int.parse(bulb.hexColor.replaceFirst('#', '0xFF')));
                        final isSelected = _selectedBulb?.id == bulb.id;

                        return Positioned(
                          left: bulb.x * constraints.maxWidth,
                          top: bulb.y * constraints.maxHeight,
                          width: bulb.width * constraints.maxWidth,
                          height: bulb.height * constraints.maxHeight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedBulb = bulb);
                              _showBulbDetailSheet(context, bulb, loc);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.white : boxColor,
                                  width: isSelected ? 3.5 : 2.2,
                                ),
                                color: boxColor.withValues(alpha: isSelected ? 0.3 : 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  // Top Grade Tag
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      color: boxColor,
                                      child: Text(
                                        "${bulb.grade} (${(bulb.confidence * 100).toInt()}%)",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Bottom Diameter Tag
                                  Positioned(
                                    bottom: 2,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${bulb.diameterMm.toStringAsFixed(0)} mm",
                                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Color Legend Bar (6 Fixed Colors from Spec)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildLegendItem("Grade A", const Color(0xFF4CAF50)),
                _buildLegendItem("Damaged", const Color(0xFFF44336)),
                _buildLegendItem("Sprouted", const Color(0xFFFFEB3B)),
                _buildLegendItem("Rotten", const Color(0xFFFF9800)),
                _buildLegendItem("Undersized", const Color(0xFF2196F3)),
                _buildLegendItem("Discolored", const Color(0xFF9C27B0)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}
