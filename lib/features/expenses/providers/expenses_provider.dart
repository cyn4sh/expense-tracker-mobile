import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/expense_model.dart';
import '../data/expenses_repository.dart';
import '../data/expenses_remote_datasource.dart';
import '../data/expenses_local_datasource.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/database_helper.dart';

part 'expenses_provider.g.dart';

@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExpensesRepository(
    ExpensesRemoteDatasource(apiClient.dio),
    ExpensesLocalDatasource(DatabaseHelper()),
  );
}

@riverpod
class ExpensesNotifier extends _$ExpensesNotifier {
  @override
  Stream<List<ExpenseModel>> build() {
    final repository = ref.watch(expensesRepositoryProvider);
    return repository.watchExpenses();
  }

  Future<void> createExpense(CreateExpenseDto dto) async {
    final repository = ref.read(expensesRepositoryProvider);
    await repository.createExpense(dto);
    ref.invalidateSelf();
  }

  Future<void> updateExpense(int id, UpdateExpenseDto dto) async {
    final repository = ref.read(expensesRepositoryProvider);
    await repository.updateExpense(id, dto);
    ref.invalidateSelf();
  }

  Future<void> deleteExpense(int id) async {
    final repository = ref.read(expensesRepositoryProvider);
    await repository.deleteExpense(id);
    ref.invalidateSelf();
  }

  Future<void> clearLocalCache() async {
    final repository = ref.read(expensesRepositoryProvider);
    await repository.clearLocalCache();
  }
}
