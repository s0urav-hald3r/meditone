import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends StatelessWidget {
  PremiumScreen({super.key});

  final PremiumController premiumController = Get.put(PremiumController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Meditone Premium'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium header
              _buildPremiumHeader(context),

              const SizedBox(height: 24),

              // Subscription plans
              _buildSubscriptionPlans(context),

              const SizedBox(height: 32),

              // Premium features
              _buildPremiumFeatures(context),

              const SizedBox(height: 32),

              // Purchase button
              _buildPurchaseButton(context),

              const SizedBox(height: 16),

              // Legal links
              _buildLegalLinks(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Upgrade to Premium',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock all features and enhance your meditation experience',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: premiumController.subscriptionPlans.map((plan) {
                final isSelected =
                    premiumController.selectedPlan.value?.id == plan.id;
                return _buildSubscriptionPlanCard(context, plan, isSelected);
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildSubscriptionPlanCard(
      BuildContext context, SubscriptionPlan plan, bool isSelected) {
    return GestureDetector(
      onTap: () => premiumController.selectPlan(plan),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textTertiaryColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '\$${plan.price}/${plan.period}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (plan.savePercent > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'SAVE ${plan.savePercent}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...premiumController.premiumFeatures.map((feature) {
          return _buildFeatureItem(context, feature);
        }).toList(),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, PremiumFeature feature) {
    IconData iconData;

    // Map feature icon string to IconData
    switch (feature.icon) {
      case 'meditation':
        iconData = Icons.self_improvement;
        break;
      case 'animation':
        iconData = Icons.animation;
        break;
      case 'ad_free':
        iconData = Icons.block;
        break;
      case 'sleep':
        iconData = Icons.nightlight_round;
        break;
      case 'offline':
        iconData = Icons.download_done;
        break;
      default:
        iconData = Icons.star;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimaryColor,
                      ),
                ),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    return Obx(() {
      final selectedPlan = premiumController.selectedPlan.value;
      final isLoading = false.obs; // For loading state

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: selectedPlan == null
              ? null
              : () async {
                  isLoading.value = true;
                  final success =
                      await premiumController.purchaseSelectedPlan();
                  isLoading.value = false;

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'You are now a premium user!',
                      backgroundColor: AppTheme.successColor,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Purchase failed. Please try again.',
                      backgroundColor: AppTheme.errorColor,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppTheme.textTertiaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Obx(() => isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  selectedPlan == null
                      ? 'Select a Plan'
                      : 'Subscribe for \$${selectedPlan.price}/${selectedPlan.period}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
        ),
      );
    });
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextButton(
              context,
              'Restore Purchase',
              () async {
                final restored = await premiumController.restorePurchases();
                if (restored) {
                  Get.snackbar(
                    'Success',
                    'Your purchases have been restored',
                    backgroundColor: AppTheme.successColor,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    'Info',
                    'No purchases found to restore',
                    backgroundColor: AppTheme.primaryColor,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextButton(
              context,
              'Privacy Policy',
              () => _launchURL('https://example.com/privacy-policy'),
            ),
            const Text(
              ' • ',
              style: TextStyle(color: AppTheme.textTertiaryColor),
            ),
            _buildTextButton(
              context,
              'Terms of Use',
              () => _launchURL('https://example.com/terms-of-use'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.textSecondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }
}
