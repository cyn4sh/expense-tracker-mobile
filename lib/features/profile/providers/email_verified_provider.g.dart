// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verified_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emailVerified)
final emailVerifiedProvider = EmailVerifiedProvider._();

final class EmailVerifiedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  EmailVerifiedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailVerifiedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailVerifiedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return emailVerified(ref);
  }
}

String _$emailVerifiedHash() => r'3b1109780cf66e5460fc819ea7d6d08c0d6729fd';
