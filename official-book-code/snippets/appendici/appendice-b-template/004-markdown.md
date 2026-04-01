---
name: flutter-developer
description: Skill per sviluppo app mobile Flutter.
---

# Flutter Developer Skill

## Stack
- Flutter 3.x / Dart
- Riverpod 2 per state management
- GoRouter per navigazione
- Dio per HTTP
- flutter_secure_storage per token

## Struttura
lib/
  config/      ← Configurazione (API URL, tema)
  models/      ← Classi immutabili con fromJson/toJson
  services/    ← Client HTTP, auth, business logic
  providers/   ← Riverpod StateNotifier
  screens/     ← Schermate (una per route)
  widgets/     ← Widget riutilizzabili

## Convenzioni
- File: snake_case.dart, Classi: PascalCase
- Widget: ConsumerWidget per accedere ai provider
- Modelli: classi immutabili con factory constructor
- NON usare setState per stato condiviso
- NON usare SharedPreferences per token
- Material Design 3 con useMaterial3: true