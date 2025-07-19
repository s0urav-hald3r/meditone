import 'package:get/get.dart';

class PremiumController extends GetxController {
  // Observable to track premium status
  final RxBool isPremium = false.obs;

  // Selected subscription plan
  final Rx<SubscriptionPlan?> selectedPlan = Rx<SubscriptionPlan?>(null);

  // List of available subscription plans
  final List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      id: 'weekly',
      name: 'Weekly',
      price: 4.99,
      period: 'week',
      savePercent: 0,
      trialDays: 1,
    ),
    SubscriptionPlan(
      id: 'monthly',
      name: 'Monthly',
      price: 19.99,
      period: 'month',
      savePercent: 0,
      trialDays: 3,
    ),
    SubscriptionPlan(
      id: 'yearly',
      name: 'Yearly',
      price: 49.99,
      period: 'year',
      savePercent: 79, // Saving compared to weekly plan
      trialDays: 0,
    ),
  ];

  // Premium features list
  final List<PremiumFeature> premiumFeatures = [
    PremiumFeature(
      title: 'Unlimited Meditations',
      description: 'Access to all meditation sessions without limitations',
      icon: 'meditation',
    ),
    PremiumFeature(
      title: 'Exclusive Animations',
      description: 'Unlock all premium visual experiences',
      icon: 'animation',
    ),
    PremiumFeature(
      title: 'Ad-Free Experience',
      description: 'Enjoy uninterrupted meditation sessions',
      icon: 'ad_free',
    ),
    PremiumFeature(
      title: 'Sleep Stories',
      description: 'Calming stories to help you fall asleep faster',
      icon: 'sleep',
    ),
    PremiumFeature(
      title: 'Offline Access',
      description: 'Download meditations for offline use',
      icon: 'offline',
    ),
  ];

  // Select a subscription plan
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
  }

  // Purchase the selected plan (mock implementation)
  Future<bool> purchaseSelectedPlan() async {
    // This would be replaced with actual in-app purchase implementation
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate network request
    isPremium.value = true;
    return true;
  }

  // Restore purchases (mock implementation)
  Future<bool> restorePurchases() async {
    // This would be replaced with actual restore purchase implementation
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate network request
    return false; // No purchases to restore in this mock
  }
}

// Model class for subscription plans
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String period;
  final int savePercent;
  final int trialDays;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.savePercent,
    required this.trialDays,
  });
}

// Model class for premium features
class PremiumFeature {
  final String title;
  final String description;
  final String icon;

  PremiumFeature({
    required this.title,
    required this.description,
    required this.icon,
  });
}
