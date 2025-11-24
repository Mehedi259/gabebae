// lib/global/model/profile_model.dart

class ProfileModel {
  final int id;
  final String profileName;
  final String? avatar;
  final String? profileImage;
  final bool isActive;
  final int user;

  ProfileModel({
    required this.id,
    required this.profileName,
    this.avatar,
    this.profileImage,
    required this.isActive,
    required this.user,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      profileName: json['profile_name'] ?? '',
      avatar: json['avatar'],
      profileImage: json['profile_image'],
      isActive: json['is_active'] ?? false,
      user: json['user'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_name': profileName,
      'avatar': avatar,
      'profile_image': profileImage,
      'is_active': isActive,
      'user': user,
    };
  }

  ProfileModel copyWith({
    int? id,
    String? profileName,
    String? avatar,
    String? profileImage,
    bool? isActive,
    int? user,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      avatar: avatar ?? this.avatar,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      user: user ?? this.user,
    );
  }
}

class UserProfilesModel {
  final int id;
  final List<ProfileModel> profiles;
  final String? country;
  final String? language;

  UserProfilesModel({
    required this.id,
    required this.profiles,
    this.country,
    this.language,
  });

  factory UserProfilesModel.fromJson(Map<String, dynamic> json) {
    return UserProfilesModel(
      id: json['id'] ?? 0,
      profiles: (json['profiles'] as List?)
          ?.map((p) => ProfileModel.fromJson(p))
          .toList() ?? [],
      country: json['country'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profiles': profiles.map((p) => p.toJson()).toList(),
      'country': country,
      'language': language,
    };
  }
}