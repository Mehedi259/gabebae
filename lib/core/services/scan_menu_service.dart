// lib/core/services/scan_menu_service.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // ✅ Add this
import 'dart:convert';
import '../../global/model/scan_menu_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';

class ScanMenuService {
  /// Scan menu with multiple images using XFile
  static Future<OcrScanResponse?> scanMenu(List<XFile> imageFiles) async {
    try {
      developer.log('📡 Starting OCR scan with ${imageFiles.length} images...',
          name: 'ScanMenuService');

      // Get token
      final token = await StorageHelper.getToken();
      if (token == null) {
        developer.log('❌ No token found', name: 'ScanMenuService');
        throw Exception('Authentication required');
      }

      // Create multipart request
      final url = Uri.parse('${ApiConstants.baseUrl}/ocr/scan');
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // ✅ Add files using XFile (works on all platforms)
      for (var imageFile in imageFiles) {
        developer.log('📎 Adding file: ${imageFile.path}',
            name: 'ScanMenuService');

        // Read file as bytes (works on web and mobile)
        final bytes = await imageFile.readAsBytes();

        final multipartFile = http.MultipartFile.fromBytes(
          'files',
          bytes,
          filename: imageFile.name,
        );
        request.files.add(multipartFile);
      }

      // Send request
      developer.log('🚀 Sending request...', name: 'ScanMenuService');
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      developer.log('📥 Response status: ${response.statusCode}',
          name: 'ScanMenuService');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        developer.log('✅ OCR scan successful', name: 'ScanMenuService');
        developer.log('📊 Found ${jsonData['food_items']?.length ?? 0} food items',
            name: 'ScanMenuService');

        return OcrScanResponse.fromJson(jsonData);
      } else {
        developer.log('❌ OCR scan failed: ${response.body}',
            name: 'ScanMenuService');
        throw Exception('OCR scan failed: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('❌ Error during OCR scan: $e', name: 'ScanMenuService');
      return null;
    }
  }
}