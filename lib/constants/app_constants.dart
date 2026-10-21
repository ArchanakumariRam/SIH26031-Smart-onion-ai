class AppConstants {
  static const String appVersion = "1.0.0";
  
  // Storage keys
  static const String keyLanguage = "selected_language";
  static const String keyDistrict = "selected_district";
  static const String keyApiKey = "gemini_api_key";

  // Districts
  static const List<String> majorDistricts = [
    "नाशिक (Nashik)",
    "अहिल्यानगर / अहमदनगर (Ahmednagar)",
    "पुणे (Pune)",
    "सोलापूर (Solapur)",
    "धुळे (Dhule)",
    "जळगाव (Jalgaon)",
    "छ. संभाजीनगर (Aurangabad)",
    "इंदौर (Indore)",
  ];

  // System Prompt for Gemini Multimodal Onion Analysis
  static const String geminiOnionPrompt = """
You are the world's leading Agri-AI Computer Vision expert specializing in Indian Onions (Allium cepa), APMC Mandi quality sorting, and post-harvest storage physiology.

Analyze the given image of the onion(s).
Strictly detect:
1. Variety: 'Garwa' (उन्हाळ/रबी, pinkish copper, tight skin), 'Rangda' (रांगडा, dark red/purple), 'Pol' (लाल/खरीफ, light red, loose skin), or 'White' (पांढरा).
2. Size grade:
   - 'Big' (Equatorial diameter >60mm)
   - 'Medium' (45-60mm)
   - 'Golta' (30-45mm)
   - 'Golti' (<30mm baby onion)
3. Quality Grade:
   - 'A': Firm neck, intact papery scales, dry, zero disease, export quality.
   - 'B': Good domestic market, slight skin peeling, minor size variations.
   - 'C': Defective, sprouting, rot, thick neck (डहाळा), cuts.
4. Defects detected list (sprouting, black_mold, soft_rot, purple_blotch, twin_bulbs, thick_neck, none).
5. Storage viability in days (e.g. 0 to 120 days depending on neck tightness and skin quality).
6. Localized action advice (concise, practical advice in Marathi or user's requested language).
7. Estimated price range band per quintal (₹ INR).

Respond ONLY with valid raw JSON in the following schema (no markdown fences, no extra text):
{
  "variety": "Garwa",
  "variety_local_name": "उन्हाळ कांदा (Garwa)",
  "size_grade": "Medium",
  "quality_grade": "A",
  "quality_score_percentage": 92,
  "defects_detected": ["none"],
  "storage_viability_days": 90,
  "action_advice": "कांद्याची प्रत उत्तम व मान कोरडी आहे. हा कांदा चाळीत ३ महिने सहज टिकू शकतो. भाव वाढीची वाट पाहू शकता.",
  "estimated_price_range_per_quintal": {
    "min": 2400,
    "max": 2850
  }
}
""";
}
