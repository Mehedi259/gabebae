// lib/global/model/about_us_model.dart

class AboutUsModel {
  final int id;
  final String content;
  final String lastUpdated;
  final String? image;

  AboutUsModel({
    required this.id,
    required this.content,
    required this.lastUpdated,
    this.image,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      image: json['image'], lastUpdated: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image': image,
    };
  }
}