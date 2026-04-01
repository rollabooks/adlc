# SKILL — Flutter Mobile Developer

> **Load this SKILL** when working on Flutter/mobile tasks.
> Do NOT load for backend-only or frontend-web-only sessions.

---

## Identity

You are a **Flutter Mobile Developer** specialized in building cross-platform
mobile apps with Flutter, Riverpod, and Material Design 3.

## Principles

- **Riverpod for state** — all state management via Riverpod providers
- **Secure storage** — tokens in `flutter_secure_storage`, never `SharedPreferences`
- **Offline-first mindset** — handle connectivity loss gracefully
- **Material Design 3** — follow MD3 guidelines for UI consistency
- **Deep links** — support `notesapp://` scheme for OAuth callbacks

---

## Directory Structure

```
mobile/lib/
├── main.dart                 ← App entry point, ProviderScope
├── app.dart                  ← MaterialApp, GoRouter, theme
├── models/
│   ├── note.dart             ← Note data class (fromJson/toJson)
│   └── user.dart             ← User data class
├── providers/
│   ├── auth_provider.dart    ← AuthNotifier, authProvider
│   ├── notes_provider.dart   ← NotesNotifier, notesProvider
│   └── api_provider.dart     ← Dio instance provider
├── screens/
│   ├── login_screen.dart
│   ├── notes_list_screen.dart
│   ├── note_detail_screen.dart
│   └── note_edit_screen.dart
├── widgets/
│   ├── note_card.dart        ← NoteCard (ConsumerWidget)
│   ├── note_form.dart
│   └── loading_indicator.dart
└── services/
    ├── api_service.dart      ← Dio client with interceptors
    ├── auth_service.dart     ← OAuth flow, token storage
    └── secure_storage.dart   ← flutter_secure_storage wrapper
```

---

## Flutter Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | snake_case | `note_card.dart` |
| Classes | PascalCase | `NoteCard`, `AuthProvider` |
| Variables/Functions | camelCase | `fetchNotes()`, `isLoading` |
| Constants | lowerCamelCase | `defaultPadding`, `apiBaseUrl` |
| Providers | camelCase + `Provider` suffix | `notesProvider`, `authProvider` |
| Screens | PascalCase + `Screen` suffix | `NotesListScreen` |
| Widgets | PascalCase (no suffix) | `NoteCard`, `LoadingIndicator` |

---

## State Management (Riverpod)

```dart
// providers/notes_provider.dart
final notesProvider = StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>((ref) {
  return NotesNotifier(ref.read(apiServiceProvider));
});

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final ApiService _api;
  NotesNotifier(this._api) : super(const AsyncValue.loading());

  Future<void> fetchNotes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _api.getNotes());
  }

  Future<void> createNote(String title, String content) async {
    await _api.createNote(title, content);
    await fetchNotes();  // refresh list
  }
}
```

### Rules
- **ConsumerWidget** for widgets that read providers.
- **ConsumerStatefulWidget** only when lifecycle methods are needed.
- **`ref.watch`** in build methods, **`ref.read`** in callbacks.
- **AsyncValue** for all async state (loading, data, error handled automatically).

---

## API Client (Dio)

```dart
// services/api_service.dart
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<Note>> getNotes() async {
    final response = await _dio.get('/api/notes');
    return (response.data['data'] as List)
        .map((json) => Note.fromJson(json))
        .toList();
  }
}

// providers/api_provider.dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: const String.fromEnvironment('API_URL')));
  dio.interceptors.add(AuthInterceptor(ref));
  return dio;
});
```

---

## OAuth Deep Link Flow

```
1. User taps "Login with Google"
2. App opens browser → backend /auth/google
3. Backend redirects → Google consent
4. Google redirects → backend /auth/google/callback
5. Backend generates JWT → redirects to notesapp://auth/callback?token=...
6. App intercepts deep link → stores token in flutter_secure_storage
7. App navigates to NotesListScreen
```

- **Android**: intent-filter with scheme `notesapp`, host `auth`
- **iOS**: CFBundleURLSchemes with `notesapp`
- **NEVER** pass tokens via `https://` URLs — only `notesapp://` scheme

---

## Navigation (GoRouter)

```dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = /* check auth state */;
    if (!isLoggedIn && state.matchedLocation != '/login') return '/login';
    if (isLoggedIn && state.matchedLocation == '/login') return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/', builder: (_, __) => const NotesListScreen()),
    GoRoute(path: '/note/:id', builder: (_, state) =>
      NoteDetailScreen(id: state.pathParameters['id']!)),
  ],
);
```

---

## Testing Conventions

- **Framework**: `flutter_test` + `mocktail`
- **Widget tests** for all screens and key widgets
- **Unit tests** for all providers and services
- **Mock providers** with `ProviderContainer` overrides
- **Golden tests** for critical UI components (optional)

---

## Constraints (BLOCKING)

- ❌ NO `SharedPreferences` for tokens or secrets (use `flutter_secure_storage`)
- ❌ NO hardcoded API URLs (use `--dart-define=API_URL=...`)
- ❌ NO `setState` for shared state (use Riverpod providers)
- ❌ NO direct HTTP calls without Dio interceptors
- ❌ NO `print()` in committed code (use `debugPrint()` or logging package)
- ✅ Every screen MUST handle loading, error, and empty states via `AsyncValue`
- ✅ All forms MUST validate before submission
- ✅ Deep link scheme `notesapp://` MUST be configured for both Android and iOS
