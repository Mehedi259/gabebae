// lib/global/model/privacy_policy_model.dart

class PrivacyPolicyModel {
  final int id;
  final String content;
  final String lastUpdated;
  final String? image;

  PrivacyPolicyModel({
    required this.id,
    required this.content,
    required this.lastUpdated,
    this.image,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'last_updated': lastUpdated,
      'image': image,
    };
  }
}