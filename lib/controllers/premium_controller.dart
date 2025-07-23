import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:meditone/utils/app_constant.dart';
import 'package:meditone/utils/local_storage.dart';

class PremiumController extends GetxController {
  // Observable to track premium status
  final RxBool _isPremium = false.obs;
  bool get isPremium => _isPremium.value;
  set isPremium(bool value) => _isPremium.value = value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  // Selected subscription plan
  final Rx<StoreProduct?> _selectedProduct = Rx<StoreProduct?>(null);
  StoreProduct? get selectedProduct => _selectedProduct.value;
  set selectedProduct(StoreProduct? value) => _selectedProduct.value = value;

  final RxList<StoreProduct> _availableProducts = <StoreProduct>[].obs;
  List<StoreProduct> get availableProducts => _availableProducts;
  set availableProducts(List<StoreProduct> value) {
    _availableProducts.value = value;
  }

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

  @override
  void onInit() {
    super.onInit();
    _initializePremiumStatus();
    _fetchProducts();
  }

  // Initialize premium status from local storage
  void _initializePremiumStatus() {
    isPremium = LocalStorage.getPremiumStatus();
  }

  // Fetch available products from RevenueCat
  Future<void> _fetchProducts() async {
    try {
      isLoading = true;

      final List<String> productIds = [
        RevenueCatConfig.weeklyPlanIdentifier,
        RevenueCatConfig.monthlyPlanIdentifier,
        RevenueCatConfig.yearlyPlanIdentifier,
      ];

      final products = await Purchases.getProducts(productIds);

      availableProducts = products;

      // Set first product as default selection
      if (products.isNotEmpty) {
        selectedProduct = products.first;
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      isLoading = false;
    }
  }

  // Select a product
  void selectProduct(StoreProduct product) {
    selectedProduct = product;
  }

  // Purchase the selected product
  Future<void> purchaseSelectedProduct() async {
    try {
      isLoading = true;

      final customerInfo =
          await Purchases.purchaseStoreProduct(selectedProduct!);

      // Check if purchase was successful
      if (customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.entitlementID)) {
        isPremium = true;
        await LocalStorage.setPremiumStatus(true);

        Get.snackbar(
          'Success',
          'Welcome to Premium! Enjoy all features.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offNamedUntil('/', (route) => false);
      } else {
        Get.snackbar(
          'Error',
          'Purchase completed but premium access not granted.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on PlatformException catch (e) {
      if (e.code == PurchasesErrorCode.purchaseCancelledError.toString()) {
        Get.snackbar(
          'Cancelled',
          'Purchase was cancelled.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Purchase failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading = false;
    }
  }

  // Restore purchases
  Future<void> restorePurchases() async {
    try {
      isLoading = true;

      final customerInfo = await Purchases.restorePurchases();

      if (customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.entitlementID)) {
        isPremium = true;
        await LocalStorage.setPremiumStatus(true);

        Get.snackbar(
          'Success',
          'Your purchases have been restored!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offNamedUntil('/', (route) => false);
      } else {
        Get.snackbar(
          'Info',
          'No active purchases found to restore.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to restore purchases. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
    }
  }

  // Check current subscription status
  Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.entitlementID)) {
        isPremium = true;
        await LocalStorage.setPremiumStatus(true);
      } else {
        isPremium = false;
        await LocalStorage.setPremiumStatus(false);
      }
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }

  // Get formatted price for display
  String getFormattedPrice(StoreProduct product) {
    return product.priceString;
  }

  // Get trial period info
  String? getTrialInfo(StoreProduct product) {
    if (product.introductoryPrice != null) {
      final intro = product.introductoryPrice!;
      return '${intro.periodNumberOfUnits} ${intro.periodUnit.name} free trial';
    }
    return null;
  }
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
