import 'dart:async';
import 'models/category_model.dart';
import 'categories_remote_datasource.dart';
import 'categories_local_datasource.dart';
import '../../../core/network/api_exceptions.dart';

class CategoriesRepository {
  final CategoriesRemoteDatasource _remoteDatasource;
  final CategoriesLocalDatasource _localDatasource;

  CategoriesRepository(this._remoteDatasource, this._localDatasource);

  Stream<List<CategoryModel>> watchCategories() async* {
    final cached = await _localDatasource.getCachedCategories();
    yield cached;

    try {
      final fresh = await _remoteDatasource.getCategories();
      await _localDatasource.cacheCategories(fresh);
      yield fresh;
    } on ApiException {
      // Network failed — user keeps seeing cached data, no error surfaced.
    }
  }

  Future<CategoryModel> createCategory(CreateCategoryDto dto) async {
    final created = await _remoteDatasource.createCategory(dto);
    await _localDatasource.cacheCategories([created]);
    return created;
  }

  Future<CategoryModel> updateCategory(int id, UpdateCategoryDto dto) async {
    final updated = await _remoteDatasource.updateCategory(id, dto);
    await _localDatasource.cacheCategories([updated]);
    return updated;
  }

  Future<void> deleteCategory(int id) async {
    await _remoteDatasource.deleteCategory(id);
    await _localDatasource.deleteCachedCategory(id);
  }

  Future<void> clearLocalCache() async {
    await _localDatasource.clearCache();
  }
}