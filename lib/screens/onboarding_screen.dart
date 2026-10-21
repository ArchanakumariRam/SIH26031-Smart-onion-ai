import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';
import '../widgets/farmer_button.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedLang = 'en';
  String _selectedDistrict = AppConstants.majorDistricts[0];

  final List<Map<String, String>> languages = [
    {
      "code": "mr",
      "native": "मराठी",
      "sub": "कांदा ओळखा. अचूक भाव मिळवा.",
    },
    {
      "code": "hi",
      "native": "हिंदी",
      "sub": "प्याज पहचानें. सही भाव पाएं.",
    },
    {
      "code": "en",
      "native": "English",
      "sub": "Identify Onion. Get Accurate Price.",
    },
    {
      "code": "te",
      "native": "తెలుగు",
      "sub": "ఉల్లిపాయను గుర్తించండి. సరైన ధరను పొందండి.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Icon / Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.onionPurple, AppColors.onionPurpleLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onionPurple.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "🧅",
                    style: TextStyle(fontSize: 54),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                loc.translate("app_name"),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onionPurple,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.translate("tagline"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.agriGreen,
                ),
              ),
              const SizedBox(height: 36),

              // Language Selection Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.translate("select_language"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Language Cards
              Column(
                children: languages.map((lang) {
                  final isSelected = _selectedLang == lang['code'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _selectedLang = lang['code']!;
                        });
                        Provider.of<AppStateProvider>(context, listen: false)
                            .changeLanguage(lang['code']!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.onionPurple.withValues(alpha: 0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.onionPurple : Colors.grey.shade300,
                            width: isSelected ? 2.2 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.onionPurple : Colors.grey,
                                  width: 2,
                                ),
                                color: isSelected ? AppColors.onionPurple : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['native']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? AppColors.onionPurple : AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    lang['sub']!,
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
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // District Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.translate("select_district"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedDistrict,
                    items: AppConstants.majorDistricts.map((String d) {
                      return DropdownMenuItem<String>(
                        value: d,
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      if (val != null) {
                        setState(() {
                          _selectedDistrict = val;
                        });
                        Provider.of<AppStateProvider>(context, listen: false)
                            .setDistrict(val);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Continue Button
              FarmerButton(
                text: loc.translate("continue_btn"),
                isLarge: true,
                icon: Icons.arrow_forward,
                backgroundColor: AppColors.agriGreen,
                onPressed: () async {
                  await StorageService().setOnboarded(true);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
