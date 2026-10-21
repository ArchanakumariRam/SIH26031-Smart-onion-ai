import '../models/mandi_rate.dart';
import '../models/market_trend.dart';

class MandiService {
  static final MandiService _instance = MandiService._internal();
  factory MandiService() => _instance;
  MandiService._internal();

  // All India Cities Rate Comparison (Ranked & Categorized)
  List<CityRateComparison> getAllIndiaCityRates({String originCity = "नाशिक (Nashik)"}) {
    return [
      CityRateComparison(
        cityName: "दिल्ली (Delhi)",
        state: "Delhi",
        mandiName: "आझादपूर मंडी (Azadpur)",
        modalPrice: 3850,
        minPrice: 2800,
        maxPrice: 4200,
        lastYearModalPrice: 3100,
        distanceKm: 1150,
        isHighest: true,
      ),
      CityRateComparison(
        cityName: "कोलकाता (Kolkata)",
        state: "West Bengal",
        mandiName: "पोस्ता बाजार (Posta)",
        modalPrice: 3720,
        minPrice: 2750,
        maxPrice: 4100,
        lastYearModalPrice: 2980,
        distanceKm: 1680,
      ),
      CityRateComparison(
        cityName: "बंगळुरू (Bengaluru)",
        state: "Karnataka",
        mandiName: "यशवंतपूर (Yeshwantpur)",
        modalPrice: 3450,
        minPrice: 2400,
        maxPrice: 3800,
        lastYearModalPrice: 2850,
        distanceKm: 980,
      ),
      CityRateComparison(
        cityName: "मुंबई (Mumbai)",
        state: "Maharashtra",
        mandiName: "वाशी एपीएमसी (Vashi APMC)",
        modalPrice: 3200,
        minPrice: 2200,
        maxPrice: 3600,
        lastYearModalPrice: 2600,
        distanceKm: 170,
      ),
      CityRateComparison(
        cityName: "हैदराबाद (Hyderabad)",
        state: "Telangana",
        mandiName: "मलकपेट मंडी (Malakpet)",
        modalPrice: 3150,
        minPrice: 2100,
        maxPrice: 3500,
        lastYearModalPrice: 2550,
        distanceKm: 650,
      ),
      CityRateComparison(
        cityName: "पिंपळगाव (Pimpalgaon)",
        state: "Maharashtra",
        mandiName: "पिंपळगाव बसवंत बाजार समिती",
        modalPrice: 2720,
        minPrice: 1900,
        maxPrice: 3220,
        lastYearModalPrice: 2150,
        distanceKm: 32,
      ),
      CityRateComparison(
        cityName: "लासलगाव (Lasalgaon)",
        state: "Maharashtra",
        mandiName: "लासलगाव मुख्य बाजार समिती",
        modalPrice: 2650,
        minPrice: 1850,
        maxPrice: 3150,
        lastYearModalPrice: 2100,
        distanceKm: 25,
      ),
      CityRateComparison(
        cityName: "पुणे (Pune)",
        state: "Maharashtra",
        mandiName: "गुलटेकडी मार्केट यार्ड",
        modalPrice: 2680,
        minPrice: 1950,
        maxPrice: 3100,
        lastYearModalPrice: 2120,
        distanceKm: 190,
      ),
      CityRateComparison(
        cityName: "इंदौर (Indore)",
        state: "Madhya Pradesh",
        mandiName: "देवी अहिल्याबाई होळकर मंडी",
        modalPrice: 2500,
        minPrice: 1700,
        maxPrice: 2950,
        lastYearModalPrice: 1980,
        distanceKm: 420,
      ),
      CityRateComparison(
        cityName: "सोलापूर (Solapur)",
        state: "Maharashtra",
        mandiName: "सोलापूर कृषी उत्पन्न बाजार समिती",
        modalPrice: 2390,
        minPrice: 1600,
        maxPrice: 2800,
        lastYearModalPrice: 1850,
        distanceKm: 280,
        isLowest: true,
      ),
    ];
  }

  // Historical Price Comparison: Last Year vs This Year Month-by-Month
  List<HistoricalPricePoint> getHistoricalComparisonData() {
    return [
      HistoricalPricePoint(month: "Jan", monthLocal: "जाने", currentYearPrice: 1950, lastYearPrice: 1550, arrivalIndex: 85),
      HistoricalPricePoint(month: "Feb", monthLocal: "फेब्रु", currentYearPrice: 1820, lastYearPrice: 1420, arrivalIndex: 92),
      HistoricalPricePoint(month: "Mar", monthLocal: "मार्च", currentYearPrice: 1680, lastYearPrice: 1350, arrivalIndex: 110),
      HistoricalPricePoint(month: "Apr", monthLocal: "एप्रिल", currentYearPrice: 1550, lastYearPrice: 1280, arrivalIndex: 125),
      HistoricalPricePoint(month: "May", monthLocal: "मे", currentYearPrice: 1720, lastYearPrice: 1410, arrivalIndex: 105),
      HistoricalPricePoint(month: "Jun", monthLocal: "जून", currentYearPrice: 2100, lastYearPrice: 1650, arrivalIndex: 78),
      HistoricalPricePoint(month: "Jul", monthLocal: "जुलै", currentYearPrice: 2350, lastYearPrice: 1820, arrivalIndex: 65),
      HistoricalPricePoint(month: "Aug", monthLocal: "ऑगस्ट", currentYearPrice: 2550, lastYearPrice: 2050, arrivalIndex: 58),
      HistoricalPricePoint(month: "Sep", monthLocal: "सप्टें", currentYearPrice: 2680, lastYearPrice: 2200, arrivalIndex: 52),
      HistoricalPricePoint(month: "Oct", monthLocal: "ऑक्टो", currentYearPrice: 2850, lastYearPrice: 2450, arrivalIndex: 48),
      HistoricalPricePoint(month: "Nov", monthLocal: "नोव्हें", currentYearPrice: 3200, lastYearPrice: 2750, arrivalIndex: 40),
      HistoricalPricePoint(month: "Dec", monthLocal: "डिसें", currentYearPrice: 2950, lastYearPrice: 2350, arrivalIndex: 60),
    ];
  }

  // Predictive Selling Decision Engine: "When Should I Sell My Onion?"
  SellingPrediction getSellingPrediction({
    String onionVariety = "Garwa",
    int storageDaysRemaining = 60,
    String languageCode = "en",
  }) {
    List<MarketFactor> factors;
    String verdictTitle;
    String verdictDescription;

    if (languageCode == 'mr') {
      verdictTitle = "१५ दिवस थांबा! (Hold for 15 Days)";
      verdictDescription = "कांदा आत्ता घाईगडबडीत विकू नका. पुढील १५ दिवसांत आवक कमी राहून भावात ₹३५० ते ₹५०० प्रति क्विंटल वाढीचा स्पष्ट अंदाज आहे. मात्र २५% गोळटा किंवा डहाळा कांदा लगेच काढून विका.";
      factors = [
        MarketFactor(
          title: "सणासुदीची वाढती मागणी (Festive Demand)",
          impact: "POSITIVE",
          description: "दिवाळी व आगामी सणांमुळे उत्तरेकडील राज्यांतून (दिल्ली, पंजाब, यूपी) मागणी २०% वाढली आहे.",
          impactPoints: 25,
        ),
        MarketFactor(
          title: "खरीप लाल कांदा आवक विलंब (Late Kharif)",
          impact: "POSITIVE",
          description: "पावसामुळे नवीन लाल कांद्याची आवक १५ ते २० दिवस पुढे ढकलली गेली आहे, ज्यामुळे उन्हाळ कांद्याला टंचाईचा फायदा मिळेल.",
          impactPoints: 30,
        ),
        MarketFactor(
          title: "सरकारी बफर स्टॉक रिलीज (NAFED Buffer)",
          impact: "NEGATIVE",
          description: "नाफेडकडून मोठ्या शहरांत ₹३५/किलो अनुदानित दराने कांदा विक्री सुरू झाल्याने भाव अचानक खूप वाढण्यावर नियंत्रण राहील.",
          impactPoints: -15,
        ),
        MarketFactor(
          title: "चाळीतील आर्द्रता व सड धोका (Storage Rot Risk)",
          impact: "NEGATIVE",
          description: "हवेत आर्द्रता वाढल्यास चाळीत १०-१५% कांदा सडण्याची शक्यता असते. कांदा निवडून ठेवणे गरजेचे आहे.",
          impactPoints: -10,
        ),
      ];
    } else if (languageCode == 'hi') {
      verdictTitle = "१५ दिन रुकें! (Hold for 15 Days)";
      verdictDescription = "जल्दबाजी में सारा प्याज न बेचें। अगले १५ दिनों में आवक कम रहने से भाव में ₹३५० से ₹५०० प्रति क्विंटल तेजी का स्पष्ट अनुमान है। केवल मोटे डंठल व खराब प्याज अभी बेचें।";
      factors = [
        MarketFactor(
          title: "त्योहारी मांग में भारी वृद्धि (Festive Demand)",
          impact: "POSITIVE",
          description: "त्योहारों के चलते उत्तर भारत (दिल्ली, पंजाब, यूपी) से प्याज की मांग २०% बढ़ी है।",
          impactPoints: 25,
        ),
        MarketFactor(
          title: "खरीफ लाल प्याज की आवक में देरी (Late Kharif)",
          impact: "POSITIVE",
          description: "बारिश के कारण नए लाल प्याज की फसल १५-२० दिन लेट है, जिससे रबी प्याज को अच्छा भाव मिलेगा।",
          impactPoints: 30,
        ),
        MarketFactor(
          title: "सरकारी बफर स्टॉक रिलीज (NAFED Buffer)",
          impact: "NEGATIVE",
          description: "नेफेड द्वारा ₹३५/किलो की दर से बफर स्टॉक बेचने से भाव पर हल्का दबाव रह सकता है।",
          impactPoints: -15,
        ),
        MarketFactor(
          title: "चाली में नमी व सड़न का खतरा (Storage Rot Risk)",
          impact: "NEGATIVE",
          description: "मौसम में नमी बढ़ने पर प्याज में १०% सड़न का खतरा रहता है। लगातार छंटाई करें।",
          impactPoints: -10,
        ),
      ];
    } else {
      // Default English
      verdictTitle = "Hold for 15 Days! (Recommended)";
      verdictDescription = "Do not panic sell your stock. Prices are forecasted to appreciate by ₹350 to ₹500 per Quintal over the next 15 days due to festival supply crunches. However, sort and liquidate lower-grade twin bulbs now.";
      factors = [
        MarketFactor(
          title: "Upcoming Festive Demand Surge",
          impact: "POSITIVE",
          description: "Purchasing orders from North Indian states (Delhi, Punjab, UP) have jumped 20% ahead of festival season.",
          impactPoints: 25,
        ),
        MarketFactor(
          title: "Delayed Kharif Red Onion Arrivals",
          impact: "POSITIVE",
          description: "Untimely rains delayed the harvest of new Kharif crop by 15-20 days, giving Rabi summer onion higher pricing power.",
          impactPoints: 30,
        ),
        MarketFactor(
          title: "Government NAFED Buffer Stock Sale",
          impact: "NEGATIVE",
          description: "Subsidized onion sales at ₹35/kg in metro areas will place a moderate price ceiling on speculative spikes.",
          impactPoints: -15,
        ),
        MarketFactor(
          title: "Chawl Humidity & Rotting Risk",
          impact: "NEGATIVE",
          description: "Elevated monsoon relative humidity risks 10-15% neck-rot unless active aeration fans are maintained.",
          impactPoints: -10,
        ),
      ];
    }

    return SellingPrediction(
      sellingScore: 82,
      verdict: "HOLD_15_DAYS",
      verdictTitle: verdictTitle,
      verdictDescription: verdictDescription,
      expectedPriceIn15Days: 3100,
      expectedPriceIn30Days: 3350,
      confidencePercentage: 88.5,
      factors: factors,
    );
  }

  List<MandiRate> getLiveMandiRates({String originCity = "नाशिक (Nashik)"}) {
    final cityLower = originCity.toLowerCase();

    double getDist(String mandiKey) {
      if (cityLower.contains('पुणे') || cityLower.contains('pune')) {
        switch (mandiKey) {
          case 'Pune':
            return 12.0;
          case 'Mumbai':
            return 150.0;
          case 'Ahmednagar':
            return 125.0;
          case 'Lasalgaon':
            return 215.0;
          case 'Pimpalgaon':
            return 235.0;
          case 'Yeola':
            return 240.0;
          case 'Solapur':
            return 250.0;
          case 'Delhi':
            return 1420.0;
          default:
            return 180.0;
        }
      } else if (cityLower.contains('सोलापूर') || cityLower.contains('solapur')) {
        switch (mandiKey) {
          case 'Solapur':
            return 10.0;
          case 'Pune':
            return 250.0;
          case 'Ahmednagar':
            return 220.0;
          case 'Lasalgaon':
            return 340.0;
          case 'Pimpalgaon':
            return 360.0;
          case 'Yeola':
            return 325.0;
          case 'Mumbai':
            return 395.0;
          case 'Delhi':
            return 1520.0;
          default:
            return 260.0;
        }
      } else if (cityLower.contains('अहमदनगर') || cityLower.contains('ahmednagar')) {
        switch (mandiKey) {
          case 'Ahmednagar':
            return 12.0;
          case 'Pune':
            return 120.0;
          case 'Lasalgaon':
            return 135.0;
          case 'Pimpalgaon':
            return 155.0;
          case 'Yeola':
            return 110.0;
          case 'Solapur':
            return 220.0;
          case 'Mumbai':
            return 240.0;
          case 'Delhi':
            return 1310.0;
          default:
            return 140.0;
        }
      } else if (cityLower.contains('धुळे') ||
          cityLower.contains('dhule') ||
          cityLower.contains('जळगाव') ||
          cityLower.contains('jalgaon')) {
        switch (mandiKey) {
          case 'Pimpalgaon':
            return 110.0;
          case 'Lasalgaon':
            return 125.0;
          case 'Yeola':
            return 130.0;
          case 'Ahmednagar':
            return 220.0;
          case 'Mumbai':
            return 325.0;
          case 'Pune':
            return 335.0;
          case 'Solapur':
            return 450.0;
          case 'Delhi':
            return 1020.0;
          default:
            return 150.0;
        }
      } else {
        // Default Nashik origin
        switch (mandiKey) {
          case 'Lasalgaon':
            return 25.0;
          case 'Pimpalgaon':
            return 32.0;
          case 'Yeola':
            return 42.0;
          case 'Ahmednagar':
            return 140.0;
          case 'Mumbai':
            return 170.0;
          case 'Pune':
            return 190.0;
          case 'Solapur':
            return 280.0;
          case 'Delhi':
            return 1150.0;
          default:
            return 50.0;
        }
      }
    }

    return [
      MandiRate(
        id: '1',
        mandiName: 'Lasalgaon APMC',
        mandiNameLocal: 'लासलगाव बाजार समिती (Lasalgaon)',
        district: 'Nashik',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1850,
        maxPrice: 3150,
        modalPrice: 2650,
        dailyChange: 80,
        arrivalTons: 1450.0,
        distanceKm: getDist('Lasalgaon'),
      ),
      MandiRate(
        id: '2',
        mandiName: 'Pimpalgaon Baswant APMC',
        mandiNameLocal: 'पिंपळगाव बसवंत बाजार समिती (Pimpalgaon)',
        district: 'Nashik',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1900,
        maxPrice: 3220,
        modalPrice: 2720,
        dailyChange: 120,
        arrivalTons: 1120.0,
        distanceKm: getDist('Pimpalgaon'),
      ),
      MandiRate(
        id: '3',
        mandiName: 'Yeola APMC',
        mandiNameLocal: 'येवला बाजार समिती (Yeola)',
        district: 'Nashik',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1750,
        maxPrice: 2950,
        modalPrice: 2480,
        dailyChange: -40,
        arrivalTons: 850.0,
        distanceKm: getDist('Yeola'),
      ),
      MandiRate(
        id: '4',
        mandiName: 'Solapur APMC',
        mandiNameLocal: 'सोलापूर बाजार समिती (Solapur)',
        district: 'Solapur',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1600,
        maxPrice: 2800,
        modalPrice: 2390,
        dailyChange: 50,
        arrivalTons: 980.0,
        distanceKm: getDist('Solapur'),
      ),
      MandiRate(
        id: '5',
        mandiName: 'Pune Gultekdi APMC',
        mandiNameLocal: 'पुणे गुलटेकडी बाजार समिती (Pune)',
        district: 'Pune',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1950,
        maxPrice: 3100,
        modalPrice: 2680,
        dailyChange: 60,
        arrivalTons: 740.0,
        distanceKm: getDist('Pune'),
      ),
      MandiRate(
        id: '6',
        mandiName: 'Ahmednagar APMC',
        mandiNameLocal: 'अहिल्यानगर बाजार समिती (Ahmednagar)',
        district: 'Ahmednagar',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 1700,
        maxPrice: 2900,
        modalPrice: 2420,
        dailyChange: -20,
        arrivalTons: 620.0,
        distanceKm: getDist('Ahmednagar'),
      ),
      MandiRate(
        id: '7',
        mandiName: 'Mumbai Vashi APMC',
        mandiNameLocal: 'मुंबई वाशी एपीएमसी (Mumbai Vashi)',
        district: 'Navi Mumbai',
        state: 'Maharashtra',
        variety: 'Garwa / उन्हाळ',
        minPrice: 2200,
        maxPrice: 3600,
        modalPrice: 3200,
        dailyChange: 90,
        arrivalTons: 1600.0,
        distanceKm: getDist('Mumbai'),
      ),
      MandiRate(
        id: '8',
        mandiName: 'Azadpur APMC',
        mandiNameLocal: 'आझादपूर मंडी (दिल्ली - Azadpur)',
        district: 'Delhi',
        state: 'Delhi',
        variety: 'Nashik Onion',
        minPrice: 2800,
        maxPrice: 4200,
        modalPrice: 3850,
        dailyChange: 150,
        arrivalTons: 2200.0,
        distanceKm: getDist('Delhi'),
      ),
    ];
  }

  List<Map<String, dynamic>> calculateBestMandiProfits({
    required double quantityQuintals,
    String originCity = "नाशिक (Nashik)",
  }) {
    return calculateTrueNetEarnings(
      quantityQuintals: quantityQuintals,
      originCity: originCity,
    );
  }

  /// Calculates true net profit breakdown: Gross, Diesel/Freight, Labour, Market Cess, Net Earnings
  List<Map<String, dynamic>> calculateTrueNetEarnings({
    required double quantityQuintals,
    String originCity = "नाशिक (Nashik)",
  }) {
    final mandis = getLiveMandiRates(originCity: originCity);
    List<Map<String, dynamic>> results = [];

    for (var m in mandis) {
      final grossRevenue = m.modalPrice * quantityQuintals;
      // Realistic freight: ₹2.2/km/qtl for inter-state (>300km) or ₹2.8/km/qtl for local (<300km)
      final ratePerKm = m.distanceKm > 300 ? 2.1 : 2.7;
      final freightCost = (m.distanceKm * ratePerKm) * quantityQuintals;
      final labourHamali = 35.0 * quantityQuintals; // हमाली व तोलाई
      final mandiCess = grossRevenue * 0.0105; // १.०५% बाजार समिती उपकर
      final totalDeductions = freightCost + labourHamali + mandiCess;
      final trueNetEarnings = grossRevenue - totalDeductions;
      final netPerQuintal = trueNetEarnings / quantityQuintals;

      results.add({
        'mandi': m,
        'gross': grossRevenue,
        'freight': freightCost,
        'labour': labourHamali,
        'cess': mandiCess,
        'totalDeductions': totalDeductions,
        'net': trueNetEarnings,
        'netPerQuintal': netPerQuintal,
      });
    }

    results.sort((a, b) => (b['net'] as double).compareTo(a['net'] as double));
    return results;
  }
}
