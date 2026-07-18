import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/category_model.dart';
import '../data/categories_repository.dart';
import '../data/categories_remote_datasource.dart';
import '../data/categories_local_datasource.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/database_helper.dart';

part 'categories_provider.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoriesRepository(
    CategoriesRemoteDatasource(apiClient.dio),
    CategoriesLocalDatasource(DatabaseHelper()),
  );
}

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  Stream<List<CategoryModel>> build() {
    final repository = ref.watch(categoriesRepositoryProvider);
    return repository.watchCategories();
  }

  Future<void> createCategory(CreateCategoryDto dto) async {
    final repository = ref.read(categoriesRepositoryProvider);
    await repository.createCategory(dto);
    ref.invalidateSelf();
  }

  Future<void> updateCategory(int id, UpdateCategoryDto dto) async {
    final repository = ref.read(categoriesRepositoryProvider);
    await repository.updateCategory(id, dto);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(int id) async {
    final repository = ref.read(categoriesRepositoryProvider);
    await repository.deleteCategory(id);
    ref.invalidateSelf();
  }
}