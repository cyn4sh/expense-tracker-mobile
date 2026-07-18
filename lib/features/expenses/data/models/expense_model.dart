import '../../../categories/data/models/category_detail.dart';

class ExpenseModel {
  final int id;
  final String amount;
  final String description;
  final String date;
  final CategoryDetail categoryDetail;
  final int owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.categoryDetail,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    final categoryDetail = json['category_detail'] != null
        ? CategoryDetail.fromJson(json['category_detail'] as Map<String, dynamic>)
        : CategoryDetail(
            id: json['category_id'] as int,
            name: json['category_name'] as String,
          );
    return ExpenseModel(
      id: json['id'] as int,
      amount: json['amount'].toString(),
      description: json['description'] as String,
      date: json['date'] as String,
      categoryDetail: categoryDetail,
      owner: json['owner'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date,
      'category_id': categoryDetail.id,
      'category_name': categoryDetail.name,
      'owner': owner,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateExpenseDto {
  final String amount;
  final String description;
  final String date;
  final int category;

  const CreateExpenseDto({
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'date': date,
        'category': category,
      };
}

class UpdateExpenseDto {
  final String amount;
  final String description;
  final String date;
  final int category;

  const UpdateExpenseDto({
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'date': date,
        'category': category,
      };
}