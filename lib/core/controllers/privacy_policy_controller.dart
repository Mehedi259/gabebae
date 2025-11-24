// lib/core/controllers/privacy_policy_controller.dart

import 'package:get/get.dart';
import '../../global/model/privacy_policy_model.dart';
import '../services/privacy_policy_service.dart';

class PrivacyPolicyController extends GetxController {
  var isLoading = false.obs;
  var privacyPolicyData = Rxn<PrivacyPolicyModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  /// Fetch Privacy Policy content from API
  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await PrivacyPolicyService.getPrivacyPolicy();

      if (data != null) {
        privacyPolicyData.value = data;
      } else {
        errorMessage.value = 'Failed to load Privacy Policy';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry fetching data
  void retry() {
    fetchPrivacyPolicy();
  }
}