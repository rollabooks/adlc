# Capitolo 8 — Progetto 5: Autenticazione OAuth 2.0 e JWT

## Cosa Costruirai

Aggiungerai alla Notes API un sistema di autenticazione completo:
- Login con Google e GitHub tramite OAuth 2.0
- Token JWT per le sessioni
- Middleware di protezione degli endpoint
- Ogni utente vede solo le proprie note
- Refresh token per sessioni persistenti

**Tempo stimato**: 60-90 minuti  
**Prerequisito**: Progetto `notes-api` con PostgreSQL (Capitolo 7)

---

> 💡 **Box Teoria — Autenticazione e Autorizzazione.** L'**autenticazione** risponde alla domanda "Chi sei?" (es. login con Google). L'**autorizzazione** risponde a "Cosa puoi fare?" (es. vedere solo le *tue* note). **OAuth 2.0** è un protocollo che delega l'autenticazione a un servizio esterno (Google, GitHub): tu non gestisci password, il servizio conferma l'identità dell'utente. Un **JWT** (JSON Web Token) è un "biglietto digitale" firmato che il server rilascia dopo il login: l'utente lo allega a ogni richiesta successiva per dimostrare la sua identità senza rifare il login. Un **middleware** è codice che si inserisce tra la richiesta e la risposta per svolgere un compito trasversale (come verificare il JWT).

## 8.1 — OAuth 2.0 in 5 Minuti

Prima di implementare, capiamo il flusso. OAuth 2.0 è il protocollo che permette a un utente di fare login con Google/GitHub senza che tu debba gestire password.

![Il Flusso OAuth 2.0 Semplificato](../../figures/it/04-oauth2-flusso.png)

**In sintesi**: l'utente si autentica su Google, Google conferma la sua identità al tuo backend, il tuo backend crea un JWT (un "biglietto" digitale) che l'utente usa per ogni richiesta successiva.

> ⚠️ **Attenzione**: Non scriverai manualmente questo flusso. L'IA lo implementerà per te. Ma devi capirlo per verificare che l'implementazione sia corretta e sicura.

> 📦 **Box Tooling — Stack scelto per questo esempio.**
> - **Protocollo:** OAuth 2.0 (provider Google e GitHub)
> - **Token:** JWT (JSON Web Token)
> - **Libreria:** Passport.js
>
> **Alternative equivalenti:** Auth0, Firebase Auth, Clerk, Supabase Auth. Il **pattern** (autenticazione delegata + token di sessione + middleware di protezione) resta identico qualunque sia la libreria o il servizio scelto. In altri linguaggi: Python/Authlib, Go/golang-jwt, Java/Spring Security.

---

## 8.2 — Creare le Credenziali OAuth

### 🔧 PRATICA — Google OAuth

1. Vai su [console.cloud.google.com](https://console.cloud.google.com)
2. Crea un nuovo progetto (o seleziona uno esistente)
3. Vai su **API e Servizi → Credenziali**
4. Clicca **Crea Credenziali → ID client OAuth**
5. Tipo: **Applicazione Web**
6. Nome: `Notes App`
7. URI di reindirizzamento autorizzati: `http://localhost:3000/api/auth/google/callback`
8. Copia **Client ID** e **Client Secret**

### 🔧 PRATICA — GitHub OAuth

1. Vai su [github.com/settings/developers](https://github.com/settings/developers)
2. Clicca **New OAuth App**
3. Application name: `Notes App`
4. Homepage URL: `http://localhost:3000`
5. Authorization callback URL: `http://localhost:3000/api/auth/github/callback`
6. Copia **Client ID** e **Client Secret**

### 🔧 PRATICA — Aggiorna il file `.env`

```env
DATABASE_URL="postgresql://notes:notes123@localhost:5432/notesdb"

# OAuth Google
GOOGLE_CLIENT_ID=il-tuo-client-id
GOOGLE_CLIENT_SECRET=il-tuo-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/api/auth/google/callback

# OAuth GitHub
GITHUB_CLIENT_ID=il-tuo-client-id
GITHUB_CLIENT_SECRET=il-tuo-client-secret
GITHUB_CALLBACK_URL=http://localhost:3000/api/auth/github/callback

# JWT
JWT_SECRET=una-stringa-lunga-e-casuale-almeno-32-caratteri
JWT_EXPIRES_IN=1h
JWT_REFRESH_EXPIRES_IN=7d
```

> ⚠️ **Attenzione SICUREZZA**: Il file `.env` NON deve MAI essere committato su Git. Verifica che `.gitignore` lo includa. Non condividere mai i client secret.

---

## 8.3 — Aggiornare il Contesto

### 🔧 PRATICA — Sezione autenticazione nel `_CONTEXT.md`

Aggiungi queste sezioni:

```markdown
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
```

> 📖 **Approfondimento**: Nota la sezione "Classificazione del Rischio". È un concetto dell'ADLC che diventa molto pratico: definendo il livello di rischio di ogni operazione nel contesto, l'IA sarà più attenta nella generazione del codice di sicurezza. È l'equivalente di dire "fai attenzione qui — questa parte è delicata."

---

## 8.4 — Generazione dell'Autenticazione

### 🔧 PRATICA — Implementazione

In Copilot Agent Mode:

```text
Rileggi il _CONTEXT.md aggiornato. Implementa il sistema di autenticazione 
OAuth 2.0 per la Notes API.

Ordine di implementazione:
1. Aggiorna lo schema Prisma con User, RefreshToken e la relazione Note→User
2. Genera la migrazione
3. Installa le dipendenze (passport, passport-google-oauth20, passport-github2, 
   jsonwebtoken, cookie-parser)
4. Crea src/config/passport.js con le strategie OAuth
5. Crea src/services/authService.js (createOrFindUser, generateTokens, 
   refreshAccessToken, revokeRefreshToken)
6. Crea src/middleware/authenticate.js (middleware JWT)
7. Crea src/controllers/authController.js
8. Crea src/routes/auth.js
9. Aggiorna src/app.js per montare le route auth e il middleware passport
10. Aggiorna notesService.js per filtrare le note per userId
11. Aggiorna notesController.js per passare req.user.id al service
12. Aggiorna i test
```

---

## 8.5 — Verifica dell'Autenticazione

### 🔧 PRATICA — Test del flusso OAuth

1. Avvia il server: `npm run dev`

2. Apri nel browser: `http://localhost:3000/api/auth/google`
   - Verrai reindirizzato alla pagina di login di Google
   - Dopo il login, verrai reindirizzato al callback
   - Il backend genererà un JWT

3. Copia il token JWT dalla risposta

4. Testa un endpoint protetto:
```bash
curl http://localhost:3000/api/notes \
  -H "Authorization: Bearer IL_TUO_TOKEN_JWT"
```

5. Testa senza token (deve fallire):
```bash
curl http://localhost:3000/api/notes
```
```json
{ "success": false, "error": { "message": "Authentication required", "code": "UNAUTHORIZED" } }
```

6. Testa l'isolamento utente: le note create con il token dell'utente A non devono essere visibili con il token dell'utente B.

### 🎯 CHECKPOINT
- OAuth Google funziona ✅
- OAuth GitHub funziona ✅
- JWT protegge gli endpoint ✅
- Utente vede solo le proprie note ✅
- Refresh token rinnova il JWT ✅
- Logout invalida il refresh token ✅

---

## 8.6 — Sicurezza: Checklist OWASP

### 🔧 PRATICA — Verifica sicurezza

Chiedi a Copilot:

```text
Analizza il codice di autenticazione del progetto e verifica che rispetti 
queste best practice di sicurezza OWASP:

1. JWT secret è abbastanza lungo (>= 32 caratteri)?
2. I token hanno scadenza ragionevole?
3. Il refresh token è salvato nel database e invalidato al logout?
4. Le callback OAuth validano il parametro state anti-CSRF?
5. Gli header di sicurezza sono impostati (helmet)?
6. Il rate limiting è applicato sugli endpoint auth?
7. La connection string del database non è esposta nell'output?

Per ogni punto, rispondi ✅ o ❌ con la correzione necessaria.
```

Se ci sono problemi, segui le correzioni suggerite.

> ⚠️ **Attenzione**: La sicurezza è l'area dove il review umano è più critico. Non fidarti ciecamente dell'IA su questioni di sicurezza — verifica sempre che JWT secret, gestione token e validazione input siano implementati correttamente.

---

## 8.7 — Commit e Prossimi Passi

```bash
git add .
git commit -m "feat: autenticazione OAuth 2.0 (Google + GitHub) con JWT e refresh token"
```

---

## Riepilogo

| Aspetto | Dettaglio |
|:--|:--|
| **Autenticazione** | OAuth 2.0 (Google + GitHub) |
| **Sessione** | JWT + Refresh Token |
| **Librerie** | Passport.js, jsonwebtoken |
| **Sicurezza** | Isolamento utente, scadenza token, CSRF protection |
| **File nuovi** | ~6 file |
| **Tempo** | ~60-90 minuti |

---

**→ Nel prossimo capitolo**: costruiamo il frontend! Creeremo un'applicazione React con login OAuth, rotte protette e una dashboard per gestire le note.
