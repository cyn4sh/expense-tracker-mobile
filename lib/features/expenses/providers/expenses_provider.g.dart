// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expensesRepository)
final expensesRepositoryProvider = ExpensesRepositoryProvider._();

final class ExpensesRepositoryProvider
    extends
        $FunctionalProvider<
          ExpensesRepository,
          ExpensesRepository,
          ExpensesRepository
        >
    with $Provider<ExpensesRepository> {
  ExpensesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpensesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpensesRepository create(Ref ref) {
    return expensesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpensesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpensesRepository>(value),
    );
  }
}

String _$expensesRepositoryHash() =>
    r'224dfe2e97e500791b2593241ad7456f4f3e0688';

@ProviderFor(ExpensesNotifier)
final expensesProvider = ExpensesNotifierProvider._();

final class ExpensesNotifierProvider
    extends $StreamNotifierProvider<ExpensesNotifier, List<ExpenseModel>> {
  ExpensesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesNotifierHash();

  @$internal
  @override
  ExpensesNotifier create() => ExpensesNotifier();
}

String _$expensesNotifierHash() => r'74ff7898b9db10c2f61f028ede1311bffc9afc3a';

abstract class _$ExpensesNotifier extends $StreamNotifier<List<ExpenseModel>> {
  Stream<List<ExpenseModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>,
              AsyncValue<List<ExpenseModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
