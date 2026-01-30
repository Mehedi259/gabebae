// lib/global/model/subscription_model.dart

class SubscriptionPlan {
  final int id;
  final String name;
  final String price;
  final String currency;
  final String interval;
  final bool isActive;
  final String appleProductId;
  final String googleProductId;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.isActive,
    required this.appleProductId,
    required this.googleProductId,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '0.00',
      currency: json['currency'] ?? 'USD',
      interval: json['interval'] ?? 'month',
      isActive: json['is_active'] ?? false,
      appleProductId: json['apple_product_id'] ?? '',
      googleProductId: json['google_product_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'interval': interval,
      'is_active': isActive,
      'apple_product_id': appleProductId,
      'google_product_id': googleProductId,
    };
  }

  String get displayPrice => '\$${price}/${interval == 'year' ? 'year' : 'month'}';
}

class SubscriptionStatus {
  final bool active;
  final bool needSubscription;
  final String status;
  final String? plan;
  final DateTime? renewalDate;

  SubscriptionStatus({
    required this.active,
    required this.needSubscription,
    required this.status,
    this.plan,
    this.renewalDate,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      active: json['active'] ?? false,
      needSubscription: json['need_subscription'] ?? true,
      status: json['status'] ?? 'inactive',
      plan: json['plan'],
      renewalDate: json['renewal_date'] != null
          ? DateTime.parse(json['renewal_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'need_subscription': needSubscription,
      'status': status,
      'plan': plan,
      'renewal_date': renewalDate?.toIso8601String(),
    };
  }
}

class ValidateIAPRequest {
  final String platform;
  final String productId;
  final String purchaseToken;
  final String transactionId;

  ValidateIAPRequest({
    required this.platform,
    required this.productId,
    required this.purchaseToken,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'product_id': productId,
      'purchase_token': purchaseToken,
      'transaction_id': transactionId,
    };
  }
}

class ValidateIAPResponse {
  final bool success;
  final String platform;
  final String productId;
  final String purchaseToken;
  final String transactionId;
  final SubscriptionDetails? subscription;

  ValidateIAPResponse({
    required this.success,
    required this.platform,
    required this.productId,
    required this.purchaseToken,
    required this.transactionId,
    this.subscription,
  });

  factory ValidateIAPResponse.fromJson(Map<String, dynamic> json) {
    return ValidateIAPResponse(
      success: json['success'] ?? false,
      platform: json['platform'] ?? '',
      productId: json['product_id'] ?? '',
      purchaseToken: json['purchase_token'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      subscription: json['subscription'] != null
          ? SubscriptionDetails.fromJson(json['subscription'])
          : null,
    );
  }
}

class SubscriptionDetails {
  final String status;
  final String plan;
  final String price;
  final String currency;
  final String interval;
  final DateTime renewalDate;

  SubscriptionDetails({
    required this.status,
    required this.plan,
    required this.price,
    required this.currency,
    required this.interval,
    required this.renewalDate,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      status: json['status'] ?? '',
      plan: json['plan'] ?? '',
      price: json['price'] ?? '0.00',
      currency: json['currency'] ?? 'USD',
      interval: json['interval'] ?? 'month',
      renewalDate: json['renewal_date'] != null
          ? DateTime.parse(json['renewal_date'])
          : DateTime.now(),
    );
  }
}