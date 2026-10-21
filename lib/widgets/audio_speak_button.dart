import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../constants/app_colors.dart';

class AudioSpeakButton extends StatelessWidget {
  final String textToSpeak;
  final double size;
  final Color color;

  const AudioSpeakButton({
    super.key,
    required this.textToSpeak,
    this.size = 28,
    this.color = AppColors.onionPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, state, _) {
        final isSpeaking = state.isSpeaking;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              state.toggleSpeak(textToSpeak);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSpeaking ? AppColors.goldAmber.withValues(alpha: 0.2) : Colors.transparent,
              ),
              child: Icon(
                isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                size: size,
                color: isSpeaking ? AppColors.goldAmber : color,
              ),
            ),
          ),
        );
      },
    );
  }
}
