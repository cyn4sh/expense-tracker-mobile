import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/budget_model.dart';
import '../data/budgets_repository.dart';
import '../data/budgets_remote_datasource.dart';
import '../data/budgets_local_datasource.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/database_helper.dart';

part 'budgets_provider.g.dart';

@riverpod
BudgetsRepository budgetsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BudgetsRepository(
    BudgetsRemoteDatasource(apiClient.dio),
    BudgetsLocalDatasource(DatabaseHelper()),
  );
}

@riverpod
class BudgetsNotifier extends _$BudgetsNotifier {
  @override
  Stream<List<BudgetModel>> build() {
    final repository = ref.watch(budgetsRepositoryProvider);
    return repository.watchBudgets();
  }

  Future<void> createBudget(CreateBudgetDto dto) async {
    final repository = ref.read(budgetsRepositoryProvider);
    await repository.createBudget(dto);
    ref.invalidateSelf();
  }

  Future<void> updateBudget(int id, UpdateBudgetDto dto) async {
    final repository = ref.read(budgetsRepositoryProvider);
    await repository.updateBudget(id, dto);
    ref.invalidateSelf();
  }

  Future<void> deleteBudget(int id) async {
    final repository = ref.read(budgetsRepositoryProvider);
    await repository.deleteBudget(id);
    ref.invalidateSelf();
  }

  Future<void> clearLocalCache() async {
    final repository = ref.read(budgetsRepositoryProvider);
    await repository.clearLocalCache();
  }
}
