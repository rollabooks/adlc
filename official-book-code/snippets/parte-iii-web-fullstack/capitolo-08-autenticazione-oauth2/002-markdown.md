## Autenticazione

- Provider OAuth 2.0: Google, GitHub
- Libreria: passport.js con passport-google-oauth20 e passport-github2
- Token: JWT (jsonwebtoken)
- Strategia sessione: stateless (solo JWT, nessuna sessione server-side)
- Refresh token: salvato nel database, HTTP-only cookie

## Schema Database — Aggiunta tabella User

model User {
  id          String   @id @default(uuid())
  email       String   @unique
  name        String
  avatarUrl   String?  @map("avatar_url")
  provider    String   // "google" | "github"
  providerId  String   @map("provider_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")
  notes       Note[]

  @@unique([provider, providerId])
  @@map("users")
}

model Note {
  // ... campi esistenti ...
  userId    String @map("user_id")
  user      User   @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model RefreshToken {
  id        String   @id @default(uuid())
  token     String   @unique
  userId    String   @map("user_id")
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  expiresAt DateTime @map("expires_at")
  createdAt DateTime @default(now()) @map("created_at")

  @@map("refresh_tokens")
}

## Struttura Aggiornata — Nuovi File

src/
  routes/
    auth.js              ← Route OAuth (login, callback, refresh, logout)
  controllers/
    authController.js    ← Controller autenticazione
  services/
    authService.js       ← Logica utente e token
  middleware/
    authenticate.js      ← Middleware JWT: protegge gli endpoint
  config/
    passport.js          ← Configurazione strategie Passport

## Endpoint Autenticazione

| Metodo | Path | Descrizione | Protetto |
|:--|:--|:--|:--|
| GET | /api/auth/google | Redirect a Google login | No |
| GET | /api/auth/google/callback | Callback Google | No |
| GET | /api/auth/github | Redirect a GitHub login | No |
| GET | /api/auth/github/callback | Callback GitHub | No |
| POST | /api/auth/refresh | Rinnova access token | No (usa refresh token) |
| POST | /api/auth/logout | Invalida refresh token | Sì |
| GET | /api/auth/me | Profilo utente corrente | Sì |

## Vincoli Autenticazione (CRITICI)

- NON salvare MAI password in chiaro (OAuth non usa password, ma il principio vale)
- NON mettere MAI il JWT secret nel codice. Solo in .env.
- NON fidarti dell'input utente per l'identity. Usa SOLO i dati da Passport/OAuth.
- Il refresh token DEVE essere salvato nel database e invalidato al logout.
- Il JWT DEVE avere scadenza breve (1h). Il refresh token scade in 7 giorni.
- Gli endpoint delle note DEVONO filtrare per userId: un utente NON DEVE 
  vedere le note di altri utenti.
- Le callback OAuth DEVONO validare il parametro "state" per prevenire CSRF.

## Classificazione del Rischio

Operazioni legate all'autenticazione sono classificate MEDIUM RISK:
- Creazione utente: MEDIUM (genera record nel database)
- Emissione token: MEDIUM (concede accesso al sistema)
- Logout/invalidazione: LOW (operazione di sola cancellazione)
- Lettura profilo: LOW (sola lettura)