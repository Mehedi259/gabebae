//lib/presentation/screens/ProfileAndSettings/current_plan.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/routes/routes.dart';
import '../../../global/model/subscription_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/controllers/subscription_controller.dart';


class CurrentSubscriptionScreen extends StatefulWidget {
  const CurrentSubscriptionScreen({super.key});

  @override
  State<CurrentSubscriptionScreen> createState() => _CurrentSubscriptionScreenState();
}

class _CurrentSubscriptionScreenState extends State<CurrentSubscriptionScreen> {
  final SubscriptionController _subscriptionController = Get.put(SubscriptionController());

  @override
  void initState() {
    super.initState();
    // Reload subscription data when screen opens
    _subscriptionController.loadSubscriptionData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(context),
      ),
      body: Obx(() {
        if (_subscriptionController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE27B4F)),
          );
        }

        final status = _subscriptionController.currentStatus.value;

        if (status == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No subscription data available',
                  style: GoogleFonts.quicksand(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _subscriptionController.loadSubscriptionData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Your Current Subscription",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 24),
              _buildCurrentPlanCard(status),
              const SizedBox(height: 24),
              _buildSubscriptionDetails(status),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      leading: IconButton(
        icon: Assets.icons.back.svg(width: 16, height: 18),
        onPressed: () => context.go(RoutePath.myProfile.addBasePath),
      ),
      title: const Text(
        "Current Subscription",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildCurrentPlanCard(SubscriptionStatus status) {
    // Format plan name
    String planName = status.plan ?? 'Unknown';
    if (planName.contains('monthly')) {
      planName = 'Monthly';
    } else if (planName.contains('annual') || planName.contains('yearly')) {
      planName = 'Yearly';
    }

    // Get price from available plans
    String displayPrice = '\$0.00/month';
    final plan = _subscriptionController.availablePlans.firstWhereOrNull(
          (p) => p.name == status.plan?.replaceAll('_subscription', ''),
    );
    if (plan != null) {
      displayPrice = plan.displayPrice;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x1AD97D54),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD97D54),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x23000000),
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Active Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: status.active
                  ? const Color(0xFFD97D54)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.active ? "ACTIVE" : "INACTIVE",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Plan Name
          Text(
            "$planName Plan",
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),

          // Plan Price
          Text(
            displayPrice,
            style: GoogleFonts.quicksand(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD97D54),
            ),
          ),
          const SizedBox(height: 8),

          // Billing Info
          Text(
            planName.toLowerCase().contains('year')
                ? "Billed annually"
                : "Billed monthly",
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails(SubscriptionStatus status) {
    // Format plan name
    String planName = status.plan ?? 'Unknown';
    if (planName.contains('monthly')) {
      planName = 'Monthly';
    } else if (planName.contains('annual') || planName.contains('yearly')) {
      planName = 'Yearly';
    }

    // Get price
    String displayPrice = '\$0.00';
    final plan = _subscriptionController.availablePlans.firstWhereOrNull(
          (p) => p.name == status.plan?.replaceAll('_subscription', ''),
    );
    if (plan != null) {
      displayPrice = plan.displayPrice;
    }

    // Format renewal date
    String renewalDate = 'N/A';
    if (status.renewalDate != null) {
      final date = status.renewalDate!;
      renewalDate = '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscription Details",
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),

          _buildDetailRow(
            "Plan Type",
            planName,
          ),
          const Divider(height: 32, color: Color(0xFFE5E7EB)),

          _buildDetailRow(
            "Status",
            status.active ? "Active" : "Inactive",
            valueColor: status.active
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
          ),
          const Divider(height: 32, color: Color(0xFFE5E7EB)),

          _buildDetailRow(
            "Next Billing Date",
            renewalDate,
          ),
          const Divider(height: 32, color: Color(0xFFE5E7EB)),

          _buildDetailRow(
            "Amount",
            displayPrice,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}