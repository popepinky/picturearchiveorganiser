import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directory_provider.g.dart';

@riverpod
class SourceDirectory extends _$SourceDirectory {
  @override
  String? build() => null;

  void set(String? path) {
    state = path;
  }
}

@riverpod
class TargetDirectory extends _$TargetDirectory {
  @override
  String? build() => null;

  void set(String? path) {
    state = path;
  }
}
