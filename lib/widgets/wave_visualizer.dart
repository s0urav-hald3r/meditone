import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:meditone/themes/app_theme.dart';

class WaveVisualizer extends StatelessWidget {
  final double progress;
  final bool isPlaying;

  const WaveVisualizer({
    super.key,
    required this.progress,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: isPlaying ? _buildActiveWave() : _buildIdleWave(),
    );
  }

  Widget _buildActiveWave() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.5),
          ],
          [
            AppTheme.secondaryColor,
            AppTheme.secondaryColor.withOpacity(0.5),
          ],
          [
            AppTheme.accentColor,
            AppTheme.accentColor.withOpacity(0.5),
          ],
        ],
        durations: [
          3000,
          5000,
          7000,
        ],
        heightPercentages: [
          0.65,
          0.66,
          0.68,
        ],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
        blur:
            const MaskFilter.blur(BlurStyle.solid, 2.5), // Reduced from 5 to 2
      ),
      waveAmplitude: 25,
      backgroundColor: Colors.transparent,
      size: const Size(
        double.infinity,
        double.infinity,
      ),
    );
  }

  Widget _buildIdleWave() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            AppTheme.primaryColor.withOpacity(0.4),
            AppTheme.primaryColor.withOpacity(0.2),
          ],
          [
            AppTheme.secondaryColor.withOpacity(0.4),
            AppTheme.secondaryColor.withOpacity(0.2),
          ],
          [
            AppTheme.accentColor.withOpacity(0.4),
            AppTheme.accentColor.withOpacity(0.2),
          ],
        ],
        durations: [
          20000,
          20000,
          20000,
        ],
        heightPercentages: [
          0.3,
          0.35,
          0.4,
        ],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
        blur: const MaskFilter.blur(BlurStyle.solid, 3), // Reduced from 10 to 3
      ),
      waveAmplitude: 5,
      backgroundColor: Colors.transparent,
      size: const Size(
        double.infinity,
        double.infinity,
      ),
    );
  }
}
