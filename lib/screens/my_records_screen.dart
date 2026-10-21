import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';
import 'scan_result_screen.dart';
import 'scanner_screen.dart';

class MyRecordsScreen extends StatefulWidget {
  const MyRecordsScreen({super.key});

  @override
  State<MyRecordsScreen> createState() => _MyRecordsScreenState();
}

class _MyRecordsScreenState extends State<MyRecordsScreen> {
  String _selectedFilter = 'ALL'; // ALL, A, B, C

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);
    final allScans = appState.scanHistory;

    final filteredScans = _selectedFilter == 'ALL'
        ? allScans
        : allScans.where((s) => s.qualityGrade.toUpperCase() == _selectedFilter).toList();

    int avgScore = 0;
    if (allScans.isNotEmpty) {
      final totalScore = allScans.fold<int>(0, (sum, item) => sum + item.qualityScorePercentage);
      avgScore = (totalScore / allScans.length).round();
    }

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
          loc.translate("my_records"),
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (allScans.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: loc.translate("clear_history"),
              onPressed: () => _confirmClearHistory(context, appState, loc),
            ),
        ],
      ),
      body: Column(
        children: [
          // Summary Stats Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.onionPurple, Color(0xFF8E24AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onionPurple.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    label: loc.translate("total_scans"),
                    value: "${allScans.length}",
                    icon: Icons.history,
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem(
                    label: loc.translate("avg_quality"),
                    value: allScans.isEmpty ? "0%" : "$avgScore%",
                    icon: Icons.stars,
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem(
                    label: "Grade A",
                    value: "${allScans.where((s) => s.qualityGrade.toUpperCase() == 'A').length}",
                    icon: Icons.verified,
                  ),
                ],
              ),
            ),
          ),

          // Grade Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(label: "सर्व (All)", filterKey: "ALL"),
                const SizedBox(width: 8),
                _buildFilterChip(label: "Grade A (Super)", filterKey: "A"),
                const SizedBox(width: 8),
                _buildFilterChip(label: "Grade B (Domestic)", filterKey: "B"),
                const SizedBox(width: 8),
                _buildFilterChip(label: "Grade C (Rejection)", filterKey: "C"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // List of Records
          Expanded(
            child: filteredScans.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            loc.translate("no_records_yet"),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.onionPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ScannerScreen()),
                              );
                            },
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            label: Text(
                              loc.translate("scan_onion"),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: filteredScans.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) {
                      final item = filteredScans[index];
                      final isA = item.qualityGrade.toUpperCase() == 'A';
                      final isB = item.qualityGrade.toUpperCase() == 'B';
                      final gradeColor = isA ? AppColors.gradeA : (isB ? AppColors.gradeB : AppColors.gradeC);

                      final dateStr =
                          "${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} • ${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}";

                      final audioText =
                          "${item.varietyLocalName}. Grade ${item.qualityGrade}. Quality ${item.qualityScorePercentage}%. Expected rate ₹${item.estimatedPriceMin} to ₹${item.estimatedPriceMax} per quintal.";

                      return Dismissible(
                        key: ValueKey("scan_${item.timestamp.millisecondsSinceEpoch}_$index"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          final originalIndex = allScans.indexOf(item);
                          if (originalIndex != -1) {
                            appState.deleteScan(originalIndex);
                          }
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScanResultScreen(result: item)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
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
                            child: Row(
                              children: [
                                // Thumbnail / Icon
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 65,
                                    height: 65,
                                    color: AppColors.onionPurple.withValues(alpha: 0.08),
                                    child: (item.imagePath != null && File(item.imagePath!).existsSync())
                                        ? Image.file(File(item.imagePath!), fit: BoxFit.cover)
                                        : const Center(
                                            child: Text("🧅", style: TextStyle(fontSize: 32)),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: gradeColor.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "Grade ${item.qualityGrade} (${item.qualityScorePercentage}%)",
                                              style: TextStyle(
                                                color: gradeColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            dateStr,
                                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.varietyLocalName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "₹${item.estimatedPriceMin} - ₹${item.estimatedPriceMax}/${loc.translate('quintal')} • ${item.storageViabilityDays} ${loc.translate('days')}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                AudioSpeakButton(textToSpeak: audioText, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.agriGreen,
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        label: Text(
          loc.translate("scan_onion"),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScannerScreen()),
          );
        },
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: AppColors.goldAmber, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFilterChip({required String label, required String filterKey}) {
    final isSelected = _selectedFilter == filterKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.onionPurple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? AppColors.onionPurple : Colors.grey.shade300),
      onSelected: (val) {
        if (val) {
          setState(() {
            _selectedFilter = filterKey;
          });
        }
      },
    );
  }

  void _confirmClearHistory(BuildContext context, AppStateProvider appState, LocalizationService loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(loc.translate("clear_history")),
        content: const Text("सर्व स्कॅन रेकॉर्ड पुसून टाकायचे आहेत का? / Are you sure you want to clear all inspection records?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.translate("cancel")),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              appState.clearScanHistory();
              Navigator.pop(ctx);
            },
            child: Text(loc.translate("clear_history"), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
