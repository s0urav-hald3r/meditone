import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/controllers/music_controller.dart';
import 'package:meditone/models/music_model.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:blur/blur.dart';

class MusicScreen extends StatelessWidget {
  final MusicController musicController = Get.find<MusicController>();
  final MeditationController meditationController =
      Get.find<MeditationController>();

  MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GetBuilder<MeditationController>(
          builder: (controller) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: musicController.musicTracks.length,
              itemBuilder: (context, index) {
                final music = musicController.musicTracks[index];
                final isSelected =
                    controller.selectedMusic.value?.id == music.id;
                final isPremium =
                    index > 0; // First music is free, rest are premium

                return _buildMusicCard(
                  music: music,
                  isSelected: isSelected,
                  context: context,
                  isPremium: isPremium,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMusicCard({
    required MusicModel music,
    required bool isSelected,
    required BuildContext context,
    required bool isPremium,
  }) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              // The premium check is now handled in the meditation controller
              meditationController.setMusic(music);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          music.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppTheme.textTertiaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              music.duration,
                              style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                color: AppTheme.textTertiaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        // Premium overlay with blur effect
        if (isPremium)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 16, // Match the bottom margin
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: () {
                  // The premium check is now handled in the meditation controller
                  meditationController.setMusic(music);
                },
                child: Stack(
                  children: [
                    Blur(
                      blur: 3.5,
                      blurColor: Colors.black.withOpacity(0.1),
                      child: Container(color: Colors.transparent),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
