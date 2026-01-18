import 'dart:convert';
import 'dart:developer' as developer;

/// Active Profile Model
class ActiveProfileModel {
  final int id;
  final List<EatingStyle> eatingStyle;
  final List<String> allergies;
  final List<String> medicalConditions;
  final String profileName;
  final String? avatar;
  final String? profileImage;
  final bool isActive;
  final int user;

  ActiveProfileModel({
    required this.id,
    required this.eatingStyle,
    required this.allergies,
    required this.medicalConditions,
    required this.profileName,
    this.avatar,
    this.profileImage,
    required this.isActive,
    required this.user,
  });

  factory ActiveProfileModel.fromJson(Map<String, dynamic> json) {
    return ActiveProfileModel(
      id: json['id'] ?? 0,
      eatingStyle: (json['eating_style'] as List?)
          ?.map((e) => EatingStyle.fromJson(e))
          .toList() ??
          [],
      allergies: (json['allergies'] as List?)?.map((e) => e.toString()).toList() ?? [],
      medicalConditions: (json['medical_conditions'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      profileName: json['profile_name'] ?? '',
      avatar: json['avatar'],
      profileImage: json['profile_image'],
      isActive: json['is_active'] ?? false,
      user: json['user'] ?? 0,
    );
  }
}

/// Eating Style Model (from active profile)
class EatingStyle {
  final String name;

  EatingStyle({required this.name});

  factory EatingStyle.fromJson(Map<String, dynamic> json) {
    return EatingStyle(
      name: json['eating_style_name'] ?? json['name'] ?? '',
    );
  }
}

/// Eating Style with Icon Model
class EatingStyleIconModel {
  final int id;
  final String eatingStyleName;
  final String eatingStyleIcon;

  EatingStyleIconModel({
    required this.id,
    required this.eatingStyleName,
    required this.eatingStyleIcon,
  });

  factory EatingStyleIconModel.fromJson(Map<String, dynamic> json) {
    return EatingStyleIconModel(
      id: json['id'] ?? 0,
      eatingStyleName: json['eating_style_name'] ?? '',
      eatingStyleIcon: json['eating_style_icon'] ?? '',
    );
  }
}

/// Allergy with Icon Model
class AllergyIconModel {
  final int id;
  final String allergyName;
  final String allergyIcon;

  AllergyIconModel({
    required this.id,
    required this.allergyName,
    required this.allergyIcon,
  });

  factory AllergyIconModel.fromJson(Map<String, dynamic> json) {
    return AllergyIconModel(
      id: json['id'] ?? 0,
      allergyName: json['allergy_name'] ?? '',
      allergyIcon: json['allergy_icon'] ?? '',
    );
  }
}

/// Medical Condition with Icon Model
class MedicalConditionIconModel {
  final int id;
  final String medicalConditionName;
  final String medicalConditionIcon;

  MedicalConditionIconModel({
    required this.id,
    required this.medicalConditionName,
    required this.medicalConditionIcon,
  });

  factory MedicalConditionIconModel.fromJson(Map<String, dynamic> json) {
    return MedicalConditionIconModel(
      id: json['id'] ?? 0,
      medicalConditionName: json['medical_condition_name'] ?? '',
      medicalConditionIcon: json['medical_condition_icon'] ?? '',
    );
  }
}

/// My Plate (Favorites) Model
class MyPlateModel {
  final int id;
  final String mealName;
  final String imageUrl;
  final String createdAt;

  MyPlateModel({
    required this.id,
    required this.mealName,
    required this.imageUrl,
    required this.createdAt,
  });

  factory MyPlateModel.fromJson(Map<String, dynamic> json) {
    return MyPlateModel(
      id: json['id'] ?? 0,
      mealName: json['meal_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

/// Scanned Document Model
class ScannedDocumentModel {
  final String fileUrl;
  final String uploadedAt;
  final AiReply aiReply;

  ScannedDocumentModel({
    required this.fileUrl,
    required this.uploadedAt,
    required this.aiReply,
  });

  factory ScannedDocumentModel.fromJson(Map<String, dynamic> json) {
    // Parse file_urls - it comes as an array
    String parsedFileUrl = '';
    try {
      // The API returns "file_urls" as an array
      final fileUrlsRaw = json['file_urls'];

      if (fileUrlsRaw != null) {
        if (fileUrlsRaw is List && fileUrlsRaw.isNotEmpty) {
          // It's already a list, get first URL
          parsedFileUrl = fileUrlsRaw[0].toString();
        } else if (fileUrlsRaw is String) {
          // It's a string, try to parse as JSON array
          if (fileUrlsRaw.startsWith('[') && fileUrlsRaw.endsWith(']')) {
            final List<dynamic> urlList = jsonDecode(fileUrlsRaw);
            parsedFileUrl = urlList.isNotEmpty ? urlList[0].toString() : '';
          } else {
            // It's a direct URL string
            parsedFileUrl = fileUrlsRaw;
          }
        }
      }

      developer.log('✅ Parsed file URL: $parsedFileUrl', name: 'ScannedDocumentModel');
    } catch (e) {
      developer.log('❌ Error parsing file_urls: $e', name: 'ScannedDocumentModel');
      developer.log('Raw data: ${json['file_urls']}', name: 'ScannedDocumentModel');
    }

    return ScannedDocumentModel(
      fileUrl: parsedFileUrl,
      uploadedAt: json['uploaded_at'] ?? '',
      aiReply: AiReply.fromJson(json['ai_reply'] ?? {}),
    );
  }
}

/// AI Reply Model
class AiReply {
  final String documentTitle;
  final int totalSafeItems;
  final int totalUnsafeItems;
  final int totalCautionItems;

  AiReply({
    required this.documentTitle,
    required this.totalSafeItems,
    required this.totalUnsafeItems,
    required this.totalCautionItems,
  });

  factory AiReply.fromJson(Map<String, dynamic> json) {
    return AiReply(
      documentTitle: json['document_title'] ?? '',
      totalSafeItems: json['total_safe_items'] ?? 0,
      totalUnsafeItems: json['total_unsafe_items'] ?? 0,
      totalCautionItems: json['total_caution_items'] ?? 0,
    );
  }
}