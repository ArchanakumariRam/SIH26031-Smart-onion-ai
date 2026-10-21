import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/price_alert_item.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class PriceAlertScreen extends StatefulWidget {
  const PriceAlertScreen({super.key});

  @override
  State<PriceAlertScreen> createState() => _PriceAlertScreenState();
}

class _PriceAlertScreenState extends State<PriceAlertScreen> {
  final List<String> _mandis = [
    'Lasalgaon APMC (लासलगाव)',
    'Pimpalgaon APMC (पिंपळगाव)',
    'Pune Gultekdi (पुणे)',
    'Solapur APMC (सोलापूर)',
    'Ahmednagar APMC (अहिल्यानगर)',
    'Mumbai Vashi (मुंबई वाशी)',
    'Azadpur Delhi (दिल्ली आझादपूर)',
  ];

  void _showAddAlertDialog(BuildContext context, AppStateProvider appState, LocalizationService loc) {
    String selectedMandi = _mandis.first;
    String condition = 'ABOVE';
    final TextEditingController priceController = TextEditingController(text: '2800');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
              Text(
                loc.translate("set_alert"),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 16),

              // Mandi Dropdown
              Text(loc.translate("select_mandi"), style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedMandi,
                    items: _mandis.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setSheetState(() => selectedMandi = val);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Target Price
              Text(loc.translate("target_price"), style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "2800",
                  prefixText: "₹ ",
                  suffixText: loc.translate("quintal"),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 14),

              // Condition
              Text(loc.translate("alert_condition"), style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(loc.translate("alert_above")),
                      selected: condition == 'ABOVE',
                      selectedColor: AppColors.onionPurple,
                      labelStyle: TextStyle(color: condition == 'ABOVE' ? Colors.white : AppColors.textDark, fontSize: 11, fontWeight: FontWeight.bold),
                      onSelected: (val) {
                        if (val) setSheetState(() => condition = 'ABOVE');
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(loc.translate("alert_below")),
                      selected: condition == 'BELOW',
                      selectedColor: Colors.deepOrange,
                      labelStyle: TextStyle(color: condition == 'BELOW' ? Colors.white : AppColors.textDark, fontSize: 11, fontWeight: FontWeight.bold),
                      onSelected: (val) {
                        if (val) setSheetState(() => condition = 'BELOW');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onionPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final price = int.tryParse(priceController.text) ?? 2800;
                  final newAlert = PriceAlertItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    mandiName: selectedMandi,
                    targetPrice: price,
                    condition: condition,
                    isEnabled: true,
                  );
                  appState.addPriceAlert(newAlert);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.currentLanguage == 'mr'
                          ? "अलर्ट यशस्वीपणे सेव्ह झाला!"
                          : loc.currentLanguage == 'hi'
                              ? "अलर्ट सफलतापूर्वक सहेजा गया!"
                              : "Price Alert Saved Successfully!"),
                      backgroundColor: AppColors.agriGreen,
                    ),
                  );
                },
                child: Text(loc.translate("save"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerSimulationAlert(BuildContext context, LocalizationService loc) {
    final alertMessage = loc.currentLanguage == 'hi'
        ? "अलर्ट सूचना! लासलगांव मंडी में प्याज का भाव ₹२,८५०/क्विंटल पहुंचा (आपके लक्ष्य ₹२,८०० से अधिक)। बेचने का सबसे उपयुक्त समय!"
        : loc.currentLanguage == 'mr'
            ? "लाईव्ह भाव अलर्ट! लासलगाव बाजार समितीत कांदा भाव ₹२,८५० प्रति क्विंटल झाला आहे (तुमच्या ₹२,८०० लक्ष्यापेक्षा जास्त). विक्रीसाठी सर्वोत्तम वेळ!"
            : "Live Price Alert! Lasalgaon APMC rate hit ₹2,850/Quintal (Exceeds your target of ₹2,800). Selling score 85/100 (Optimal time to sell!)";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active, color: AppColors.agriGreen, size: 42),
            ),
            const SizedBox(height: 16),
            const Text(
              "🔔 LIVE PRICE TRIGGERED",
              style: TextStyle(color: AppColors.agriGreen, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            const Text(
              "Lasalgaon APMC • ₹2,850/Qtl",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              alertMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            AudioSpeakButton(textToSpeak: alertMessage, size: 24),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onionPurple,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);
    final alerts = appState.priceAlerts;

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
          loc.translate("price_alerts_title"),
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Banner with Test Notification Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF311B92), Color(0xFF512DA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF311B92).withValues(alpha: 0.3),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldAmber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "⚡ Market Trend Tracker",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        "${alerts.length} ${loc.currentLanguage == 'mr' ? 'अलर्ट सुरू' : loc.currentLanguage == 'hi' ? 'अलर्ट सक्रिय' : 'Active Alerts'}",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.currentLanguage == 'mr'
                        ? "तुमच्या पसंतीच्या बाजार समितीत भाव वाढल्यास त्वरित सूचना मिळवा"
                        : loc.currentLanguage == 'hi'
                            ? "अपनी पसंदीदा मंडी में भाव बढ़ने पर तत्काल अलर्ट प्राप्त करें"
                            : "Get Instant Push Notifications when onion rates hit your target price",
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF311B92),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: () => _triggerSimulationAlert(context, loc),
                    icon: const Icon(Icons.notifications_active, color: Colors.deepOrange, size: 20),
                    label: Text(
                      loc.translate("simulate_alert"),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.translate("price_alerts_title"),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                TextButton.icon(
                  onPressed: () => _showAddAlertDialog(context, appState, loc),
                  icon: const Icon(Icons.add_circle, color: AppColors.onionPurple, size: 18),
                  label: Text(
                    loc.translate("set_alert"),
                    style: const TextStyle(color: AppColors.onionPurple, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Active Alerts List
          Expanded(
            child: alerts.isEmpty
                ? Center(
                    child: Text(
                      loc.currentLanguage == 'mr'
                          ? "कोणताही अलर्ट सेट केलेला नाही."
                          : loc.currentLanguage == 'hi'
                              ? "कोई अलर्ट सेट नहीं किया गया है।"
                              : "No price alerts set yet.",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: alerts.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      final item = alerts[index];
                      final isAbove = item.condition == 'ABOVE';

                      return Dismissible(
                        key: ValueKey("alert_${item.id}_$index"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          appState.deletePriceAlert(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isAbove ? Colors.green.shade50 : Colors.red.shade50,
                                child: Icon(
                                  isAbove ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isAbove ? AppColors.agriGreen : Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.mandiName,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${isAbove ? '≥' : '≤'} ₹${item.targetPrice} / ${loc.translate('quintal')}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isAbove ? AppColors.agriGreen : Colors.deepOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: item.isEnabled,
                                activeThumbColor: AppColors.agriGreen,
                                onChanged: (val) {
                                  appState.togglePriceAlert(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                onPressed: () => appState.deletePriceAlert(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.onionPurple,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: Text(
          loc.translate("set_alert"),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showAddAlertDialog(context, appState, loc),
      ),
    );
  }
}
