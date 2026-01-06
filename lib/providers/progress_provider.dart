import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress_provider.g.dart';

@riverpod
class ProcessingProgress extends _$ProcessingProgress {
  @override
  ProcessingProgressState build() => const ProcessingProgressState(
    total: 0,
    processed: 0,
    isProcessing: false,
  );

  void start(int total) {
    state = ProcessingProgressState(
      total: total,
      processed: 0,
      isProcessing: true,
    );
  }

  void update(int processed) {
    state = state.copyWith(processed: processed);
  }

  void complete() {
    state = state.copyWith(isProcessing: false);
  }

  void reset() {
    state = const ProcessingProgressState(
      total: 0,
      processed: 0,
      isProcessing: false,
    );
  }
}

class ProcessingProgressState {
  final int total;
  final int processed;
  final bool isProcessing;

  const ProcessingProgressState({
    required this.total,
    required this.processed,
    required this.isProcessing,
  });

  ProcessingProgressState copyWith({
    int? total,
    int? processed,
    bool? isProcessing,
  }) {
    return ProcessingProgressState(
      total: total ?? this.total,
      processed: processed ?? this.processed,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  int get remaining => total - processed;
  double get progress => total > 0 ? processed / total : 0.0;
}
