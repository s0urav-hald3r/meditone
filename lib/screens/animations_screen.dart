import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/models/animation_model.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:blur/blur.dart';

class AnimationsScreen extends StatelessWidget {
  final AnimationsController animationController =
      Get.find<AnimationsController>();
  final MeditationController meditationController =
      Get.find<MeditationController>();

  AnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GetBuilder<MeditationController>(
          builder: (controller) {
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: animationController.animations.length,
              itemBuilder: (context, index) {
                final animation = animationController.animations[index];
                final isSelected =
                    controller.selectedAnimation.value?.id == animation.id;
                final isPremium =
                    index > 0; // First animation is free, rest are premium

                return _buildAnimationCard(
                  animation: animation,
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

  Widget _buildAnimationCard({
    required AnimationModel animation,
    required bool isSelected,
    required BuildContext context,
    required bool isPremium,
  }) {
    return InkWell(
      onTap: () {
        // The premium check is now handled in the meditation controller
        meditationController.setAnimation(animation);
      },
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      color: AppTheme.cardColor,
                      width: double.infinity,
                      child: Lottie.asset(
                        animation.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              animation.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.textPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        animation.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Premium overlay with blur effect
          if (isPremium)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GestureDetector(
                  onTap: () {
                    // The premium check is now handled in the meditation controller
                    meditationController.setAnimation(animation);
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
      ),
    );
  }
}
