import '../../../core/storage/database_helper.dart';
import 'models/category_model.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesLocalDatasource {
  final DatabaseHelper _databaseHelper;

  CategoriesLocalDatasource(this._databaseHelper);

  Future<List<CategoryModel>> getCachedCategories() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('categories');

    return maps.map((map) => CategoryModel.fromJson(map)).toList();
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final category in categories) {
      batch.insert(
        'categories',
        category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteCachedCategory(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCache() async {
    final db = await _databaseHelper.database;
    await db.delete('categories');
  }
}