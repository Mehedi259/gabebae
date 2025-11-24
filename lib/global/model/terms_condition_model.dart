// lib/global/model/terms_condition_model.dart

class TermsConditionModel {
  final int id;
  final String content;
  final String lastUpdated;
  final String? image;

  TermsConditionModel({
    required this.id,
    required this.content,
    required this.lastUpdated,
    this.image,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
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