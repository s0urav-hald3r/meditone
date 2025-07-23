import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/widgets/wave_visualizer.dart';
import 'package:meditone/widgets/premium_banner.dart';

class HomeScreen extends StatelessWidget {
  final MeditationController meditationController =
      Get.find<MeditationController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Premium banner at the top
                const PremiumBanner(
                  title: 'Unlock Premium Features',
                  subtitle:
                      'Get unlimited animations, music, and ad-free experience',
                ),

                Expanded(
                  child: Center(
                    child: _buildAnimationSection(context),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMusicInfoSection(context),
                      const SizedBox(height: 16),
                      _buildWaveSection(),
                      const SizedBox(height: 16),
                      _buildTimerSection(context),
                      const SizedBox(height: 16),
                      _buildControlsSection(context),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAnimationSection(BuildContext context) {
    final selectedAnimation = meditationController.selectedAnimation.value;
    final isAnimating = meditationController.isPlaying.value &&
        !meditationController.animationPaused.value;

    if (selectedAnimation.id != null) {
      return Lottie.asset(
        selectedAnimation.path ?? '',
        width: double.infinity,
        height: 300,
        fit: BoxFit.contain,
        animate: isAnimating,
      );
    } else {
      return Container(
        width: double.infinity,
        height: 300,
        alignment: Alignment.center,
        child: const CupertinoActivityIndicator(),
      );
    }
  }

  Widget _buildMusicInfoSection(BuildContext context) {
    final selectedMusic = meditationController.selectedMusic.value;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.music_note_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedMusic.name ?? 'No Music Selected',
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                selectedMusic.description ??
                    'Select music from the Music screen',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaveSection() {
    final isAnimating = meditationController.isPlaying.value &&
        !meditationController.animationPaused.value;
    return WaveVisualizer(
      progress: meditationController.progress.value,
      isPlaying: isAnimating,
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          meditationController
              .formatDuration(meditationController.currentDuration.value),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          meditationController
              .formatDuration(meditationController.totalDuration.value),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildControlsSection(BuildContext context) {
    if (meditationController.isPlaying.value) {
      // Playing state - show pause and stop
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.pause_rounded,
            label: 'Pause',
            onTap: () {
              meditationController.pauseMeditation();
            },
          ),
          _buildControlButton(
            icon: Icons.stop_rounded,
            label: 'End',
            onTap: () {
              meditationController.stopMeditation();
            },
            isPrimary: false,
          ),
        ],
      );
    } else if (meditationController.currentDuration.value > 0 &&
        !meditationController.isCompleted.value) {
      // Paused state - show resume and stop
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.play_arrow_rounded,
            label: 'Resume',
            onTap: () {
              meditationController.resumeMeditation();
            },
          ),
          _buildControlButton(
            icon: Icons.stop_rounded,
            label: 'End',
            onTap: () {
              meditationController.stopMeditation();
            },
            isPrimary: false,
          ),
        ],
      );
    } else {
      // Initial or stopped state - show start button
      return Center(
        child: _buildControlButton(
          icon: Icons.play_arrow_rounded,
          label: 'Start Meditation',
          onTap: () {
            if (meditationController.selectedMusic.value.id != null) {
              meditationController.startMeditation();
            } else {
              Get.snackbar(
                'No Music Selected',
                'Please select a music track from the Music screen',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.surfaceColor,
                colorText: AppTheme.textPrimaryColor,
                margin: const EdgeInsets.all(16),
              );
            }
          },
          isWide: true,
        ),
      );
    }
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = true,
    bool isWide = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isWide ? double.infinity : 150,
        height: 50,
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
