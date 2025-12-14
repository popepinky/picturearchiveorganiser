// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_organiser_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageOrganiserService)
const imageOrganiserServiceProvider = ImageOrganiserServiceProvider._();

final class ImageOrganiserServiceProvider
    extends
        $FunctionalProvider<
          ImageOrganiserService,
          ImageOrganiserService,
          ImageOrganiserService
        >
    with $Provider<ImageOrganiserService> {
  const ImageOrganiserServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageOrganiserServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageOrganiserServiceHash();

  @$internal
  @override
  $ProviderElement<ImageOrganiserService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageOrganiserService create(Ref ref) {
    return imageOrganiserService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageOrganiserService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageOrganiserService>(value),
    );
  }
}

String _$imageOrganiserServiceHash() =>
    r'45d1e558dd17842c4c131f21f5b5b3b8c4d3a527';
