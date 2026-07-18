import '../../../core/storage/database_helper.dart';
import 'models/budget_model.dart';
import 'package:sqflite/sqflite.dart';

class BudgetsLocalDatasource {
  final DatabaseHelper _databaseHelper;

  BudgetsLocalDatasource(this._databaseHelper);

  Future<List<BudgetModel>> getCachedBudgets() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('budgets');

    return maps.map((map) => BudgetModel.fromJson(map)).toList();
  }

  Future<void> cacheBudgets(List<BudgetModel> budgets) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final budget in budgets) {
      batch.insert(
        'budgets',
        budget.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteCachedBudget(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCache() async {
    final db = await _databaseHelper.database;
    await db.delete('budgets');
  }
}
