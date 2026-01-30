// lib/core/services/subscription_service.dart

import 'dart:developer' as developer;
import 'dart:io';
import '../constants/api_constants.dart';
import '../services/api_service.dart';
import '../../global/model/subscription_model.dart';

class SubscriptionService {
  /// Fetch available subscription plans
  static Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      developer.log('📡 Fetching subscription plans...', name: 'SubscriptionService');

      final response = await ApiService.getRequest(
        ApiConstants.subscriptionPlan,
      );

      if (response is List) {
        final plans = response
            .map((json) => SubscriptionPlan.fromJson(json))
            .toList();

        developer.log('✅ Fetched ${plans.length} subscription plans', name: 'SubscriptionService');
        return plans;
      }

      developer.log('⚠️ Unexpected response format', name: 'SubscriptionService');
      return [];
    } catch (e) {
      developer.log('❌ Error fetching subscription plans: $e', name: 'SubscriptionService');
      throw Exception('Failed to fetch subscription plans: $e');
    }
  }

  /// Check current subscription status
  static Future<SubscriptionStatus> checkSubscriptionStatus() async {
    try {
      developer.log('📡 Checking subscription status...', name: 'SubscriptionService');

      final response = await ApiService.getRequest(
        ApiConstants.checkSubscription,
      );

      final status = SubscriptionStatus.fromJson(response);
      developer.log('✅ Subscription status: ${status.status}', name: 'SubscriptionService');

      return status;
    } catch (e) {
      developer.log('❌ Error checking subscription status: $e', name: 'SubscriptionService');
      throw Exception('Failed to check subscription status: $e');
    }
  }

  /// Validate in-app purchase
  static Future<ValidateIAPResponse> validatePurchase({
    required String platform,
    required String productId,
    required String purchaseToken,
    required String transactionId,
  }) async {
    try {
      developer.log('📡 Validating purchase...', name: 'SubscriptionService');
      developer.log('Platform: $platform, Product: $productId', name: 'SubscriptionService');

      final request = ValidateIAPRequest(
        platform: platform,
        productId: productId,
        purchaseToken: purchaseToken,
        transactionId: transactionId,
      );

      final response = await ApiService.postRequest(
        ApiConstants.selectedSubscription,
        body: request.toJson(),
      );

      final validateResponse = ValidateIAPResponse.fromJson(response);

      if (validateResponse.success) {
        developer.log('✅ Purchase validated successfully', name: 'SubscriptionService');
      } else {
        developer.log('⚠️ Purchase validation failed', name: 'SubscriptionService');
      }

      return validateResponse;
    } catch (e) {
      developer.log('❌ Error validating purchase: $e', name: 'SubscriptionService');
      throw Exception('Failed to validate purchase: $e');
    }
  }

  /// Get platform identifier for current device
  static String getPlatform() {
    if (Platform.isAndroid) {
      return 'google';
    } else if (Platform.isIOS) {
      return 'apple';
    }
    return 'unknown';
  }

  /// Format price for display
  static String formatPrice(String price, String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${price}';
      case 'EUR':
        return '€${price}';
      case 'GBP':
        return '£${price}';
      default:
        return '${currency} ${price}';
    }
  }

  /// Calculate savings for yearly plan
  static String calculateYearlySavings(
      SubscriptionPlan monthlyPlan,
      SubscriptionPlan yearlyPlan,
      ) {
    try {
      final monthlyPrice = double.parse(monthlyPlan.price);
      final yearlyPrice = double.parse(yearlyPlan.price);
      final yearlyFromMonthly = monthlyPrice * 12;
      final savings = yearlyFromMonthly - yearlyPrice;

      if (savings > 0) {
        final percentage = (savings / yearlyFromMonthly * 100).round();
        return 'Save $percentage%';
      }
      return '';
    } catch (e) {
      developer.log('Error calculating savings: $e', name: 'SubscriptionService');
      return '';
    }
  }
}