import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditone/screens/premium_screen.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:meditone/controllers/premium_controller.dart';

class SettingsScreen extends StatelessWidget {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'Buy Premium',
              subtitle: 'Unlock all features and remove ads',
              icon: Icons.workspace_premium,
              iconColor: Colors.amber,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PremiumScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Legal',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                _launchURL('https://example.com/privacy-policy');
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              title: 'Terms of Use',
              subtitle: 'Read our terms of use',
              icon: Icons.description_outlined,
              onTap: () {
                _launchURL('https://example.com/terms-of-use');
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Support Us',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'Rate the App',
              subtitle: 'If you enjoy using Meditone, please rate us!',
              icon: Icons.star_outline,
              iconColor: Colors.amber,
              onTap: () {
                // Open app store rating page
                _launchURL(
                    'https://play.google.com/store/apps/details?id=studio.meditone.app');
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              title: 'Share the App',
              subtitle: 'Share Meditone with friends and family',
              icon: Icons.share_outlined,
              onTap: () {
                _shareApp();
              },
            ),
            const SizedBox(height: 24),
            Text(
              'App Info',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'Version',
              subtitle: '1.0.0',
              icon: Icons.info_outline,
              onTap: null,
            ),
            const SizedBox(height: 24),
            Text(
              'Testing',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Obx(() {
              final premiumController = Get.find<PremiumController>();
              return _buildSettingsCard(
                context,
                title: 'Premium Status',
                subtitle: premiumController.isPremium.value
                    ? 'Premium User'
                    : 'Free User',
                icon: premiumController.isPremium.value
                    ? Icons.workspace_premium
                    : Icons.person,
                iconColor:
                    premiumController.isPremium.value ? Colors.amber : null,
                onTap: () {
                  premiumController.togglePremiumStatus();
                },
              );
            }),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              title: 'Test Premium Redirection',
              subtitle: 'Test the premium screen redirection',
              icon: Icons.navigation,
              onTap: () {
                final premiumController = Get.find<PremiumController>();
                premiumController.testPremiumRedirection();
              },
            ),
          ],
        ),
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
      'Check out Meditone, the best meditation app! https://example.com/meditone',
      subject: 'Try Meditone App',
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text('Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          '$feature will be available soon!',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }
}
