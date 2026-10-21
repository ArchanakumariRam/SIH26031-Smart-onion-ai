import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedSellingGauge extends StatefulWidget {
  final int score; // 0 to 100
  final String verdict;
  final String verdictTitle;

  const AnimatedSellingGauge({
    super.key,
    required this.score,
    required this.verdict,
    required this.verdictTitle,
  });

  @override
  State<AnimatedSellingGauge> createState() => _AnimatedSellingGaugeState();
}

class _AnimatedSellingGaugeState extends State<AnimatedSellingGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedSellingGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentVal = (_animation.value * 100).toInt();

        // Determine color based on score
        Color gaugeColor;
        if (widget.score >= 75) {
          gaugeColor = AppColors.agriGreen;
        } else if (widget.score >= 50) {
          gaugeColor = AppColors.goldAmber;
        } else {
          gaugeColor = AppColors.danger;
        }

        return Column(
          children: [
            SizedBox(
              width: 200,
              height: 120,
              child: CustomPaint(
                painter: _GaugePainter(
                  progress: _animation.value,
                  gaugeColor: gaugeColor,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$currentVal",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: gaugeColor,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        "/ १०० स्कोअर (Score)",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Pulsing / Highlighted Verdict Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: gaugeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: gaugeColor, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.score >= 75 ? Icons.lock_clock : Icons.sell,
                    size: 18,
                    color: gaugeColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.verdictTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: gaugeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color gaugeColor;

  _GaugePainter({required this.progress, required this.gaugeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 14;

    const startAngle = pi;
    const sweepAngle = pi;

    // Background track
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Active progress arc
    final activePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange, gaugeColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.gaugeColor != gaugeColor;
  }
}
