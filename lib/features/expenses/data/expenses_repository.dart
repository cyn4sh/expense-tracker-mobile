import 'dart:async';
import 'models/expense_model.dart';
import 'expenses_remote_datasource.dart';
import 'expenses_local_datasource.dart';
import '../../../core/network/api_exceptions.dart';

class ExpensesRepository {
  final ExpensesRemoteDatasource _remoteDatasource;
  final ExpensesLocalDatasource _localDatasource;

  ExpensesRepository(this._remoteDatasource, this._localDatasource);

  Stream<List<ExpenseModel>> watchExpenses() async* {
    final cached = await _localDatasource.getCachedExpenses();
    yield cached;

    try {
      final fresh = await _remoteDatasource.getExpenses();
      await _localDatasource.cacheExpenses(fresh);
      yield fresh;
    } on ApiException {
      // Network failed — user keeps seeing cached data, no error surfaced.
    }
  }

  Future<ExpenseModel> createExpense(CreateExpenseDto dto) async {
    final created = await _remoteDatasource.createExpense(dto);
    await _localDatasource.cacheExpenses([created]);
    return created;
  }

  Future<ExpenseModel> updateExpense(int id, UpdateExpenseDto dto) async {
    final updated = await _remoteDatasource.updateExpense(id, dto);
    await _localDatasource.cacheExpenses([updated]);
    return updated;
  }

  Future<void> deleteExpense(int id) async {
    await _remoteDatasource.deleteExpense(id);
    await _localDatasource.deleteCachedExpense(id);
  }

  Future<void> clearLocalCache() async {
    await _localDatasource.clearCache();
  }
}
