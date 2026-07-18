import 'package:dio/dio.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_error_handler.dart';
import 'models/category_model.dart';

class CategoriesRemoteDatasource {
  final Dio _dio;

  CategoriesRemoteDatasource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('categories/');
      final data = response.data as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ParseException();
    }
  }

  Future<CategoryModel> createCategory(CreateCategoryDto dto) async {
    try {
      final response = await _dio.post('categories/', data: dto.toJson());
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<CategoryModel> updateCategory(int id, UpdateCategoryDto dto) async {
    try {
      final response = await _dio.patch(
        'categories/$id/',
        data: dto.toJson(),
      );
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('categories/$id/');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}