import 'package:MenuSideKick/presentation/screens/subscription/widget/sucess_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/routes/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';
import '../../../core/controllers/subscription_controller.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final SubscriptionController _subscriptionController = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Obx(() {
        if (_subscriptionController.isLoading.value) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: _subscriptionController.isProcessingPurchase.value
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE27B4F),
            ),
          )
              : CustomButton(
            text: "Subscribe",
            onTap: _handleSubscribe,
          ),
        );
      }),

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

        if (_subscriptionController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _subscriptionController.errorMessage.value,
                  textAlign: TextAlign.center,
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
                "Subscribe to Unlock Premium Features",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 16),
              _buildSubscriptionOptions(),
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
        onPressed: () => context.go(RoutePath.home.addBasePath),
      ),
      title: Text(
        l10n.subscriptions,
        textAlign: TextAlign.center,
        style: const TextStyle(
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

  Widget _buildSubscriptionOptions() {
    return Obx(() {
      final plans = _subscriptionController.availablePlans;

      if (plans.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No subscription plans available'),
          ),
        );
      }

      return Column(
        children: plans.map((plan) {
          final isSelected = _subscriptionController.selectedPlanId.value == plan.name;
          // Determine title based on plan name or interval
          String title;
          if (plan.name == 'monthly' || plan.interval == 'month') {
            title = 'Monthly';
          } else if (plan.name == 'annual' || plan.name == 'yearly' || plan.interval == 'year') {
            title = 'Yearly';
          } else {
            title = plan.name.capitalize ?? plan.name;
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSubscriptionOption(
              title: title,
              price: plan.displayPrice,
              planId: plan.name,
              isSelected: isSelected,
              onTap: () => _subscriptionController.selectPlan(plan.name),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSubscriptionOption({
    required String title,
    required String price,
    required String planId,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 336,
            height: 120,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0x1AD97D54) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFD97D54) : const Color(0x8888A096),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title + Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF444444),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFFD97D54)
                            : const Color(0xFF88A096),
                      ),
                    ),
                  ],
                ),

                // Custom Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFD97D54) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD97D54)
                          : const Color(0xFF88A096),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe() async {
    final success = await _subscriptionController.startPurchase();

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessPopup(
          onContinue: () {
            Navigator.pop(context);
            context.go(RoutePath.home.addBasePath);
          },
        ),
      );
    } else {
      // Only show error if it's not a cancellation
      final errorMsg = _subscriptionController.errorMessage.value;
      if (errorMsg.isNotEmpty && !errorMsg.toLowerCase().contains('cancel')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}