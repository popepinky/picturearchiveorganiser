import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return createRouter(ref);
});
