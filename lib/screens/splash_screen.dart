import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _rotateController;

  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  double _loadingProgress = 0.0;
  String _loadingText = "Loading AI Vision Models...";
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    // 1. Pulsing breathing glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Orbital rotating rings
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // 3. Entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();

    // Simulate animated progress loader
    _startLoadingSimulation();
  }

  void _startLoadingSimulation() {
    const totalTicks = 30;
    int currentTick = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      currentTick++;
      setState(() {
        _loadingProgress = (currentTick / totalTicks).clamp(0.0, 1.0);
        if (_loadingProgress < 0.35) {
          _loadingText = "Initializing Onion Vision Engine...";
        } else if (_loadingProgress < 0.70) {
          _loadingText = "Connecting Indian Mandi Network...";
        } else if (_loadingProgress < 0.95) {
          _loadingText = "Calibrating Grading & Price Intelligence...";
        } else {
          _loadingText = "OnionGrade+ Ready!";
        }
      });

      if (currentTick >= totalTicks) {
        timer.cancel();
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final isOnboarded = StorageService().isOnboarded();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, anim, secAnim) =>
              isOnboarded ? const MainScreen() : const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pulseController.dispose();
    _rotateController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService();

    // Tagline in user language
    String tagline = loc.translate("tagline");
    if (tagline == "tagline" || tagline.isEmpty) {
      tagline = "Identify Onion. Get Accurate Market Price.";
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF28071E), // Deep Onion Wine
              Color(0xFF4A1033), // Rich Purple
              Color(0xFF1B3B22), // Deep Agricultural Green
              Color(0xFF0F2414), // Dark Forest
            ],
            stops: [0.0, 0.45, 0.8, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Decorative Atmospheric Glow
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onionPurple.withValues(alpha: 0.3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onionPurple.withValues(alpha: 0.4),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.agriGreen.withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.agriGreen.withValues(alpha: 0.35),
                      blurRadius: 90,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Center Animated Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Animated Logo with Rotating Orbital Rings & Glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Golden Orbital Ring
                        RotationTransition(
                          turns: _rotateController,
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.goldAmber.withValues(alpha: 0.35),
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ),
                          ),
                        ),

                        // Inner Reverse Rotating Green Ring
                        RotationTransition(
                          turns: ReverseAnimation(_rotateController),
                          child: Container(
                            width: 146,
                            height: 146,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.greenAccent.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        // Glowing Pulsing Central Emblem
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xFF8B265E),
                                        AppColors.onionPurple,
                                        Color(0xFF350A22),
                                      ],
                                      stops: [0.0, 0.6, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.goldAmber.withValues(alpha: 0.45),
                                        blurRadius: 30,
                                        spreadRadius: 4,
                                      ),
                                      BoxShadow(
                                        color: AppColors.onionPurple.withValues(alpha: 0.6),
                                        blurRadius: 45,
                                        spreadRadius: 6,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // App Title & OnionGrade+ Certification Tag
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // OnionGrade+ Platform Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.goldAmber,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldAmber.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, size: 14, color: Colors.black87),
                                  SizedBox(width: 6),
                                  Text(
                                    "OnionGrade+ Enterprise AI",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Main App Title
                            const Text(
                              "Smart Onion AI",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Multilingual Subtitle
                            Text(
                              "स्मार्ट कांदा AI • स्मार्ट प्याज AI",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Core Tagline Card
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                              ),
                              child: Text(
                                tagline,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Animated Progress Bar & Status Text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Progress Bar
                          Container(
                            width: 220,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                width: 220 * _loadingProgress,
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.goldAmber,
                                      Colors.greenAccent,
                                      Color(0xFF00E676),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Dynamic Loading Stage Message
                          Text(
                            _loadingText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
