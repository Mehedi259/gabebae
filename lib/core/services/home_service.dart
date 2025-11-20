// lib/core/services/home_service.dart
import 'dart:developer' as developer;
import '../../global/model/home_model.dart';
import 'api_service.dart';

class HomeService {
  /// Get Active Profile
  static Future<ActiveProfileModel?> getActiveProfile() async {
    try {
      developer.log('📡 Fetching active profile...', name: 'HomeService');

      final response = await ApiService.getRequest('/profiles/active/');
      developer.log('✅ Active Profile Response: $response', name: 'HomeService');

      return ActiveProfileModel.fromJson(response);
    } catch (e) {
      developer.log('❌ Error fetching active profile: $e', name: 'HomeService');
      return null;
    }
  }

  /// Get Eating Style Icons
  static Future<List<EatingStyleIconModel>> getEatingStyleIcons() async {
    try {
      developer.log('📡 Fetching eating style icons...', name: 'HomeService');

      final response = await ApiService.getRequest('/eating-style/');
      developer.log('✅ Eating Style Icons Response: $response', name: 'HomeService');

      if (response is List) {
        return response.map((e) => EatingStyleIconModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      developer.log('❌ Error fetching eating style icons: $e', name: 'HomeService');
      return [];
    }
  }

  /// Get Allergy Icons
  static Future<List<AllergyIconModel>> getAllergyIcons() async {
    try {
      developer.log('📡 Fetching allergy icons...', name: 'HomeService');

      final response = await ApiService.getRequest('/allergies/');
      developer.log('✅ Allergy Icons Response: $response', name: 'HomeService');

      if (response is List) {
        return response.map((e) => AllergyIconModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      developer.log('❌ Error fetching allergy icons: $e', name: 'HomeService');
      return [];
    }
  }

  /// Get Medical Condition Icons
  static Future<List<MedicalConditionIconModel>> getMedicalConditionIcons() async {
    try {
      developer.log('📡 Fetching medical condition icons...', name: 'HomeService');

      final response = await ApiService.getRequest('/medical-conditions/');
      developer.log('✅ Medical Condition Icons Response: $response', name: 'HomeService');

      if (response is List) {
        return response.map((e) => MedicalConditionIconModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      developer.log('❌ Error fetching medical condition icons: $e', name: 'HomeService');
      return [];
    }
  }

  /// Get My Plate (Favorites)
  static Future<List<MyPlateModel>> getMyPlate() async {
    try {
      developer.log('📡 Fetching my plate favorites...', name: 'HomeService');

      final response = await ApiService.getRequest('/myplate/');
      developer.log('✅ My Plate Response: $response', name: 'HomeService');

      if (response is List) {
        return response.map((e) => MyPlateModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      developer.log('❌ Error fetching my plate: $e', name: 'HomeService');
      return [];
    }
  }

  /// Get Scanned Documents (Recent Scans)
  static Future<List<ScannedDocumentModel>> getScannedDocuments() async {
    try {
      developer.log('📡 Fetching scanned documents...', name: 'HomeService');

      final response = await ApiService.getRequest('/ocr/scanned-documents/active/');
      developer.log('✅ Scanned Documents Response: $response', name: 'HomeService');

      if (response is List) {
        return response.map((e) => ScannedDocumentModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      developer.log('❌ Error fetching scanned documents: $e', name: 'HomeService');
      return [];
    }
  }
}