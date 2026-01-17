// lib/core/services/scan_menu_service.dart
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import '../../global/model/scan_menu_model.dart';
import '../../utils/storage/storage_helper.dart';
import '../constants/api_constants.dart';

class ScanMenuService {
  /// Scan menu with images and PDFs
  static Future<OcrScanResponse?> scanMenu({
    List<XFile>? images,
    List<PlatformFile>? pdfs,
  }) async {
    try {
      final totalFiles = (images?.length ?? 0) + (pdfs?.length ?? 0);
      developer.log('📡 Starting OCR scan with $totalFiles files...',
          name: 'ScanMenuService');

      // Get token
      final token = await StorageHelper.getToken();
      if (token == null) {
        developer.log('❌ No token found', name: 'ScanMenuService');
        throw Exception('Authentication required');
      }

      // Create multipart request
      final url = Uri.parse('${ApiConstants.baseUrl}/ocr/scan/');
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // ✅ Add image files
      if (images != null && images.isNotEmpty) {
        for (var imageFile in images) {
          developer.log('📎 Adding image: ${imageFile.name}',
              name: 'ScanMenuService');

          final bytes = await imageFile.readAsBytes();
          final multipartFile = http.MultipartFile.fromBytes(
            'files',
            bytes,
            filename: imageFile.name,
          );
          request.files.add(multipartFile);
        }
      }

      // ✅ Add PDF files
      if (pdfs != null && pdfs.isNotEmpty) {
        for (var pdfFile in pdfs) {
          developer.log('📎 Adding PDF: ${pdfFile.name}',
              name: 'ScanMenuService');

          if (pdfFile.bytes != null) {
            // Web: use bytes directly
            final multipartFile = http.MultipartFile.fromBytes(
              'files',
              pdfFile.bytes!,
              filename: pdfFile.name,
            );
            request.files.add(multipartFile);
          } else if (pdfFile.path != null) {
            // Mobile: use path
            final multipartFile = await http.MultipartFile.fromPath(
              'files',
              pdfFile.path!,
              filename: pdfFile.name,
            );
            request.files.add(multipartFile);
          }
        }
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
        developer.log(
            '📊 Found ${jsonData['food_items']?.length ?? 0} food items',
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