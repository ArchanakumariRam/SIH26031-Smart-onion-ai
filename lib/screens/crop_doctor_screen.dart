import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/disease_diagnosis.dart';
import '../providers/app_state_provider.dart';
import '../services/localization_service.dart';
import '../widgets/audio_speak_button.dart';

class CropDoctorScreen extends StatefulWidget {
  const CropDoctorScreen({super.key});

  @override
  State<CropDoctorScreen> createState() => _CropDoctorScreenState();
}

class _CropDoctorScreenState extends State<CropDoctorScreen> {
  int _selectedIndex = 0;

  List<DiseaseDiagnosis> _getDiseasesForLang(String lang) {
    if (lang == 'hi') {
      return [
        DiseaseDiagnosis(
          id: '1',
          name: 'Purple Blotch',
          localName: 'बैंगनी धब्बा / करपा (Purple Blotch)',
          symptoms: 'पत्तियों पर पहले हल्के सफेद-भूरे धब्बे बनते हैं, जो बाद में बैंगनी रंग में बदल जाते हैं। पत्ती ऊपर से सूखने लगती है।',
          organicTreatment: 'ट्राइकोडर्मा विरिडी (५ ग्राम/लीटर) + नीम तेल (५ मिली/लीटर) का छिड़काव करें।',
          chemicalTreatment: 'नैटिवो (Nativo - ०.७५ ग्राम/लीटर) या कस्टोडिया (१.५ मिली/लीटर) + स्टीकर मिलाकर छिड़कें।',
          preventiveTips: 'खेत में पानी जमा न होने दें। यूरिया का अत्यधिक उपयोग न करें।',
          severity: 'High',
        ),
        DiseaseDiagnosis(
          id: '2',
          name: 'Onion Thrips',
          localName: 'थ्रिप्स / रस चूसक कीट (Onion Thrips)',
          symptoms: 'पत्तियों का रस चूसने से सफेद-चांदी जैसे चकत्ते पड़ते हैं। पत्तियां मुड़ जाती हैं और विकास रुक जाता है।',
          organicTreatment: 'दशपर्णी अर्क या वर्टिसिलियम लेकेनी (५ ग्राम/लीटर) का छिड़काव।',
          chemicalTreatment: 'बेनविया (Benvia - २ मिली/लीटर) या फिप्रोनिल ५% SC (२ मिली/लीटर) शाम को छिड़कें।',
          preventiveTips: 'खेत की मेड़ों पर मक्का या ज्वार लगाएं। प्रति एकड़ २० नीले व पीले ट्रैप लगाएं।',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '3',
          name: 'Black Mold / Smudge',
          localName: 'काली फफूंद (Black Mold / Smudge)',
          symptoms: 'प्याज के ऊपरी छिलके पर काले रंग का फफूंद पाउडर दिखाई देता है। गर्दन मुलायम हो जाती है।',
          organicTreatment: 'खुदाई के बाद ३-४ दिन खेत में अच्छी तरह सुखाएं। गर्दन पूरी सूखने पर ही काटें।',
          chemicalTreatment: 'साफ (कार्बेन्डाजिम + मैंकोजेब - २ ग्राम/लीटर) का छिड़काव।',
          preventiveTips: 'चाली में रखने से पहले प्याज पूरी तरह सूखा और साफ होना चाहिए।',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '4',
          name: 'Basal Rot / Damping Off',
          localName: 'जड़ सड़न (Basal Rot / Damping Off)',
          symptoms: 'जड़ें सड़ जाती हैं और गुलाबी-भूरे रंग की होकर टूट जाती हैं। पौधा जमीन से आसानी से उखड़ जाता है।',
          organicTreatment: 'रोपाई से पूर्व ट्राइकोडर्मा से जड़ उपचार करें।',
          chemicalTreatment: 'कॉपर ऑक्सीक्लोराइड (३ ग्राम/लीटर) या रिडोमिल गोल्ड (२ ग्राम/लीटर) की ड्रेंचिंग करें।',
          preventiveTips: 'खेत में जल निकासी की अच्छी व्यवस्था रखें। फसल चक्र अपनाएं।',
          severity: 'High',
        ),
      ];
    } else if (lang == 'mr') {
      return [
        DiseaseDiagnosis(
          id: '1',
          name: 'Purple Blotch',
          localName: 'जांभळा करपा (Purple Blotch)',
          symptoms: 'पातीवर सुरुवातीला लांबट, पांढुरके डाग पडून नंतर ते जांभळे किंवा तपकिरी होतात. पात शेंड्याकडून वाळू लागते.',
          organicTreatment: 'ट्रायकोडर्मा व्हिरीडी (५ ग्रॅम/लिटर) + निंबोळी तेल (५ मिली/लिटर) फवारणी करा.',
          chemicalTreatment: 'नॅटिव्हो (Nativo - ०.७५ ग्रॅम/लिटर) किंवा कस्टोडिया (Custodia - १.५ मिली/लिटर) सोबत स्टिकर मिसळून फवारणी करा.',
          preventiveTips: 'शेतात पाणी साचू देऊ नका. नत्राचा (युरिया) अतिवापर टाळा.',
          severity: 'High',
        ),
        DiseaseDiagnosis(
          id: '2',
          name: 'Onion Thrips',
          localName: 'फुलकिडे (Thrips Attack)',
          symptoms: 'पातीचा रस शोषल्यामुळे पानांवर पांढरे चट्टे पडतात. पाने वाकडी होतात व झाडांची वाढ खुंटते.',
          organicTreatment: 'दशपर्णी अर्क किंवा व्हर्टिसिलियम लेकॅनी (५ ग्रॅम/लिटर) फवारणी.',
          chemicalTreatment: 'फिप्रोनिल ५% SC (२ मिली/लिटर) किंवा बेनव्हिया (Benvia - २ मिली/लिटर) संध्याकाळच्या वेळी फवारणी करा.',
          preventiveTips: 'शेताच्या कडेने मका किंवा ज्वारीचे संरक्षक पीक लावा. शेतात निळे व पिवळे चिकट सापळे लावा.',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '3',
          name: 'Black Mold / Smudge',
          localName: 'काळी बुरशी / काजळी (Black Mold)',
          symptoms: 'कांद्याच्या बाहेरील पापुद्र्यावर काळ्या रंगाची बुरशी पावडरसारखी दिसते. मान मऊ पडते.',
          organicTreatment: 'कांदा काढणीनंतर शेतात ३-४ दिवस चांगला वाळवा. कांद्याची मान पूर्ण सुकल्यावरच कापा.',
          chemicalTreatment: 'कार्बेन्डाझिम + मॅन्कोझेब (साफ - २ ग्रॅम/लिटर) फवारणी किंवा काढणीपूर्वी ट्रायकोडर्मा प्रक्रिया.',
          preventiveTips: 'चाळीत कांदा साठवण्यापूर्वी तो पूर्ण सुका असणे अत्यंत आवश्यक आहे.',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '4',
          name: 'Basal Rot / Damping Off',
          localName: 'मूळकुज / सड (Basal Rot)',
          symptoms: 'मुळांचा भाग सडतो, मुळे गुलाबी किंवा तपकिरी होऊन गळून पडतात. कांदा जमिनीतून सहज उपटला जातो.',
          organicTreatment: 'रोप लावणीपूर्वी ट्रायकोडर्मा जैविक बुरशीनाशकाची प्रक्रिया करा.',
          chemicalTreatment: 'कॉपर ऑक्सिक्लोराईड (३ ग्रॅम/लिटर) किंवा रेडोमिल गोल्ड (२ ग्रॅम/लिटर) मुळांशी आळवणी (Drenching) करा.',
          preventiveTips: 'वाफ्यांमध्ये पाणी तुंबणार नाही याची काळजी घ्या. फेरपालट करा.',
          severity: 'High',
        ),
      ];
    } else {
      // Default English
      return [
        DiseaseDiagnosis(
          id: '1',
          name: 'Purple Blotch',
          localName: 'Purple Blotch (Alternaria porri)',
          symptoms: 'Elliptical water-soaked lesions on leaves turning purple-brown with yellow halo. Leaf tips wither down.',
          organicTreatment: 'Trichoderma viride (5 gm/L) + Neem seed oil (5 ml/L) spray.',
          chemicalTreatment: 'Nativo (Tebuconazole+Trifloxystrobin @ 0.75 gm/L) or Custodia (1.5 ml/L) + adjuvant sticker.',
          preventiveTips: 'Ensure good field drainage. Avoid excessive nitrogen fertilizer.',
          severity: 'High',
        ),
        DiseaseDiagnosis(
          id: '2',
          name: 'Onion Thrips',
          localName: 'Onion Thrips (Thrips tabaci)',
          symptoms: 'Silvery feeding patches and distorted foliage due to sap-sucking nymphs. Plants look stunted.',
          organicTreatment: 'Dashparni ark or Verticillium lecanii bio-insecticide (5 gm/L).',
          chemicalTreatment: 'Benvia (Cyantraniliprole 10.26% OD @ 2 ml/L) or Fipronil 5% SC (2 ml/L) during evening.',
          preventiveTips: 'Plant barrier crops of maize or sorghum. Install 20 blue sticky traps per acre.',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '3',
          name: 'Black Mold / Smudge',
          localName: 'Black Mold (Aspergillus niger)',
          symptoms: 'Black powdery fungal spores between papery scales, especially around neck. Neck softens.',
          organicTreatment: 'Cure harvested bulbs in field windrows for 3-4 days until foliage is completely dry.',
          chemicalTreatment: 'Carbendazim + Mancozeb (Saaf @ 2 gm/L) foliar spray prior to harvest.',
          preventiveTips: 'Never store damp or wet neck onions in the chawl.',
          severity: 'Medium',
        ),
        DiseaseDiagnosis(
          id: '4',
          name: 'Basal Rot / Damping Off',
          localName: 'Basal Rot (Fusarium oxysporum)',
          symptoms: 'Roots rot and turn pinkish-brown, eventually detaching. Bulb pulls out effortlessly from soil.',
          organicTreatment: 'Seedling root dip with Trichoderma viride culture before transplanting.',
          chemicalTreatment: 'Soil drenching with Copper Oxychloride (3 gm/L) or Ridomil Gold (2 gm/L).',
          preventiveTips: 'Follow 3-year crop rotation. Avoid waterlogging in planting beds.',
          severity: 'High',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();
    final appState = Provider.of<AppStateProvider>(context);
    final diseases = _getDiseasesForLang(appState.currentLanguage);
    if (_selectedIndex >= diseases.length) _selectedIndex = 0;
    final selectedDisease = diseases[_selectedIndex];

    final audioText = """
${selectedDisease.localName}.
Symptoms: ${selectedDisease.symptoms}.
Chemical treatment: ${selectedDisease.chemicalTreatment}.
Organic treatment: ${selectedDisease.organicTreatment}.
""";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.translate("crop_doctor_title"),
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
            // Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.red, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      loc.translate("crop_doctor_desc"),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              loc.translate("crop_doctor_title"),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Disease Selection Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(diseases.length, (idx) {
                final d = diseases[idx];
                final isSelected = _selectedIndex == idx;
                return ChoiceChip(
                  label: Text(d.localName),
                  selected: isSelected,
                  selectedColor: AppColors.onionPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedIndex = idx;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Detailed Diagnosis Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedDisease.localName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onionPurple,
                          ),
                        ),
                      ),
                      AudioSpeakButton(textToSpeak: audioText),
                    ],
                  ),
                  const Divider(height: 24),

                  // Symptoms
                  _buildSection(
                    title: "Symptoms (लक्षणे):",
                    content: selectedDisease.symptoms,
                    icon: Icons.search,
                    iconColor: Colors.orange,
                  ),
                  const SizedBox(height: 16),

                  // Chemical Treatment
                  _buildSection(
                    title: "Chemical Spray (रासायनिक फवारणी):",
                    content: selectedDisease.chemicalTreatment,
                    icon: Icons.science,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),

                  // Organic Solution
                  _buildSection(
                    title: "Organic Remedy (सेंद्रिय उपाय):",
                    content: selectedDisease.organicTreatment,
                    icon: Icons.eco,
                    iconColor: AppColors.agriGreen,
                  ),
                  const SizedBox(height: 16),

                  // Preventive
                  _buildSection(
                    title: "Prevention (प्रतिबंधात्मक उपाय):",
                    content: selectedDisease.preventiveTips,
                    icon: Icons.shield,
                    iconColor: AppColors.onionPurple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
