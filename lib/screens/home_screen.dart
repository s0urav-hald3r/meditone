import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/widgets/wave_visualizer.dart';

class HomeScreen extends StatelessWidget {
  final MeditationController meditationController =
      Get.find<MeditationController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeditationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: _buildAnimationSection(context, controller),
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
                        _buildMusicInfoSection(context, controller),
                        const SizedBox(height: 16),
                        _buildWaveSection(controller),
                        const SizedBox(height: 16),
                        _buildTimerSection(context, controller),
                        const SizedBox(height: 16),
                        _buildControlsSection(context, controller),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimationSection(
      BuildContext context, MeditationController controller) {
    final selectedAnimation = controller.selectedAnimation.value;
    final isAnimating =
        controller.isPlaying.value && !controller.animationPaused.value;

    if (selectedAnimation != null) {
      return Lottie.asset(
        selectedAnimation.path,
        width: double.infinity,
        height: 300,
        fit: BoxFit.contain,
        animate: isAnimating,
      );
    } else {
      return Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.animation,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Animation Selected',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Select an animation from the Animations screen',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMusicInfoSection(
      BuildContext context, MeditationController controller) {
    final selectedMusic = controller.selectedMusic.value;

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
                selectedMusic?.name ?? 'No Music Selected',
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                selectedMusic?.description ??
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

  Widget _buildWaveSection(MeditationController controller) {
    final isAnimating =
        controller.isPlaying.value && !controller.animationPaused.value;
    return WaveVisualizer(
      progress: controller.progress.value,
      isPlaying: isAnimating,
    );
  }

  Widget _buildTimerSection(
      BuildContext context, MeditationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.formatDuration(controller.currentDuration.value),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          controller.formatDuration(controller.totalDuration.value),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildControlsSection(
      BuildContext context, MeditationController controller) {
    if (controller.isPlaying.value) {
      // Playing state - show pause and stop
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.pause_rounded,
            label: 'Pause',
            onTap: () {
              controller.pauseMeditation();
            },
          ),
          _buildControlButton(
            icon: Icons.stop_rounded,
            label: 'End',
            onTap: () {
              controller.stopMeditation();
            },
            isPrimary: false,
          ),
        ],
      );
    } else if (controller.currentDuration.value > 0 &&
        !controller.isCompleted.value) {
      // Paused state - show resume and stop
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.play_arrow_rounded,
            label: 'Resume',
            onTap: () {
              controller.resumeMeditation();
            },
          ),
          _buildControlButton(
            icon: Icons.stop_rounded,
            label: 'End',
            onTap: () {
              controller.stopMeditation();
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
            if (controller.selectedMusic.value != null) {
              controller.startMeditation();
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
