import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/utils/responsive_utils.dart';

class PremiumBanner extends GetView<PremiumController> {
  final String title;
  final String subtitle;

  const PremiumBanner({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Don't show banner if user is premium
      if (controller.isPremium) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: ResponsiveUtils.getAdaptiveEdgeInsets(context),
        padding: ResponsiveUtils.getAdaptiveEdgeInsets(context),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Get.toNamed('/premium'),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveUtils.getAdaptiveFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize:
                            ResponsiveUtils.getAdaptiveFontSize(context, 14),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// Compact premium banner for smaller spaces
class CompactPremiumBanner extends GetView<PremiumController> {
  final String message;

  const CompactPremiumBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Don't show banner if user is premium
      if (controller.isPremium) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getAdaptivePadding(context),
          vertical: ResponsiveUtils.getAdaptiveSpacing(context) * 0.5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getAdaptiveSpacing(context) * 0.75,
          vertical: ResponsiveUtils.getAdaptiveSpacing(context) * 0.5,
        ),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => Get.toNamed('/premium'),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getAdaptiveFontSize(context, 12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
