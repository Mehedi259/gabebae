// lib/core/constants/api_constants.dart

class ApiConstants {
  // =================== Base URL ===================
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // =================== Authentication Endpoints ===================
  static const String requestOtp = "/auth/request-otp/";
  static const String verifyOtp = "/auth/verify-otp/";
  static const String usersMe = "/users/me/"; // Add this line

  // =================== Profile Setup Endpoints ===================
  static const String eatingStyle = "/eating-style/";
  static const String allergies = "/allergies/";
  static const String medicalConditions = "/medical-conditions/";
  static const String avatars = "/avatars/";
  static const String magicList = "/magic-list/";
  static const String profiles = "/profiles/";
  static const String activeProfile = "/profiles/active/";

  // =================== Home Screen Endpoints ===================
  static const String getEatingStyleIcons = "/eating-style/";
  static const String getAllergyIcons = "/allergies/";
  static const String getMedicalConditionIcons = "/medical-conditions/";
  static const String myPlate = "/myplate/";
  static const String scannedDocuments = "/ocr/scanned-documents/active/";

  // =================== Activity Screen Endpoints ===================
  static const String favorites = "/myplate/";
  static const String history = "/ocr/scanned-documents/active/";

  // =================== OCR Scan Endpoints ===================
  static const String ocrScan = "/ocr/scan";

  // =================== Chat Endpoints ===================
  static const String newConversation = "/chat/conversations/new/";
  static const String sendMessage = "/chat/";
  static const String conversations = "/chat/conversations/";

  static String deleteConversation(int conversationId) =>
      "/chat/conversations/$conversationId/delete/";

  // =================== Combo & Plate Endpoints ===================
  /// GET /api/combo/:id/:profile_name
  static String getCombo(int profileId, String profileName) =>
      "/combo/$profileId/$profileName";

  /// POST /api/myplate/
  /// Fields: meal_name, plate_combo (JSON array), image (multipart file)
  static const String createMyPlate = "/myplate/";

  /// GET /api/myplate/
  static const String getMyPlates = "/myplate/";

  // =================== Settings & Support Endpoints ===================
  static const String support = "/support/";
  static const String privacyPolicy = "/privacy-policy/";
  static const String terms = "/terms/";
  static const String aboutUs = "/about-us/";

  // =================== Helper Methods ===================
  static String getFullUrl(String endpoint) {
    return "$baseUrl$endpoint";
  }

  static String buildUrlWithParams(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse("$baseUrl$endpoint");
    final newUri = uri.replace(queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
    ));
    return newUri.toString();
  }
}