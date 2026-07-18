import 'package:dio/dio.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_error_handler.dart';
import 'models/expense_model.dart';

class ExpensesRemoteDatasource {
  final Dio _dio;

  ExpensesRemoteDatasource(this._dio);

  Future<List<ExpenseModel>> getExpenses() async {
    try {
      final response = await _dio.get('expenses/');
      final data = response.data as List;
      return data.map((json) => ExpenseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ParseException();
    }
  }

  Future<ExpenseModel> createExpense(CreateExpenseDto dto) async {
    try {
      final response = await _dio.post('expenses/', data: dto.toJson());
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<ExpenseModel> updateExpense(int id, UpdateExpenseDto dto) async {
    try {
      final response = await _dio.patch(
        'expenses/$id/',
        data: dto.toJson(),
      );
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _dio.delete('expenses/$id/');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
