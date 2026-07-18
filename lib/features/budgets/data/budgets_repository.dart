import 'dart:async';
import 'models/budget_model.dart';
import 'budgets_remote_datasource.dart';
import 'budgets_local_datasource.dart';
import '../../../core/network/api_exceptions.dart';

class BudgetsRepository {
  final BudgetsRemoteDatasource _remoteDatasource;
  final BudgetsLocalDatasource _localDatasource;

  BudgetsRepository(this._remoteDatasource, this._localDatasource);

  Stream<List<BudgetModel>> watchBudgets() async* {
    final cached = await _localDatasource.getCachedBudgets();
    yield cached;

    try {
      final fresh = await _remoteDatasource.getBudgets();
      await _localDatasource.cacheBudgets(fresh);
      yield fresh;
    } on ApiException {
      // Network failed — user keeps seeing cached data, no error surfaced.
    }
  }

  Future<BudgetModel> createBudget(CreateBudgetDto dto) async {
    final created = await _remoteDatasource.createBudget(dto);
    await _localDatasource.cacheBudgets([created]);
    return created;
  }

  Future<BudgetModel> updateBudget(int id, UpdateBudgetDto dto) async {
    final updated = await _remoteDatasource.updateBudget(id, dto);
    await _localDatasource.cacheBudgets([updated]);
    return updated;
  }

  Future<void> deleteBudget(int id) async {
    await _remoteDatasource.deleteBudget(id);
    await _localDatasource.deleteCachedBudget(id);
  }

  Future<void> clearLocalCache() async {
    await _localDatasource.clearCache();
  }
}
