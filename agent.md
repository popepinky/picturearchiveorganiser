# New Project Guidelines: Riverpod and Go Router

This document provides guidelines for setting up a new Flutter project for macOS, using the same conventions for Riverpod and Go-Router as in the `multiusetool` project.

## 1. Project Setup

1.  Create a new Flutter project:
    ```bash
    flutter create --platforms=macos my_new_app
    ```
2.  Open the project in your favorite IDE.

## 2. Dependencies

Add the following dependencies to your `pubspec.yaml` file. These are based on the `multiusetool` project.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.0.3
  go_router: ^16.2.5
  riverpod_annotation: ^3.0.3

dev_dependencies:
  build_runner: ^2.4.9
  riverpod_generator: ^3.0.3
```

After adding the dependencies, run `flutter pub get`.

## 3. Directory Structure

It's a good practice to organize your files. Based on `multiusetool`, here's a suggestion:

```
lib/
|-- main.dart
|-- routes.dart
|-- string_constants.dart
|-- providers/
|   |-- router_provider.dart
|   `-- other_providers.dart
`-- pages/
    |-- home_page.dart
    `-- other_pages.dart
```

## 4. Riverpod Setup

### 4.1. Create a Provider

In `multiusetool`, providers are defined in separate files.

**Annotated (Modern) Provider:**
This is the recommended approach. The parameter to the provider function should be `Ref`.

**`lib/providers/image_organiser_provider.dart`:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_organiser_service.dart';

part 'image_organiser_provider.g.dart';

@riverpod
ImageOrganiserService imageOrganiserService(Ref ref) {
  return ImageOrganiserService();
}
```

**Legacy Provider:**
For simple cases, you might see this style.

**`lib/providers/router_provider.dart`:**
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return createRouter(ref);
});
```

### 4.2. Wrap your App in `ProviderScope`

To make providers available throughout your app, wrap the root widget in a `ProviderScope`.

**`lib/main.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_app/providers/router_provider.dart';
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
        primarySwatch: Colors.blue,
      ),
    );
  }
}
```

## 5. Go Router Setup

### 5.1. Define your Routes

Create a `routes.dart` file to define the application's routes. This keeps your routing logic separate from the rest of your app.

**`lib/routes.dart`:**

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home_page.dart';

GoRouter createRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // Add other routes here
    ],
  );
}
```

### 5.2. Create your Home Page

Create a simple home page.

**`lib/pages/home_page.dart`:**

```dart
import 'package:flutter/material.dart';
import '../string_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(homePageTitle),
      ),
      body: const Center(
        child: Text(homePageWelcomeMessage),
      ),
    );
  }
}
```

## 6. Running the App

You should now be able to run your app on macOS.

```bash
flutter run -d macos
```

## 7. UI String Conventions

To maintain consistency and simplify future updates or localization, all UI-facing strings should be defined as constants in a single file.

### 7.1. Create the Constants File

Create a file at `lib/string_constants.dart`.

### 7.2. Define String Constants

Add your UI strings to this file as `const String`.

**`lib/string_constants.dart`:**
```dart
// Application-wide strings
const String applicationTitle = 'My New App';

// Home Page strings
const String homePageTitle = 'Home Page';
const String homePageWelcomeMessage = 'Welcome to your new macOS app!';

// Add other strings as your app grows
```

### 7.3. Use Constants in Widgets

Import `string_constants.dart` into your widget files and use the constants instead of hardcoded strings. This is demonstrated in the `main.dart` and `home_page.dart` examples in the sections above.

This setup provides a solid foundation for your new project, following the same patterns as `multiusetool`. You can now add more complex providers and routes as your application grows.

## 8. Style and Linting Notes

### 8.1. Color Opacity

The `withOpacity` method on `Color` is deprecated. Use `withAlpha` instead for better performance and to avoid precision loss. For example, instead of `Colors.black.withOpacity(0.5)`, use `Colors.black.withAlpha(128)`.
