// lib/core/controllers/terms_condition_controller.dart

import 'package:get/get.dart';
import '../../global/model/terms_condition_model.dart';
import '../services/terms_condition_service.dart';

class TermsConditionController extends GetxController {
  var isLoading = false.obs;
  var termsConditionData = Rxn<TermsConditionModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsCondition();
  }

  /// Fetch Terms & Conditions content from API
  Future<void> fetchTermsCondition() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await TermsConditionService.getTermsCondition();

      if (data != null) {
        termsConditionData.value = data;
      } else {
        errorMessage.value = 'Failed to load Terms & Conditions';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry fetching data
  void retry() {
    fetchTermsCondition();
  }
}