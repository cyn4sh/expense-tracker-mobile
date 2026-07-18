import '../../../core/storage/database_helper.dart';
import 'models/expense_model.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesLocalDatasource {
  final DatabaseHelper _databaseHelper;

  ExpensesLocalDatasource(this._databaseHelper);

  Future<List<ExpenseModel>> getCachedExpenses() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('expenses');

    return maps.map((map) => ExpenseModel.fromJson(map)).toList();
  }

  Future<void> cacheExpenses(List<ExpenseModel> expenses) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final expense in expenses) {
      batch.insert(
        'expenses',
        expense.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteCachedExpense(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCache() async {
    final db = await _databaseHelper.database;
    await db.delete('expenses');
  }
}
