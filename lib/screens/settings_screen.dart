import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/utils/app_constant.dart';
import 'package:meditone/utils/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends GetView<PremiumController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getAdaptiveEdgeInsets(context),
        child: ResponsiveUtils.isTablet(context) ||
                ResponsiveUtils.isDesktop(context)
            ? _buildTabletSettingsLayout(context)
            : _buildMobileSettingsLayout(context),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppTheme.cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppTheme.surfaceGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppTheme.textPrimaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: onTap != null
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textTertiaryColor,
              )
            : null,
        onTap: onTap,
      ),
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

  void _shareApp() {
    Share.share(
      'Check out Meditone, the best meditation app! 🧘🏾\nhttps://apps.apple.com/app/id6748948216',
      subject: 'Try Meditone App',
    );
  }

  Widget _buildMobileSettingsLayout(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Obx(() {
        if (controller.isPremium) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
            _buildSettingsCard(
              context,
              title: 'Buy Premium',
              subtitle: 'Unlock all features and remove ads',
              icon: Icons.workspace_premium,
              iconColor: Colors.amber,
              onTap: () {
                Get.toNamed('/premium');
              },
            ),
            SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context) * 1.5),
          ],
        );
      }),
      Text(
        'Legal',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
      _buildSettingsCard(
        context,
        title: 'Privacy Policy',
        subtitle: 'Read our privacy policy',
        icon: Icons.privacy_tip_outlined,
        onTap: () {
          _launchURL(RevenueCatConfig.privacyPolicyUrl);
        },
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context) * 0.75),
      _buildSettingsCard(
        context,
        title: 'Terms of Use',
        subtitle: 'Read our terms of use',
        icon: Icons.description_outlined,
        onTap: () {
          _launchURL(RevenueCatConfig.termsOfUseUrl);
        },
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context) * 1.5),
      Text(
        'Support Us',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
      _buildSettingsCard(
        context,
        title: 'Rate the App',
        subtitle: 'If you enjoy using Meditone, please rate us!',
        icon: Icons.star_outline,
        iconColor: Colors.amber,
        onTap: () async {
          if (await InAppReview.instance.isAvailable()) {
            InAppReview.instance.requestReview();
          }
        },
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context) * 0.75),
      _buildSettingsCard(
        context,
        title: 'Share the App',
        subtitle: 'Share Meditone with friends and family',
        icon: Icons.share_outlined,
        onTap: () {
          _shareApp();
        },
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context) * 1.5),
      Text(
        'App Info',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
      FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          String version = 'Loading...';
          if (snapshot.hasData) {
            version =
                'v${snapshot.data!.version} (${snapshot.data!.buildNumber})';
          } else if (snapshot.hasError) {
            version = 'Unknown';
          }

          return _buildSettingsCard(
            context,
            title: 'Version',
            subtitle: version,
            icon: Icons.info_outline,
            onTap: null,
          );
        },
      ),
    ]);
  }

  Widget _buildTabletSettingsLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.isPremium) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(
                        height: ResponsiveUtils.getAdaptiveSpacing(context)),
                    _buildSettingsCard(
                      context,
                      title: 'Buy Premium',
                      subtitle: 'Unlock all features and remove ads',
                      icon: Icons.workspace_premium,
                      iconColor: Colors.amber,
                      onTap: () {
                        Get.toNamed('/premium');
                      },
                    ),
                    SizedBox(
                        height:
                            ResponsiveUtils.getAdaptiveSpacing(context) * 1.5),
                  ],
                );
              }),
              Text(
                'Legal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
              _buildSettingsCard(
                context,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  _launchURL(RevenueCatConfig.privacyPolicyUrl);
                },
              ),
              SizedBox(
                  height: ResponsiveUtils.getAdaptiveSpacing(context) * 0.75),
              _buildSettingsCard(
                context,
                title: 'Terms of Use',
                subtitle: 'Read our terms of use',
                icon: Icons.description_outlined,
                onTap: () {
                  _launchURL(RevenueCatConfig.termsOfUseUrl);
                },
              ),
            ],
          ),
        ),
        SizedBox(width: ResponsiveUtils.getAdaptiveSpacing(context)),
        // Right column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Us',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
              _buildSettingsCard(
                context,
                title: 'Rate the App',
                subtitle: 'If you enjoy using Meditone, please rate us!',
                icon: Icons.star_outline,
                iconColor: Colors.amber,
                onTap: () async {
                  if (await InAppReview.instance.isAvailable()) {
                    InAppReview.instance.requestReview();
                  }
                },
              ),
              SizedBox(
                  height: ResponsiveUtils.getAdaptiveSpacing(context) * 0.75),
              _buildSettingsCard(
                context,
                title: 'Share the App',
                subtitle: 'Share Meditone with friends and family',
                icon: Icons.share_outlined,
                onTap: () {
                  _shareApp();
                },
              ),
              SizedBox(
                  height: ResponsiveUtils.getAdaptiveSpacing(context) * 1.5),
              Text(
                'App Info',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context)),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  String version = 'Loading...';
                  if (snapshot.hasData) {
                    version =
                        'v${snapshot.data!.version} (${snapshot.data!.buildNumber})';
                  } else if (snapshot.hasError) {
                    version = 'Unknown';
                  }

                  return _buildSettingsCard(
                    context,
                    title: 'Version',
                    subtitle: version,
                    icon: Icons.info_outline,
                    onTap: null,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
