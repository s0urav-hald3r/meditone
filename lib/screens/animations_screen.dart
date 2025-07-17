import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/meditation_controller.dart';
import 'package:meditone/models/animation_model.dart';
import 'package:meditone/themes/app_theme.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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

                return _buildAnimationCard(
                  animation: animation,
                  isSelected: isSelected,
                  context: context,
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
  }) {
    return InkWell(
      onTap: () {
        meditationController.setAnimation(animation);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }
}
