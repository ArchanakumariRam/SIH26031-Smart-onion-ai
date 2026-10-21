import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class StorageAdvisorScreen extends StatelessWidget {
  const StorageAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    final audioText = """
${loc.translate("storage_advisor")}.
${loc.translate("chawl_optimal")}.
${loc.translate("layer_depth_title")}: ${loc.translate("layer_depth_desc")}
${loc.translate("sorting_title")}: ${loc.translate("sorting_desc")}
${loc.translate("ventilation_title")}: ${loc.translate("ventilation_desc")}
${loc.translate("inspection_title")}: ${loc.translate("inspection_desc")}
""";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.translate("storage_advisor"),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
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
            // Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate("storage_advisor"),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loc.translate("chawl_optimal"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.translate("storage_viability"),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              loc.translate("storage_rules_title"),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            _buildTipCard(
              number: "1",
              title: loc.translate("layer_depth_title"),
              description: loc.translate("layer_depth_desc"),
              icon: Icons.layers,
            ),
            _buildTipCard(
              number: "2",
              title: loc.translate("sorting_title"),
              description: loc.translate("sorting_desc"),
              icon: Icons.filter_alt,
            ),
            _buildTipCard(
              number: "3",
              title: loc.translate("ventilation_title"),
              description: loc.translate("ventilation_desc"),
              icon: Icons.air,
            ),
            _buildTipCard(
              number: "4",
              title: loc.translate("inspection_title"),
              description: loc.translate("inspection_desc"),
              icon: Icons.checklist,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.onionPurple.withValues(alpha: 0.1),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.onionPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
