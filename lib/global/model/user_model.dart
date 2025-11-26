// lib/global/model/user_model.dart

class UserProfile {
  final int id;
  final String profileName;
  final String? avatar;
  final String? profileImage;

  UserProfile({
    required this.id,
    required this.profileName,
    this.avatar,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      profileName: json['profile_name'] ?? '',
      avatar: json['avatar'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_name': profileName,
      'avatar': avatar,
      'profile_image': profileImage,
    };
  }
}

class UserMeResponse {
  final int id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final UserProfile? activeProfile;
  final List<UserProfile>? profiles;

  UserMeResponse({
    required this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.activeProfile,
    this.profiles,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) {
    return UserMeResponse(
      id: json['id'] ?? 0,
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      activeProfile: json['active_profile'] != null
          ? UserProfile.fromJson(json['active_profile'])
          : null,
      profiles: (json['profiles'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'active_profile': activeProfile?.toJson(),
      'profiles': profiles?.map((e) => e.toJson()).toList(),
    };
  }
}