import 'package:dio/dio.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_error_handler.dart';
import 'models/budget_model.dart';

class BudgetsRemoteDatasource {
  final Dio _dio;

  BudgetsRemoteDatasource(this._dio);

  Future<List<BudgetModel>> getBudgets() async {
    try {
      final response = await _dio.get('budgets/');
      final data = response.data as List;
      return data.map((json) => BudgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ParseException();
    }
  }

  Future<BudgetModel> createBudget(CreateBudgetDto dto) async {
    try {
      final response = await _dio.post('budgets/', data: dto.toJson());
      return BudgetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<BudgetModel> updateBudget(int id, UpdateBudgetDto dto) async {
    try {
      final response = await _dio.patch(
        'budgets/$id/',
        data: dto.toJson(),
      );
      return BudgetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _dio.delete('budgets/$id/');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
