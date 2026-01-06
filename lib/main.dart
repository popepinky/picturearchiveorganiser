import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picturearchiveorganiser/providers/router_provider.dart';
import 'string_constants.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: applicationTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF7C3AED), // vivid violet
              brightness: Brightness.light,
            ).copyWith(
              secondary: const Color(0xFFFF5BAA), // electric pink accent
            ),
        scaffoldBackgroundColor: const Color(0xFFF7F4FF),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ).copyWith(secondary: const Color(0xFFFF5BAA)),
        scaffoldBackgroundColor: const Color(0xFF0D0620),
      ),
    );
  }
}
