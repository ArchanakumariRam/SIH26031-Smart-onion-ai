import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/localization_service.dart';
import 'dashboard_screen.dart';
import 'scanner_screen.dart';
import 'market_intelligence_screen.dart';
import 'crop_doctor_screen.dart';
import 'voice_assistant_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 1) {
      // Scanner opens as dedicated full-screen camera view
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScannerScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    final List<Widget> screens = [
      DashboardScreen(onTabChange: (idx) {
        setState(() {
          _currentIndex = idx;
        });
      }),
      const SizedBox(), // Placeholder for scanner
      const MarketIntelligenceScreen(),
      const CropDoctorScreen(),
      const VoiceAssistantScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.onionPurple,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: loc.translate("home"),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.onionPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
              label: loc.translate("scan_onion"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.trending_up_outlined),
              activeIcon: const Icon(Icons.trending_up),
              label: loc.translate("live_mandi"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.healing_outlined),
              activeIcon: const Icon(Icons.healing),
              label: loc.translate("crop_doctor"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.mic_none_outlined),
              activeIcon: const Icon(Icons.mic),
              label: loc.translate("voice_assistant"),
            ),
          ],
        ),
      ),
    );
  }
}
