// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProcessingProgress)
const processingProgressProvider = ProcessingProgressProvider._();

final class ProcessingProgressProvider
    extends $NotifierProvider<ProcessingProgress, ProcessingProgressState> {
  const ProcessingProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'processingProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$processingProgressHash();

  @$internal
  @override
  ProcessingProgress create() => ProcessingProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcessingProgressState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcessingProgressState>(value),
    );
  }
}

String _$processingProgressHash() =>
    r'408a743e9b93cbff9e97d525dbd90fb153150cc3';

abstract class _$ProcessingProgress extends $Notifier<ProcessingProgressState> {
  ProcessingProgressState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ProcessingProgressState, ProcessingProgressState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProcessingProgressState, ProcessingProgressState>,
              ProcessingProgressState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
