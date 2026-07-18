import '../../../categories/data/models/category_detail.dart';

class BudgetModel {
  final int id;
  final CategoryDetail categoryDetail;
  final String amount;
  final int month;
  final int year;
  final int owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.categoryDetail,
    required this.amount,
    required this.month,
    required this.year,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final categoryDetail = json['category_detail'] != null
        ? CategoryDetail.fromJson(json['category_detail'] as Map<String, dynamic>)
        : CategoryDetail(
            id: json['category_id'] as int,
            name: json['category_name'] as String,
          );
    return BudgetModel(
      id: json['id'] as int,
      categoryDetail: categoryDetail,
      amount: json['amount'].toString(),
      month: json['month'] as int,
      year: json['year'] as int,
      owner: json['owner'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryDetail.id,
      'category_name': categoryDetail.name,
      'amount': amount,
      'month': month,
      'year': year,
      'owner': owner,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateBudgetDto {
  final int category;
  final String amount;
  final int month;
  final int year;

  const CreateBudgetDto({
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'month': month,
        'year': year,
      };
}

class UpdateBudgetDto {
  final int category;
  final String amount;
  final int month;
  final int year;

  const UpdateBudgetDto({
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'month': month,
        'year': year,
      };
}