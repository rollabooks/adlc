# Capitolo 11 — Progetto 8: Setup Flutter e Prima App Mobile

## Cosa Costruirai

Un'applicazione mobile Flutter funzionante che:
- Gira su Android e iOS da un unico codice
- Ha una schermata di login e una lista note (UI statica per ora)
- Usa il pattern di sviluppo 0-code con `_CONTEXT.md` per Flutter/Dart
- Ti insegna la struttura di un progetto Flutter

**Tempo stimato**: 60-90 minuti  
**Prerequisito**: Backend Notes API funzionante (Capitoli 6-10)

---

> ⚙️ **Nota di versione** — Le istruzioni di questo capitolo sono verificate con Flutter 3.x, Dart 3.x, Riverpod 2.x e GoRouter 14.x. L'ecosistema Flutter evolve rapidamente: i pacchetti cambiano API tra versioni minor. Se l'IA ti segnala un metodo deprecato o suggerisce una versione più recente di un pacchetto, fidati della correzione — il pattern architetturale resta lo stesso. Esegui sempre `flutter pub get` dopo modifiche a `pubspec.yaml`.

> 📦 **Box Tooling — Stack scelto per questo esempio.**
> - **Framework:** Flutter 3.x (Dart 3.x)
> - **State Management:** Riverpod 2.x
> - **Routing:** GoRouter 14.x
> - **HTTP Client:** Dio
>
> **Alternative equivalenti:** React Native, Kotlin Multiplatform, .NET MAUI. Il **pattern** (UI dichiarativa, gestione stato, navigazione, chiamate API al backend) è comune a tutti i framework mobile cross-platform. Se scegli React Native, il metodo ADLC e il `_CONTEXT.md` funzionano allo stesso modo.

## 11.1 — Installare Flutter

### Windows

```bash
# Usando winget (consigliato)
winget install -e --id Google.Flutter

# Oppure scarica manualmente da https://docs.flutter.dev/get-started/install
```

### macOS

```bash
brew install --cask flutter
```

### Linux

```bash
sudo snap install flutter --classic
```

### Verifica installazione

```bash
flutter doctor
```

Questo comando verifica che tutti i prerequisiti siano installati. Devi avere:
- ✅ Flutter SDK
- ✅ Android toolchain (Android Studio o solo command-line tools)
- ✅ Connected device (emulatore o dispositivo fisico)

> 💡 **Suggerimento**: Per lo sviluppo Android senza installare Android Studio completo, puoi usare solo Android SDK command-line tools. Ma per i primi progetti, Android Studio con l'emulatore integrato è la scelta più semplice.

### VS Code Extension

Installa l'estensione **Flutter** (Dart-Code) per VS Code. Questa abilita:
- Supporto Dart con IntelliSense
- Esecuzione e debug Flutter direttamente da VS Code
- Hot reload (aggiornamento istantaneo dell'app durante lo sviluppo)
- Widget inspector

---

## 11.2 — Creare il Progetto

### 🔧 PRATICA — Scaffold del progetto

```bash
cd notes-fullstack
flutter create notes_mobile
cd notes_mobile
```

La struttura generata:
```text
notes_mobile/
├── lib/
│   └── main.dart          ← Punto di ingresso dell'app
├── android/               ← Configurazione Android nativa
├── ios/                   ← Configurazione iOS nativa
├── test/                  ← Test
├── pubspec.yaml           ← Dipendenze (equivalente di package.json)
└── analysis_options.yaml  ← Regole di lint
```

### 🔧 PRATICA — Verifica che funzioni

```bash
flutter run
```

Se hai un emulatore configurato, vedrai l'app demo di Flutter. Se non hai un emulatore:

```bash
# Lista i dispositivi disponibili
flutter devices

# Avvia un emulatore Android (se configurato)
flutter emulators --launch <nome_emulatore>

# Oppure usa Chrome per test rapidi
flutter run -d chrome
```

> 💡 **Suggerimento**: Durante lo sviluppo, `flutter run -d chrome` è il modo più veloce per iterare. Non hai bisogno di un emulatore Android/iOS per la maggior parte del lavoro UI. Passerai all'emulatore solo per testare funzionalità native.

---

## 11.3 — Il Contesto per Flutter

### 🔧 PRATICA — Crea `_CONTEXT.md`

```markdown
# Progetto: Notes Mobile (Flutter)

## Scopo
App mobile Flutter che si collega al backend Notes API per la gestione 
di note personali con autenticazione OAuth 2.0.

## Tecnologie
- Framework: Flutter 3.x
- Linguaggio: Dart
- State Management: Riverpod 2
- HTTP: Dio
- Routing: GoRouter
- Storage locale: flutter_secure_storage (per token)
- UI: Material Design 3

## Backend
Il backend è disponibile su:
- Sviluppo locale: http://10.0.2.2:3000/api (per emulatore Android)
- Sviluppo Chrome: http://localhost:3000/api
- Produzione: https://api.notes-app.example.com/api

Vedi il _CONTEXT.md di root del monorepo per la lista completa degli endpoint.

## Architettura

lib/
  main.dart
  app.dart                      ← MaterialApp con tema e router
  config/
    api_config.dart              ← URL backend, timeouts
    theme.dart                   ← Tema Material Design 3
  models/
    user.dart                    ← Modello utente
    note.dart                    ← Modello nota
    category.dart                ← Modello categoria
    api_response.dart            ← Wrapper risposta API
  services/
    api_service.dart             ← Client Dio configurato
    auth_service.dart            ← Login, logout, refresh token
    notes_service.dart           ← CRUD note
  providers/
    auth_provider.dart           ← Stato autenticazione (Riverpod)
    notes_provider.dart          ← Stato note (Riverpod)
  screens/
    login_screen.dart            ← Schermata login
    dashboard_screen.dart        ← Lista note
    note_detail_screen.dart      ← Dettaglio nota
    note_form_screen.dart        ← Creazione/modifica nota
  widgets/
    note_card.dart               ← Card singola nota
    empty_state.dart             ← Stato vuoto
    loading_indicator.dart       ← Indicatore caricamento
    error_banner.dart            ← Banner errore

## Convenzioni Dart/Flutter

- File: snake_case.dart
- Classi: PascalCase
- Variabili e funzioni: camelCase
- Costanti: lowerCamelCase (non UPPER_SNAKE)
- Widget: ogni widget in un file separato
- State: usa Riverpod (NON setState per stato condiviso)
- Modelli: usa classi immutabili con factory fromJson/toJson
- Null safety: SEMPRE abilitato, usa ? solo quando necessario
- Nessun widget annidato a più di 3 livelli → estrai in widget separati

## Vincoli

- NON usare SharedPreferences per token JWT. Usa flutter_secure_storage.
- NON usare setState per stato condiviso tra schermate. Usa Riverpod.
- NON hardcodare URL. Usa api_config.dart con supporto per ambienti.
- Ogni schermata deve gestire: loading, errore, vuoto, dati.
- L'app deve funzionare offline mostrando dati cached (stretch goal).
- Material Design 3 con useMaterial3: true.

## Comandi
- Avviare: flutter run
- Test: flutter test
- Build Android: flutter build apk
- Build iOS: flutter build ios
- Analisi: flutter analyze
```

---

## 11.4 — SKILL.md per Flutter

### 🔧 PRATICA — Crea `SKILL.md`

```markdown
---
name: flutter-mobile-developer
description: Skill per lo sviluppo di app mobile Flutter con Material
  Design 3, Riverpod e Dio.
---

# Flutter Mobile Developer Skill

## Struttura Widget

Un widget Flutter segue questo pattern:

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
// Provider per stato auth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Uso nel widget
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // ...
  }
}
```

## Modelli Immutabili

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
    state = NotesState.error(e.message ?? 'Errore sconosciuto');
  }
} catch (e) {
  state = NotesState.error('Errore imprevisto');
}
```

## Navigazione con GoRouter

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

## Design Material 3

- Usa ColorScheme.fromSeed(seedColor: Colors.indigo) per palette automatica
- Usa Theme.of(context).colorScheme per accedere ai colori
- Usa Theme.of(context).textTheme per la tipografia
- Card con elevation: 0 e bordo con side per stile moderno
- FilledButton per azioni primarie, OutlinedButton per secondarie
```

---

## 11.5 — Generare la Struttura Base

### 🔧 PRATICA — Genera l'app con Copilot

```text
Leggi il _CONTEXT.md e il SKILL.md. Genera la struttura base 
dell'app Flutter.

Ordine di implementazione:
1. Aggiungi le dipendenze in pubspec.yaml: 
   dio, riverpod, flutter_riverpod, go_router, flutter_secure_storage
2. Crea lib/config/api_config.dart con URL backend per ogni ambiente
3. Crea lib/config/theme.dart con tema Material Design 3 (seed: indigo)
4. Crea lib/models/ (Note, User, ApiResponse) come classi immutabili
5. Crea lib/services/api_service.dart (Dio con interceptor per token)
6. Crea lib/providers/auth_provider.dart (stato: loading/authenticated/unauthenticated)
7. Crea lib/app.dart con MaterialApp.router e ProviderScope
8. Crea lib/screens/login_screen.dart (solo UI statica per ora)
9. Crea lib/screens/dashboard_screen.dart (solo UI statica con dati mock)
10. Configura GoRouter con redirect per protezione route
11. Aggiorna lib/main.dart
```

### 🔧 PRATICA — Installa le dipendenze

Dopo che l'IA ha aggiornato `pubspec.yaml`:

```bash
flutter pub get
```

---

## 11.6 — Verifica e Iterazione

### 🔧 PRATICA — Avvia l'app

```bash
flutter run -d chrome  # Per test rapidi
# oppure
flutter run             # Su emulatore/dispositivo
```

### Checklist di verifica

| Funzionalità | Test |
|:--|:--|
| **App si avvia** | Nessun errore di compilazione |
| **Login screen** | Vedi i bottoni Google/GitHub (non funzionanti ancora) |
| **Tema** | I colori seguono il tema Material 3 indigo |
| **Router** | Navigazione tra login e dashboard funziona |
| **Redirect** | Accesso diretto a /dashboard redirige a /login |

### 🔧 PRATICA — Hot Reload

Con l'app in esecuzione, modifica il testo di un bottone nel codice Dart e salva. L'app si aggiorna **istantaneamente** senza ripartire. Questo è il **Hot Reload** di Flutter — il feedback loop più veloce dello sviluppo mobile.

### 🎯 CHECKPOINT
Se l'app si avvia, mostra il login screen con il tema Material 3 e la navigazione funziona, sei pronto per il prossimo capitolo dove collegherai l'app al backend.

---

## 11.7 — Il Mondo Dart in 10 Minuti

Non hai bisogno di conoscere Dart per lavorare in 0-code — l'IA scrive il codice per te. Ma riconoscere i pattern ti aiuta a revisionare.

### Concetti chiave

```dart
// Variabili: tipizzazione forte, null safety
String name = 'Notes App';
int? count;         // Nullable
final items = <Note>[];  // Lista tipizzata, final = non riassegnabile

// Funzioni
Future<List<Note>> fetchNotes() async {
  final response = await dio.get('/api/notes');
  return (response.data['data'] as List)
      .map((json) => Note.fromJson(json))
      .toList();
}

// Classi
class Note {
  final String id;
  final String title;
  const Note({required this.id, required this.title});
}

// Widget = funzione che restituisce UI
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

> 💡 **Suggerimento**: Dart assomiglia molto a Java/TypeScript. Se conosci uno dei due, leggerai Dart senza problemi. Se non conosci nessuno dei due, non preoccuparti: l'IA scrive il codice, tu verifichi che faccia quello che hai chiesto.

---

## Riepilogo

| Aspetto | Dettaglio |
|:--|:--|
| **Framework** | Flutter 3.x con Dart |
| **State** | Riverpod 2 |
| **Routing** | GoRouter con redirect |
| **Design** | Material Design 3 |
| **HTTP** | Dio (nel prossimo capitolo) |
| **Token** | flutter_secure_storage (nel prossimo capitolo) |
| **Struttura progetto** | Monorepo notes-fullstack/notes_mobile/ |

---

**→ Nel prossimo capitolo**: collegheremo l'app Flutter al backend. Implementeremo l'autenticazione OAuth su mobile, il caricamento delle note e il CRUD completo.
