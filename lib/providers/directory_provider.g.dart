// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SourceDirectory)
const sourceDirectoryProvider = SourceDirectoryProvider._();

final class SourceDirectoryProvider
    extends $NotifierProvider<SourceDirectory, String?> {
  const SourceDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceDirectoryHash();

  @$internal
  @override
  SourceDirectory create() => SourceDirectory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$sourceDirectoryHash() => r'd22eaefee3d5d68f7b0b77661f862222a7e0d59c';

abstract class _$SourceDirectory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TargetDirectory)
const targetDirectoryProvider = TargetDirectoryProvider._();

final class TargetDirectoryProvider
    extends $NotifierProvider<TargetDirectory, String?> {
  const TargetDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetDirectoryHash();

  @$internal
  @override
  TargetDirectory create() => TargetDirectory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$targetDirectoryHash() => r'2472ba5055490bb61869e128b127d2f792644602';

abstract class _$TargetDirectory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
