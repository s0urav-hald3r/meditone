import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/utils/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends GetView<PremiumController> {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Meditone Premium'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium header
                    _buildPremiumHeader(context),

                    const SizedBox(height: 24),

                    // Subscription plans
                    _buildSubscriptionPlans(context),

                    const SizedBox(height: 24),

                    // Premium features
                    _buildPremiumFeatures(context),
                  ]),
            ),
          ),
        ),

        // Floating elements at the bottom
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Purchase button
              _buildPurchaseButton(context),

              const SizedBox(height: 8),

              // Legal links
              _buildLegalLinks(context),
            ],
          ),
        ),
      ]),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Choose Your Plan',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 16),
      Obx(() {
        if (controller.availableProducts.isEmpty) {
          return const Center(
            child: Text('No products available'),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Obx(() {
              final product = controller.availableProducts[index];
              final isSelected =
                  controller.selectedProduct?.identifier == product.identifier;
              return _buildSubscriptionPlanCard(context, product, isSelected);
            });
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: controller.availableProducts.length,
        );
      }),
    ]);
  }

  Widget _buildSubscriptionPlanCard(
      BuildContext context, StoreProduct product, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.selectProduct(product);
      },
      child: Container(
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
        child: Row(children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
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
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  product.priceString,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (product.introductoryPrice != null)
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '${product.introductoryPrice!.periodNumberOfUnits} DAY${product.introductoryPrice!.periodNumberOfUnits == 1 ? '' : 'S'} TRIAL',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildPremiumFeatures(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Premium Features',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 16),
      ...controller.premiumFeatures
          .map((feature) => _buildFeatureItem(context, feature)),
    ]);
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
      child: Row(children: [
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          ]),
        ),
      ]),
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    return Obx(() {
      final selectedProduct = controller.selectedProduct;
      final isLoading = controller.isLoading;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  await controller.purchaseSelectedProduct();
                  // Navigation is handled in the controller
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
          child: isLoading
              ? const Text(
                  'Purchasing...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  selectedProduct?.introductoryPrice != null
                      ? 'Start ${selectedProduct?.introductoryPrice!.periodNumberOfUnits} day${selectedProduct?.introductoryPrice!.periodNumberOfUnits == 1 ? '' : 's'} free trial'
                      : 'Subscribe for ${selectedProduct?.priceString}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTextButton(
        context,
        'Restore Purchase',
        () async {
          await controller.restorePurchases();
        },
      ),
      const Text(
        ' • ',
        style: TextStyle(color: AppTheme.textTertiaryColor),
      ),
      _buildTextButton(
        context,
        'Privacy Policy',
        () => _launchURL(RevenueCatConfig.privacyPolicyUrl),
      ),
      const Text(
        ' • ',
        style: TextStyle(color: AppTheme.textTertiaryColor),
      ),
      _buildTextButton(
        context,
        'Terms of Use',
        () => _launchURL(RevenueCatConfig.termsOfUseUrl),
      ),
    ]);
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
      // Handle error silently
    }
  }
}
