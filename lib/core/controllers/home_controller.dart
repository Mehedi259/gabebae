// lib/core/controllers/home_controller.dart
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../global/model/home_model.dart';
import '../services/home_service.dart';

class HomeController extends GetxController {
  // Loading states
  final RxBool isLoadingProfile = false.obs;
  final RxBool isLoadingFavorites = false.obs;
  final RxBool isLoadingScans = false.obs;

  // Data
  final Rx<ActiveProfileModel?> activeProfile = Rx<ActiveProfileModel?>(null);
  final RxList<EatingStyleIconModel> eatingStyleIcons = <EatingStyleIconModel>[].obs;
  final RxList<AllergyIconModel> allergyIcons = <AllergyIconModel>[].obs;
  final RxList<MedicalConditionIconModel> medicalConditionIcons = <MedicalConditionIconModel>[].obs;
  final RxList<MyPlateModel> myPlateFavorites = <MyPlateModel>[].obs;
  final RxList<ScannedDocumentModel> scannedDocuments = <ScannedDocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    developer.log('🚀 HomeController initialized', name: 'HomeController');
    loadHomeData();
  }

  @override
  void onReady() {
    super.onReady();
    developer.log('✅ HomeController ready', name: 'HomeController');
  }

  /// Load all home data
  Future<void> loadHomeData() async {
    developer.log('📥 Loading all home data...', name: 'HomeController');

    try {
      await Future.wait([
        loadActiveProfile(),
        loadMyPlateFavorites(),
        loadScannedDocuments(),
      ]);

      developer.log('✅ All home data loaded successfully', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading home data: $e', name: 'HomeController');
    }
  }

  /// Load Active Profile with Icons
  Future<void> loadActiveProfile() async {
    try {
      isLoadingProfile.value = true;
      developer.log('🔄 Loading active profile...', name: 'HomeController');

      // Fetch active profile
      final profile = await HomeService.getActiveProfile();

      if (profile != null) {
        activeProfile.value = profile;
        developer.log('✅ Active profile loaded: ${profile.profileName}', name: 'HomeController');

        // Fetch icons for eating styles, allergies, and medical conditions
        await Future.wait([
          loadEatingStyleIcons(),
          loadAllergyIcons(),
          loadMedicalConditionIcons(),
        ]);
      } else {
        developer.log('⚠️ No active profile found', name: 'HomeController');
        activeProfile.value = null;
      }
    } catch (e) {
      developer.log('❌ Error loading active profile: $e', name: 'HomeController');
      activeProfile.value = null;
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Load Eating Style Icons
  Future<void> loadEatingStyleIcons() async {
    try {
      final icons = await HomeService.getEatingStyleIcons();
      eatingStyleIcons.value = icons;
      developer.log('✅ Loaded ${icons.length} eating style icons', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading eating style icons: $e', name: 'HomeController');
      eatingStyleIcons.value = [];
    }
  }

  /// Load Allergy Icons
  Future<void> loadAllergyIcons() async {
    try {
      final icons = await HomeService.getAllergyIcons();
      allergyIcons.value = icons;
      developer.log('✅ Loaded ${icons.length} allergy icons', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading allergy icons: $e', name: 'HomeController');
      allergyIcons.value = [];
    }
  }

  /// Load Medical Condition Icons
  Future<void> loadMedicalConditionIcons() async {
    try {
      final icons = await HomeService.getMedicalConditionIcons();
      medicalConditionIcons.value = icons;
      developer.log('✅ Loaded ${icons.length} medical condition icons', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading medical condition icons: $e', name: 'HomeController');
      medicalConditionIcons.value = [];
    }
  }

  /// Load My Plate Favorites
  Future<void> loadMyPlateFavorites() async {
    try {
      isLoadingFavorites.value = true;
      developer.log('🔄 Loading my plate favorites...', name: 'HomeController');

      final favorites = await HomeService.getMyPlate();
      myPlateFavorites.value = favorites;
      developer.log('✅ Loaded ${favorites.length} favorites', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading favorites: $e', name: 'HomeController');
      myPlateFavorites.value = [];
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  /// Load Scanned Documents
  Future<void> loadScannedDocuments() async {
    try {
      isLoadingScans.value = true;
      developer.log('🔄 Loading scanned documents...', name: 'HomeController');

      final scans = await HomeService.getScannedDocuments();
      scannedDocuments.value = scans;
      developer.log('✅ Loaded ${scans.length} scanned documents', name: 'HomeController');
    } catch (e) {
      developer.log('❌ Error loading scanned documents: $e', name: 'HomeController');
      scannedDocuments.value = [];
    } finally {
      isLoadingScans.value = false;
    }
  }

  /// Get icon for eating style by name
  String? getEatingStyleIcon(String name) {
    try {
      return eatingStyleIcons
          .firstWhere((icon) => icon.eatingStyleName.toLowerCase() == name.toLowerCase())
          .eatingStyleIcon;
    } catch (e) {
      developer.log('⚠️ Icon not found for eating style: $name', name: 'HomeController');
      return null;
    }
  }

  /// Get icon for allergy by name
  String? getAllergyIcon(String name) {
    try {
      return allergyIcons
          .firstWhere((icon) => icon.allergyName.toLowerCase() == name.toLowerCase())
          .allergyIcon;
    } catch (e) {
      developer.log('⚠️ Icon not found for allergy: $name', name: 'HomeController');
      return null;
    }
  }

  /// Get icon for medical condition by name
  String? getMedicalConditionIcon(String name) {
    try {
      return medicalConditionIcons
          .firstWhere((icon) => icon.medicalConditionName.toLowerCase() == name.toLowerCase())
          .medicalConditionIcon;
    } catch (e) {
      developer.log('⚠️ Icon not found for medical condition: $name', name: 'HomeController');
      return null;
    }
  }

  /// Refresh all data (for pull-to-refresh)
  Future<void> refreshHomeData() async {
    developer.log('🔄 Refreshing home data...', name: 'HomeController');
    await loadHomeData();
    developer.log('✅ Home data refreshed', name: 'HomeController');
  }

  /// Force reload favorites only
  Future<void> reloadFavorites() async {
    developer.log('🔄 Force reloading favorites...', name: 'HomeController');
    await loadMyPlateFavorites();
  }

  /// Force reload scans only
  Future<void> reloadScans() async {
    developer.log('🔄 Force reloading scans...', name: 'HomeController');
    await loadScannedDocuments();
  }

  @override
  void onClose() {
    developer.log('👋 HomeController disposed', name: 'HomeController');
    super.onClose();
  }
}