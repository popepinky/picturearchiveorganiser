import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/image_organiser_service.dart';

part 'image_organiser_provider.g.dart';

@riverpod
ImageOrganiserService imageOrganiserService(Ref ref) {
  return ImageOrganiserService();
}
