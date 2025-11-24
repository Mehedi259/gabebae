// lib/core/controllers/about_us_controller.dart

import 'package:get/get.dart';
import '../../global/model/about_us_model.dart';
import '../services/about_us_service.dart';

class AboutUsController extends GetxController {
  var isLoading = false.obs;
  var aboutUsData = Rxn<AboutUsModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  /// Fetch About Us content from API
  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await AboutUsService.getAboutUs();

      if (data != null) {
        aboutUsData.value = data;
      } else {
        errorMessage.value = 'Failed to load About Us content';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry fetching data
  void retry() {
    fetchAboutUs();
  }
}