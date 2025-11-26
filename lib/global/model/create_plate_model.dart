// lib/global/model/create_plate_model.dart

class ComboIngredient {
  final String name;

  ComboIngredient({required this.name});

  factory ComboIngredient.fromJson(Map<String, dynamic> json) {
    return ComboIngredient(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class ComboResponse {
  final List<ComboIngredient> combo;

  ComboResponse({required this.combo});

  factory ComboResponse.fromJson(Map<String, dynamic> json) {
    return ComboResponse(
      combo: (json['combo'] as List<dynamic>?)
          ?.map((e) => ComboIngredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class MyPlateRequest {
  final String mealName;
  final List<String> plateCombo;
  final String? imagePath;
  final List<int>? imageBytes;

  MyPlateRequest({
    required this.mealName,
    required this.plateCombo,
    this.imagePath,
    this.imageBytes,
  });

  Map<String, String> toFields() {
    return {
      'meal_name': mealName,
      'plate_combo': '${plateCombo.map((e) => '"$e"').join(', ')}',
    };
  }
}

class MyPlateResponse {
  final int id;
  final String mealName;
  final String imageUrl;
  final List<String> plateCombo;
  final String createdAt;
  final String updatedAt;
  final int user;
  final int profile;

  MyPlateResponse({
    required this.id,
    required this.mealName,
    required this.imageUrl,
    required this.plateCombo,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.profile,
  });

  factory MyPlateResponse.fromJson(Map<String, dynamic> json) {
    return MyPlateResponse(
      id: json['id'] ?? 0,
      mealName: json['meal_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      plateCombo: (json['plate_combo'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] ?? 0,
      profile: json['profile'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_name': mealName,
      'image_url': imageUrl,
      'plate_combo': plateCombo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user,
      'profile': profile,
    };
  }
}