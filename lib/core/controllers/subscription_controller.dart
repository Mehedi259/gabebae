// lib/core/controllers/subscription_controller.dart

import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../services/subscription_service.dart';
import '../../global/model/subscription_model.dart';

class SubscriptionController extends GetxController {
  // Observable variables
  final RxList<SubscriptionPlan> availablePlans = <SubscriptionPlan>[].obs;
  final Rx<SubscriptionStatus?> currentStatus = Rx<SubscriptionStatus?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPurchase = false.obs;
  final RxString selectedPlanId = 'annual'.obs;
  final RxString errorMessage = ''.obs;

  // In-App Purchase instance
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final RxList<ProductDetails> _products = <ProductDetails>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeIAP();
    loadSubscriptionData();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Initialize In-App Purchase
  Future<void> _initializeIAP() async {
    try {
      // Check if IAP is available
      final bool available = await _iap.isAvailable();
      if (!available) {
        developer.log('❌ IAP not available on this device', name: 'SubscriptionController');
        errorMessage.value = 'In-app purchases not available';
        return;
      }

      // Platform-specific setup - enablePendingPurchases is now automatic
      // No need to call it explicitly as it's deprecated

      // Listen to purchase updates
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          developer.log('❌ Purchase stream error: $error', name: 'SubscriptionController');
        },
      );

      developer.log('✅ IAP initialized successfully', name: 'SubscriptionController');
    } catch (e) {
      developer.log('❌ Error initializing IAP: $e', name: 'SubscriptionController');
      errorMessage.value = 'Failed to initialize purchases';
    }
  }

  /// Load all subscription data
  Future<void> loadSubscriptionData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load plans and status in parallel
      await Future.wait([
        _loadPlans(),
        _loadStatus(),
      ]);

      // Load products from store
      await _loadProducts();
    } catch (e) {
      developer.log('❌ Error loading subscription data: $e', name: 'SubscriptionController');
      errorMessage.value = 'Failed to load subscription data';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load available subscription plans from API
  Future<void> _loadPlans() async {
    try {
      final plans = await SubscriptionService.getSubscriptionPlans();
      availablePlans.value = plans;

      // Set default selected plan to yearly if available
      if (plans.any((p) => p.name == 'annual')) {
        selectedPlanId.value = 'annual';
      } else if (plans.isNotEmpty) {
        selectedPlanId.value = plans.first.name;
      }
    } catch (e) {
      developer.log('❌ Error loading plans: $e', name: 'SubscriptionController');
      rethrow;
    }
  }

  /// Load current subscription status from API
  Future<void> _loadStatus() async {
    try {
      final status = await SubscriptionService.checkSubscriptionStatus();
      currentStatus.value = status;
    } catch (e) {
      developer.log('❌ Error loading status: $e', name: 'SubscriptionController');
      rethrow;
    }
  }

  /// Load products from App Store/Play Store
  Future<void> _loadProducts() async {
    try {
      if (availablePlans.isEmpty) return;

      final Set<String> productIds = availablePlans
          .map((plan) {
            String productId = Platform.isIOS ? plan.appleProductId : plan.googleProductId;
            // Fix: Replace hyphen with underscore for Android product IDs
            if (Platform.isAndroid) {
              productId = productId.replaceAll('-', '_');
            }
            return productId;
          })
          .where((id) => id.isNotEmpty) // Filter out empty product IDs
          .toSet();

      if (productIds.isEmpty) {
        developer.log('⚠️ No valid product IDs found', name: 'SubscriptionController');
        return;
      }

      developer.log('📦 Loading products: $productIds', name: 'SubscriptionController');

      final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        developer.log('⚠️ Products not found: ${response.notFoundIDs}', name: 'SubscriptionController');
      }

      if (response.error != null) {
        developer.log('❌ Error loading products: ${response.error}', name: 'SubscriptionController');
        return;
      }

      _products.value = response.productDetails;
      developer.log('✅ Loaded ${_products.length} products', name: 'SubscriptionController');
    } catch (e) {
      developer.log('❌ Error loading products: $e', name: 'SubscriptionController');
    }
  }

  /// Get selected plan
  SubscriptionPlan? get selectedPlan {
    return availablePlans.firstWhereOrNull(
          (plan) => plan.name == selectedPlanId.value,
    );
  }

  /// Check if user has active subscription
  bool get hasActiveSubscription {
    return currentStatus.value?.active ?? false;
  }

  /// Check if user needs subscription
  bool get needsSubscription {
    return currentStatus.value?.needSubscription ?? true;
  }

  /// Select a plan
  void selectPlan(String planName) {
    selectedPlanId.value = planName;
  }

  /// Start purchase flow
  Future<bool> startPurchase() async {
    try {
      isProcessingPurchase.value = true;
      errorMessage.value = '';

      final plan = selectedPlan;
      if (plan == null) {
        throw Exception('No plan selected');
      }

      developer.log('🛒 Starting purchase for: ${plan.name}', name: 'SubscriptionController');

      // Get the product ID based on platform
      String productId = Platform.isIOS ? plan.appleProductId : plan.googleProductId;
      
      // Fix: Replace hyphen with underscore for Android product IDs
      if (Platform.isAndroid) {
        productId = productId.replaceAll('-', '_');
      }

      // Find the product details
      final product = _products.firstWhereOrNull(
            (p) => p.id == productId,
      );

      if (product == null) {
        throw Exception('Product not found: $productId');
      }

      // Create purchase param
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Initiate purchase
      bool purchaseInitiated;
      if (Platform.isAndroid) {
        purchaseInitiated = await _iap.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        purchaseInitiated = await _iap.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      }

      if (!purchaseInitiated) {
        throw Exception('Failed to initiate purchase');
      }

      developer.log('✅ Purchase initiated', name: 'SubscriptionController');
      return true; // Will be completed in _handlePurchaseUpdates
    } catch (e) {
      developer.log('❌ Purchase error: $e', name: 'SubscriptionController');
      errorMessage.value = _handlePurchaseError(e);
      isProcessingPurchase.value = false;
      return false;
    }
  }

  /// Handle purchase updates from stream
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      developer.log('📱 Purchase update: ${purchaseDetails.status}', name: 'SubscriptionController');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        isProcessingPurchase.value = true;
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Verify purchase with backend
        final validated = await _verifyPurchase(purchaseDetails);

        if (validated) {
          // Complete the purchase
          await _completePurchase(purchaseDetails);

          // Reload subscription status
          await _loadStatus();

          developer.log('✅ Purchase completed successfully', name: 'SubscriptionController');
        }

        isProcessingPurchase.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        developer.log('❌ Purchase error: ${purchaseDetails.error}', name: 'SubscriptionController');
        errorMessage.value = purchaseDetails.error?.message ?? 'Purchase failed';
        isProcessingPurchase.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        developer.log('ℹ️ Purchase canceled', name: 'SubscriptionController');
        errorMessage.value = 'Purchase canceled';
        isProcessingPurchase.value = false;
      }

      // Always complete purchase on platform side
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Verify purchase with backend
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final platform = SubscriptionService.getPlatform();

      // Get purchase token
      String purchaseToken = '';
      String transactionId = '';

      if (Platform.isAndroid) {
        final androidDetails = purchaseDetails as GooglePlayPurchaseDetails;
        purchaseToken = androidDetails.billingClientPurchase.purchaseToken;
        transactionId = androidDetails.billingClientPurchase.orderId;
      } else if (Platform.isIOS) {
        final iosDetails = purchaseDetails as AppStorePurchaseDetails;
        purchaseToken = iosDetails.verificationData.serverVerificationData;
        transactionId = iosDetails.purchaseID ?? '';
      }

      // Use the actual product ID from the purchase (which has underscore)
      // Backend should accept both formats or we need to convert back
      String productId = purchaseDetails.productID;
      // Convert underscore back to hyphen for backend if needed
      if (Platform.isAndroid) {
        productId = productId.replaceAll('_', '-');
      }

      final response = await SubscriptionService.validatePurchase(
        platform: platform,
        productId: productId,
        purchaseToken: purchaseToken,
        transactionId: transactionId,
      );

      return response.success;
    } catch (e) {
      developer.log('❌ Validation error: $e', name: 'SubscriptionController');
      return false;
    }
  }

  /// Complete purchase
  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _iap.completePurchase(purchaseDetails);
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      isProcessingPurchase.value = true;
      errorMessage.value = '';

      developer.log('🔄 Restoring purchases...', name: 'SubscriptionController');

      await _iap.restorePurchases();

      // Wait a bit for the stream to process
      await Future.delayed(const Duration(seconds: 2));

      // Reload status
      await _loadStatus();

      return hasActiveSubscription;
    } catch (e) {
      developer.log('❌ Restore error: $e', name: 'SubscriptionController');
      errorMessage.value = 'Failed to restore purchases';
      return false;
    } finally {
      isProcessingPurchase.value = false;
    }
  }

  /// Handle purchase errors
  String _handlePurchaseError(dynamic error) {
    if (error is IAPError) {
      switch (error.code) {
        case 'purchase_cancelled':
          return 'Purchase cancelled';
        case 'item_already_owned':
          return 'You already own this subscription';
        case 'network_error':
          return 'Network error. Please check your connection';
        default:
          return error.message;
      }
    }
    return error.toString();
  }

  /// Get monthly plan
  SubscriptionPlan? get monthlyPlan {
    return availablePlans.firstWhereOrNull(
          (plan) => plan.name == 'monthly',
    );
  }

  /// Get yearly plan
  SubscriptionPlan? get yearlyPlan {
    return availablePlans.firstWhereOrNull(
          (plan) => plan.name == 'annual',
    );
  }

  /// Calculate savings
  String get yearlySavings {
    final monthly = monthlyPlan;
    final yearly = yearlyPlan;

    if (monthly != null && yearly != null) {
      return SubscriptionService.calculateYearlySavings(monthly, yearly);
    }
    return '';
  }

  /// Format renewal date
  String get renewalDateFormatted {
    final date = currentStatus.value?.renewalDate;
    if (date == null) return '';

    return '${date.day}/${date.month}/${date.year}';
  }
}