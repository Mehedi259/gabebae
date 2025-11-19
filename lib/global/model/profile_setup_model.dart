// lib/global/model/profile_setup_model.dart

/// Eating Style Model
class EatingStyle {
  final int id;
  final String eatingStyleName;
  final String? details;
  final String eatingStyleIcon;

  EatingStyle({
    required this.id,
    required this.eatingStyleName,
    this.details,
    required this.eatingStyleIcon,
  });

  factory EatingStyle.fromJson(Map<String, dynamic> json) {
    return EatingStyle(
      id: json['id'] as int,
      eatingStyleName: json['eating_style_name'] as String,
      details: json['details'] as String?,
      eatingStyleIcon: json['eating_style_icon'] as String,
    );
  }
}

/// Allergy Model
class Allergy {
  final int id;
  final String allergyName;
  final String allergyIcon;

  Allergy({
    required this.id,
    required this.allergyName,
    required this.allergyIcon,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      id: json['id'] as int,
      allergyName: json['allergy_name'] as String,
      allergyIcon: json['allergy_icon'] as String,
    );
  }
}

/// Medical Condition Model
class MedicalCondition {
  final int id;
  final String medicalConditionName;
  final String medicalDescription;
  final String medicalConditionIcon;

  MedicalCondition({
    required this.id,
    required this.medicalConditionName,
    required this.medicalDescription,
    required this.medicalConditionIcon,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) {
    return MedicalCondition(
      id: json['id'] as int,
      medicalConditionName: json['medical_condition_name'] as String,
      medicalDescription: json['medical_description'] as String,
      medicalConditionIcon: json['medical_condition_icon'] as String,
    );
  }
}

/// Avatar Model
class Avatar {
  final int id;
  final String avatarIcon;

  Avatar({
    required this.id,
    required this.avatarIcon,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'] as int,
      avatarIcon: json['avatar_icon'] as String,
    );
  }
}

/// Magic List Response Model
class MagicListResponse {
  final List<String> magicList;

  MagicListResponse({required this.magicList});

  factory MagicListResponse.fromJson(Map<String, dynamic> json) {
    final magicListData = json['magic_list'] as Map<String, dynamic>;
    final list = magicListData['magic_list'] as List<dynamic>;
    return MagicListResponse(
      magicList: list.map((e) => e.toString()).toList(),
    );
  }
}

/// Eating Style Selection
class EatingStyleSelection {
  final String name;
  final String level;

  EatingStyleSelection({
    required this.name,
    required this.level,
  });

  /// For Magic List API - uses 'name' field
  Map<String, dynamic> toMagicListJson() {
    return {
      'name': name,
      'level': level,
    };
  }

  /// For Profile Creation API - uses 'eating_style_name' field
  Map<String, dynamic> toJson() {
    return {
      'eating_style_name': name,
      'level': level,
    };
  }
}

/// Profile Create Request Model
class ProfileCreateRequest {
  final int user;
  final List<EatingStyleSelection> eatingStyle;
  final List<String> allergies;
  final List<String> medicalConditions;
  final List<String> magicList;
  final String profileName;
  final String country;
  final String avatar;
  final String dateOfBirth;
  final bool isActive;

  ProfileCreateRequest({
    required this.user,
    required this.eatingStyle,
    required this.allergies,
    required this.medicalConditions,
    required this.magicList,
    required this.profileName,
    required this.country,
    required this.avatar,
    required this.dateOfBirth,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'eating_style': eatingStyle.map((e) => e.toJson()).toList(),
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'magic_list': magicList,
      'profile_name': profileName,
      'country': country,
      'avatar': avatar,
      'date_of_birth': dateOfBirth,
      'is_active': isActive,
    };
  }
}

/// Profile Response Model
class ProfileResponse {
  final int id;
  final List<Map<String, dynamic>> eatingStyle;
  final List<String> allergies;
  final List<String> medicalConditions;
  final List<String> magicList;
  final String profileName;
  final String country;
  final String avatar;
  final String dateOfBirth;
  final String? profileImage;
  final bool isActive;
  final int user;

  ProfileResponse({
    required this.id,
    required this.eatingStyle,
    required this.allergies,
    required this.medicalConditions,
    required this.magicList,
    required this.profileName,
    required this.country,
    required this.avatar,
    required this.dateOfBirth,
    this.profileImage,
    required this.isActive,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as int,
      eatingStyle: (json['eating_style'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      allergies: (json['allergies'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      medicalConditions: (json['medical_conditions'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      magicList: (json['magic_list'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      profileName: json['profile_name'] as String,
      country: json['country'] as String,
      avatar: json['avatar'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      profileImage: json['profile_image'] as String?,
      isActive: json['is_active'] as bool,
      user: json['user'] as int,
    );
  }
}