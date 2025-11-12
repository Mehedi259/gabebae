//lib/core/constants/api_constants.dart
class ApiConstants {
  // Base URL
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // =================== Authentication Endpoints ===================
  static const String requestOtp = "/auth/request-otp/";
  static const String verifyOtp = "/auth/verify-otp/";
}