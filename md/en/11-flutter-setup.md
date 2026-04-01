# Chapter 11 — Project 8: Flutter Setup and First Mobile App

## What You Will Build

A working Flutter mobile application that:
- Runs on Android and iOS from a single codebase
- Has a login screen and a notes list (static UI for now)
- Uses the 0-code development pattern with `_CONTEXT.md` for Flutter/Dart
- Teaches you the structure of a Flutter project

**Estimated time**: 60–90 minutes  
**Prerequisite**: Working Notes API backend (Chapters 6–10)

---

> ⚙️ **Version Note** — The instructions in this chapter are verified with Flutter 3.x, Dart 3.x, Riverpod 2.x, and GoRouter 14.x. The Flutter ecosystem evolves rapidly: packages change APIs between minor versions. If the AI flags a deprecated method or suggests a newer version of a package, trust the correction — the architectural pattern stays the same. Always run `flutter pub get` after changes to `pubspec.yaml`.

> 📦 **Tooling Box — Stack chosen for this example.**
> - **Framework:** Flutter 3.x (Dart 3.x)
> - **State Management:** Riverpod 2.x
> - **Routing:** GoRouter 14.x
> - **HTTP Client:** Dio
>
> **Equivalent alternatives:** React Native, Kotlin Multiplatform, .NET MAUI. The **pattern** (declarative UI, state management, navigation, API calls to the backend) is common to all cross-platform mobile frameworks. If you choose React Native, the ADLC method and `_CONTEXT.md` work in exactly the same way.

## 11.1 — Installing Flutter

### Windows

```bash
# Using winget (recommended)
winget install -e --id Google.Flutter

# Or download manually from https://docs.flutter.dev/get-started/install
```

### macOS

```bash
brew install --cask flutter
```

### Linux

```bash
sudo snap install flutter --classic
```

### Verifying the Installation

```bash
flutter doctor
```

This command checks that all prerequisites are installed. You need:
- ✅ Flutter SDK
- ✅ Android toolchain (Android Studio or command-line tools only)
- ✅ Connected device (emulator or physical device)

> 💡 **Tip**: For Android development without installing full Android Studio, you can use just the Android SDK command-line tools. But for your first projects, Android Studio with the built-in emulator is the simplest choice.

### VS Code Extension

Install the **Flutter** (Dart-Code) extension for VS Code. This enables:
- Dart support with IntelliSense
- Flutter run and debug directly from VS Code
- Hot reload (instant app updates during development)
- Widget inspector

---

## 11.2 — Creating the Project

### 🔧 HANDS-ON — Project scaffold

```bash
cd notes-fullstack
flutter create notes_mobile
cd notes_mobile
```

The generated structure:
```text
notes_mobile/
├── lib/
│   └── main.dart          ← App entry point
├── android/               ← Native Android configuration
├── ios/                   ← Native iOS configuration
├── test/                  ← Tests
├── pubspec.yaml           ← Dependencies (equivalent of package.json)
└── analysis_options.yaml  ← Lint rules
```

### 🔧 HANDS-ON — Verify it works

```bash
flutter run
```

If you have an emulator configured, you will see the Flutter demo app. If you don't have an emulator:

```bash
# List available devices
flutter devices

# Launch an Android emulator (if configured)
flutter emulators --launch <emulator_name>

# Or use Chrome for quick testing
flutter run -d chrome
```

> 💡 **Tip**: During development, `flutter run -d chrome` is the fastest way to iterate. You don't need an Android/iOS emulator for most UI work. You'll switch to the emulator only to test native features.

---

## 11.3 — The Context for Flutter

### 🔧 HANDS-ON — Create `_CONTEXT.md`

```markdown
# Project: Notes Mobile (Flutter)

## Purpose
A Flutter mobile app that connects to the Notes API backend for personal
note management with OAuth 2.0 authentication.

## Technologies
- Framework: Flutter 3.x
- Language: Dart
- State Management: Riverpod 2
- HTTP: Dio
- Routing: GoRouter
- Local Storage: flutter_secure_storage (for tokens)
- UI: Material Design 3

## Backend
The backend is available at:
- Local development: http://10.0.2.2:3000/api (for Android emulator)
- Chrome development: http://localhost:3000/api
- Production: https://api.notes-app.example.com/api

See the root monorepo _CONTEXT.md for the complete list of endpoints.

## Architecture

lib/
  main.dart
  app.dart                      ← MaterialApp with theme and router
  config/
    api_config.dart              ← Backend URL, timeouts
    theme.dart                   ← Material Design 3 theme
  models/
    user.dart                    ← User model
    note.dart                    ← Note model
    category.dart                ← Category model
    api_response.dart            ← API response wrapper
  services/
    api_service.dart             ← Configured Dio client
    auth_service.dart            ← Login, logout, refresh token
    notes_service.dart           ← Notes CRUD
  providers/
    auth_provider.dart           ← Authentication state (Riverpod)
    notes_provider.dart          ← Notes state (Riverpod)
  screens/
    login_screen.dart            ← Login screen
    dashboard_screen.dart        ← Notes list
    note_detail_screen.dart      ← Note detail
    note_form_screen.dart        ← Create/edit note
  widgets/
    note_card.dart               ← Single note card
    empty_state.dart             ← Empty state
    loading_indicator.dart       ← Loading indicator
    error_banner.dart            ← Error banner

## Dart/Flutter Conventions

- Files: snake_case.dart
- Classes: PascalCase
- Variables and functions: camelCase
- Constants: lowerCamelCase (not UPPER_SNAKE)
- Widgets: one widget per file
- State: use Riverpod (NOT setState for shared state)
- Models: use immutable classes with factory fromJson/toJson
- Null safety: ALWAYS enabled, use ? only when necessary
- No widgets nested deeper than 3 levels → extract into separate widgets

## Constraints

- DO NOT use SharedPreferences for JWT tokens. Use flutter_secure_storage.
- DO NOT use setState for state shared across screens. Use Riverpod.
- DO NOT hardcode URLs. Use api_config.dart with environment support.
- Every screen must handle: loading, error, empty, data.
- The app should work offline showing cached data (stretch goal).
- Material Design 3 with useMaterial3: true.

## Commands
- Run: flutter run
- Test: flutter test
- Build Android: flutter build apk
- Build iOS: flutter build ios
- Analysis: flutter analyze
```

---

## 11.4 — SKILL.md for Flutter

### 🔧 HANDS-ON — Create `SKILL.md`

```markdown
---
name: flutter-mobile-developer
description: Skill for Flutter mobile app development with Material
  Design 3, Riverpod, and Dio.
---

# Flutter Mobile Developer Skill

## Widget Structure

A Flutter widget follows this pattern:

```dart
class NoteCard extends ConsumerWidget {
  final Note note;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content, maxLines: 2),
        onTap: onTap,
      ),
    );
  }
}
```

## Riverpod Pattern

```dart
// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Usage in a widget
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // ...
  }
}
```

## Immutable Models

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
  };
}
```

## Error Handling

```dart
try {
  final notes = await notesService.getAll();
  state = NotesState.loaded(notes);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    ref.read(authProvider.notifier).logout();
  } else {
    state = NotesState.error(e.message ?? 'Unknown error');
  }
} catch (e) {
  state = NotesState.error('Unexpected error');
}
```

## Navigation with GoRouter

```dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = /* check auth state */;
    if (!isLoggedIn && state.matchedLocation != '/login') return '/login';
    if (isLoggedIn && state.matchedLocation == '/login') return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/notes/:id', builder: (_, state) => 
      NoteDetailScreen(id: state.pathParameters['id']!)),
  ],
);
```

## Material 3 Design

- Use ColorScheme.fromSeed(seedColor: Colors.indigo) for automatic palette
- Use Theme.of(context).colorScheme to access colors
- Use Theme.of(context).textTheme for typography
- Card with elevation: 0 and border with side for a modern look
- FilledButton for primary actions, OutlinedButton for secondary actions
```

---

## 11.5 — Generating the Base Structure

### 🔧 HANDS-ON — Generate the app with Copilot

```text
Read the _CONTEXT.md and SKILL.md. Generate the base structure
of the Flutter app.

Implementation order:
1. Add dependencies in pubspec.yaml: 
   dio, riverpod, flutter_riverpod, go_router, flutter_secure_storage
2. Create lib/config/api_config.dart with backend URL for each environment
3. Create lib/config/theme.dart with Material Design 3 theme (seed: indigo)
4. Create lib/models/ (Note, User, ApiResponse) as immutable classes
5. Create lib/services/api_service.dart (Dio with token interceptor)
6. Create lib/providers/auth_provider.dart (state: loading/authenticated/unauthenticated)
7. Create lib/app.dart with MaterialApp.router and ProviderScope
8. Create lib/screens/login_screen.dart (static UI only for now)
9. Create lib/screens/dashboard_screen.dart (static UI only with mock data)
10. Configure GoRouter with redirect for route protection
11. Update lib/main.dart
```

### 🔧 HANDS-ON — Install the dependencies

After the AI has updated `pubspec.yaml`:

```bash
flutter pub get
```

---

## 11.6 — Verification and Iteration

### 🔧 HANDS-ON — Launch the app

```bash
flutter run -d chrome  # For quick testing
# or
flutter run             # On emulator/device
```

### Verification checklist

| Feature | Test |
|:--|:--|
| **App starts** | No compilation errors |
| **Login screen** | You see the Google/GitHub buttons (not functional yet) |
| **Theme** | Colors follow the Material 3 indigo theme |
| **Router** | Navigation between login and dashboard works |
| **Redirect** | Direct access to /dashboard redirects to /login |

### 🔧 HANDS-ON — Hot Reload

With the app running, modify the text of a button in the Dart code and save. The app updates **instantly** without restarting. This is Flutter's **Hot Reload** — the fastest feedback loop in mobile development.

### 🎯 CHECKPOINT
If the app starts, shows the login screen with the Material 3 theme, and navigation works, you are ready for the next chapter where you will connect the app to the backend.

---

## 11.7 — The Dart World in 10 Minutes

You don't need to know Dart to work in 0-code — the AI writes the code for you. But recognizing the patterns helps you review.

### Key concepts

```dart
// Variables: strong typing, null safety
String name = 'Notes App';
int? count;         // Nullable
final items = <Note>[];  // Typed list, final = non-reassignable

// Functions
Future<List<Note>> fetchNotes() async {
  final response = await dio.get('/api/notes');
  return (response.data['data'] as List)
      .map((json) => Note.fromJson(json))
      .toList();
}

// Classes
class Note {
  final String id;
  final String title;
  const Note({required this.id, required this.title});
}

// Widget = function that returns UI
class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const MyButton({super.key, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
```

> 💡 **Tip**: Dart closely resembles Java/TypeScript. If you know either one, you'll read Dart with no trouble. If you don't know either, don't worry: the AI writes the code, you verify it does what you asked.

---

## Summary

| Aspect | Detail |
|:--|:--|
| **Framework** | Flutter 3.x with Dart |
| **State** | Riverpod 2 |
| **Routing** | GoRouter with redirect |
| **Design** | Material Design 3 |
| **HTTP** | Dio (in the next chapter) |
| **Token** | flutter_secure_storage (in the next chapter) |
| **Project structure** | Monorepo notes-fullstack/notes_mobile/ |

---

**→ In the next chapter**: we will connect the Flutter app to the backend. We will implement OAuth authentication on mobile, note loading, and the full CRUD.
