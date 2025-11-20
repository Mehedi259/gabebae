// lib/core/constants/api_constants.dart

class ApiConstants {
  // =================== Base URL ===================
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // =================== Authentication Endpoints ===================
  static const String requestOtp = "/auth/request-otp/";
  static const String verifyOtp = "/auth/verify-otp/";

  // =================== Profile Setup Endpoints ===================
  static const String eatingStyle = "/eating-style/";
  static const String allergies = "/allergies/";
  static const String medicalConditions = "/medical-conditions/";
  static const String avatars = "/avatars/";
  static const String magicList = "/magic-list/";
  static const String profiles = "/profiles/";
  static const String activeProfile = "/profiles/active/";

  // =================== Home Screen Endpoints ===================
  /// Get eating style icons
  /// GET /api/eating-style/
  static const String getEatingStyleIcons = "/eating-style/";

  /// Get allergy icons
  /// GET /api/allergies/
  static const String getAllergyIcons = "/allergies/";

  /// Get medical condition icons
  /// GET /api/medical-conditions/
  static const String getMedicalConditionIcons = "/medical-conditions/";

  /// Get user's favorite plates
  /// GET /api/myplate/
  static const String myPlate = "/myplate/";

  /// Get scanned documents (recent scans)
  /// GET /api/ocr/scanned-documents/active/
  static const String scannedDocuments = "/ocr/scanned-documents/active/";

  // =================== Activity Screen Endpoints ===================
  /// Same as myPlate for favorites tab
  static const String favorites = "/myplate/";

  /// Same as scannedDocuments for history tab
  static const String history = "/ocr/scanned-documents/active/";

  // =================== Helper Methods ===================

  /// Get full URL for any endpoint
  static String getFullUrl(String endpoint) {
    return "$baseUrl$endpoint";
  }

  /// Build URL with query parameters
  static String buildUrlWithParams(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse("$baseUrl$endpoint");
    final newUri = uri.replace(queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
    ));
    return newUri.toString();
  }
}