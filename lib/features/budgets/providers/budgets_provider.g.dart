// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetsRepository)
final budgetsRepositoryProvider = BudgetsRepositoryProvider._();

final class BudgetsRepositoryProvider
    extends
        $FunctionalProvider<
          BudgetsRepository,
          BudgetsRepository,
          BudgetsRepository
        >
    with $Provider<BudgetsRepository> {
  BudgetsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BudgetsRepository create(Ref ref) {
    return budgetsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetsRepository>(value),
    );
  }
}

String _$budgetsRepositoryHash() => r'643df5c143e5badf2b311dd49f6cde27294039f9';

@ProviderFor(BudgetsNotifier)
final budgetsProvider = BudgetsNotifierProvider._();

final class BudgetsNotifierProvider
    extends $StreamNotifierProvider<BudgetsNotifier, List<BudgetModel>> {
  BudgetsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetsNotifierHash();

  @$internal
  @override
  BudgetsNotifier create() => BudgetsNotifier();
}

String _$budgetsNotifierHash() => r'a32c4717d1c65d632867843c8e52e55864b373cb';

abstract class _$BudgetsNotifier extends $StreamNotifier<List<BudgetModel>> {
  Stream<List<BudgetModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BudgetModel>>, List<BudgetModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BudgetModel>>, List<BudgetModel>>,
              AsyncValue<List<BudgetModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
