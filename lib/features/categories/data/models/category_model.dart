class CategoryModel {
  final int id;
  final String name;
  final int owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateCategoryDto {
  final String name;
  const CreateCategoryDto({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class UpdateCategoryDto {
  final String name;
  const UpdateCategoryDto({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}