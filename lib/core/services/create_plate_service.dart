// lib/core/services/create_plate_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../global/model/create_plate_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';

class CreatePlateService {
  /// Fetch Combo Suggestions
  /// @param profileId - Actually the main User ID (from /users/me/ response.id)
  /// @param profileName - Active profile's name (from profiles[].profile_name where is_active = true)
  /// API Call: GET /combo/{userId}/{activeProfileName}
  /// Example: GET /combo/1/saifur
  static Future<ComboResponse> getComboSuggestions({
    required int profileId,
    required String profileName,
  }) async {
    try {
      final token = await StorageHelper.getToken();
      final endpoint = '/combo/$profileId/$profileName';
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      developer.log('📤 GET Combo Request to: $uri', name: 'CreatePlateService');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token?.trim() ?? ""}',
        },
      );

      developer.log('📥 Combo Response Status: ${response.statusCode}',
          name: 'CreatePlateService');
      developer.log('📥 Combo Response Body: ${response.body}',
          name: 'CreatePlateService');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ComboResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch combo: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      developer.log('❌ Combo Fetch Error: $e', name: 'CreatePlateService');
      throw Exception('Error fetching combo suggestions: $e');
    }
  }

  /// Save My Plate
  static Future<MyPlateResponse> saveMyPlate({
    required MyPlateRequest request,
  }) async {
    try {
      final token = await StorageHelper.getToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.myPlate}");

      developer.log('📤 POST MyPlate Request to: $uri',
          name: 'CreatePlateService');
      developer.log('📦 Meal Name: ${request.mealName}',
          name: 'CreatePlateService');
      developer.log('📦 Plate Combo: ${request.plateCombo}',
          name: 'CreatePlateService');

      var httpRequest = http.MultipartRequest('POST', uri);

      // Add Authorization Header
      final cleaned = token?.trim() ?? "";
      if (cleaned.isNotEmpty) {
        httpRequest.headers['Authorization'] = 'Bearer $cleaned';
      }
      httpRequest.headers['Accept'] = 'application/json';

      // Add Fields
      httpRequest.fields['meal_name'] = request.mealName;
      httpRequest.fields['plate_combo'] =
          jsonEncode(request.plateCombo);

      // Add Image File
      if (!kIsWeb && request.imagePath != null) {
        final file = await http.MultipartFile.fromPath(
          'image',
          request.imagePath!,
        );
        httpRequest.files.add(file);
        developer.log('📷 Image added from path: ${request.imagePath}',
            name: 'CreatePlateService');
      } else if (kIsWeb && request.imageBytes != null) {
        final file = http.MultipartFile.fromBytes(
          'image',
          request.imageBytes!,
          filename: 'meal_image.jpg',
        );
        httpRequest.files.add(file);
        developer.log('📷 Image added from bytes (Web)',
            name: 'CreatePlateService');
      }

      // Send Request
      final streamedResponse = await httpRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      developer.log('📥 MyPlate Response Status: ${response.statusCode}',
          name: 'CreatePlateService');
      developer.log('📥 MyPlate Response Body: ${response.body}',
          name: 'CreatePlateService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return MyPlateResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to save meal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      developer.log('❌ Save MyPlate Error: $e', name: 'CreatePlateService');
      throw Exception('Error saving meal: $e');
    }
  }

  /// Fetch User's Saved Plates
  static Future<List<MyPlateResponse>> getMyPlates() async {
    try {
      final response = await ApiService.getRequest(ApiConstants.myPlate);

      if (response is List) {
        return response
            .map((e) => MyPlateResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic> &&
          response.containsKey('results')) {
        return (response['results'] as List)
            .map((e) => MyPlateResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      developer.log('❌ Fetch MyPlates Error: $e', name: 'CreatePlateService');
      throw Exception('Error fetching saved plates: $e');
    }
  }
}