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