# RevenueCat Integration Setup Guide

This guide will help you set up RevenueCat for in-app purchases in your Meditone app.

## Prerequisites

1. RevenueCat account (sign up at [revenuecat.com](https://revenuecat.com))
2. Apple Developer account (for iOS)
3. Google Play Console account (for Android)

## Step 1: RevenueCat Dashboard Setup

### 1.1 Create a New Project

1. Log in to your RevenueCat dashboard
2. Create a new project for your Meditone app
3. Note down your API keys for both platforms

### 1.2 Configure Products

Create the following products in RevenueCat:

#### iOS Products (App Store Connect)

- `meditone_weekly_premium` - Weekly subscription
- `meditone_monthly_premium` - Monthly subscription
- `meditone_yearly_premium` - Yearly subscription

#### Android Products (Google Play Console)

- `meditone_weekly_premium` - Weekly subscription
- `meditone_monthly_premium` - Monthly subscription
- `meditone_yearly_premium` - Yearly subscription

### 1.3 Create Entitlement

1. Create an entitlement called `premium_access`
2. Attach all your subscription products to this entitlement

## Step 2: Update API Keys

Update the API keys in `lib/utils/app_constant.dart`:

```dart
class RevenueCatConfig {
  // Replace with your actual RevenueCat API keys
  static const String appleApiKey = 'appl_YOUR_APPLE_API_KEY';
  static const String googleApiKey = 'goog_YOUR_GOOGLE_API_KEY';

  // Product identifiers
  static const String weeklyPlanIdentifier = 'meditone_weekly_premium';
  static const String monthlyPlanIdentifier = 'meditone_monthly_premium';
  static const String yearlyPlanIdentifier = 'meditone_yearly_premium';

  // Entitlement identifier
  static const String entitlementID = 'premium_access';

  // User defaults keys
  static const String isPremiumUser = 'isPremiumUser';
}
```

## Step 3: Platform-Specific Setup

### iOS Setup

1. **App Store Connect**

   - Create your subscription products in App Store Connect
   - Set up pricing and availability
   - Configure subscription groups

2. **Xcode Configuration**
   - Ensure your app has the correct bundle identifier
   - Add the necessary capabilities for in-app purchases

### Android Setup

1. **Google Play Console**

   - Create your subscription products in Google Play Console
   - Set up pricing and availability
   - Configure subscription offers

2. **Android Manifest**
   - Ensure your app has the correct package name
   - Add billing permissions if needed

## Step 4: Testing

### Sandbox Testing

1. Use RevenueCat's sandbox environment for testing
2. Create test users in App Store Connect/Google Play Console
3. Test the purchase flow with sandbox accounts

### Test Scenarios

- [ ] Purchase a subscription
- [ ] Restore purchases
- [ ] Check premium status
- [ ] Verify premium features are unlocked
- [ ] Test subscription expiration

## Step 5: Production Deployment

1. **App Store**

   - Submit your app for review
   - Ensure all subscription products are approved
   - Test with real users

2. **Google Play**
   - Submit your app for review
   - Ensure all subscription products are approved
   - Test with real users

## Features Implemented

### Premium Features

- ✅ Unlimited animations (all except first)
- ✅ Unlimited music tracks (all except first)
- ✅ Ad-free experience
- ✅ Premium banners that disappear after subscription

### Purchase Flow

- ✅ RevenueCat integration
- ✅ Product fetching from stores
- ✅ Purchase processing
- ✅ Purchase restoration
- ✅ Premium status checking
- ✅ Local storage for premium status

### UI Components

- ✅ Premium banners on all screens
- ✅ Premium screen with product selection
- ✅ Loading states during purchase
- ✅ Success/error notifications

## Troubleshooting

### Common Issues

1. **Products not loading**

   - Check API keys are correct
   - Verify products exist in store consoles
   - Check network connectivity

2. **Purchase fails**

   - Ensure test accounts are properly configured
   - Check sandbox environment is active
   - Verify product IDs match exactly

3. **Premium status not updating**
   - Check entitlement configuration in RevenueCat
   - Verify local storage is working
   - Check subscription status in RevenueCat dashboard

### Debug Logs

Enable debug logging by checking the console output. The app will log:

- Product fetching status
- Purchase attempts and results
- Premium status changes
- Error messages

## Support

For RevenueCat-specific issues:

- [RevenueCat Documentation](https://docs.revenuecat.com/)
- [RevenueCat Support](https://www.revenuecat.com/support/)

For app-specific issues:

- Check the console logs for detailed error messages
- Verify all configuration steps have been completed
- Test with sandbox accounts before production
