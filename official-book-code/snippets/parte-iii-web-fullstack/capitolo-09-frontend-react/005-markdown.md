# Progetto: Notes Frontend

## Scopo
Frontend React per l'applicazione Notes. Si connette al backend Notes API
(http://localhost:3000) per autenticazione e gestione note.

## Tecnologie
- Framework: React 18 con Vite
- Routing: React Router 6
- Styling: Tailwind CSS 4
- HTTP: Axios
- Stato: React Context (AuthContext)
- Build: Vite

## Backend
Il backend è un Express.js API disponibile su http://localhost:3000/api
- Autenticazione: OAuth 2.0 (Google + GitHub)
- Endpoint note: /api/notes (protetti da JWT)
- Endpoint auth: /api/auth/google, /api/auth/github, /api/auth/me, 
  /api/auth/refresh, /api/auth/logout
- Formato risposte: { success: boolean, data: T, error?: { message, code } }

## Flusso di Autenticazione

1. Utente clicca "Login con Google/GitHub"
2. Redirect al backend /api/auth/google (o /api/auth/github)
3. Backend gestisce OAuth e restituisce JWT come cookie httpOnly + 
   redirect al frontend
4. Frontend chiama /api/auth/me per ottenere il profilo utente
5. AuthContext salva l'utente in memoria
6. Tutte le successive chiamate API includono il cookie automaticamente

## Pagine

| Route | Pagina | Protetta |
|:--|:--|:--|
| / | LoginPage (se non autenticato) / redirect a /dashboard | No |
| /dashboard | DashboardPage (lista note + creazione) | Sì |
| /notes/:id | NoteDetailPage (dettaglio + modifica + elimina) | Sì |
| * | NotFoundPage | No |

## Vincoli
- NON usare localStorage per token JWT
- NON fare chiamate API direttamente nei componenti
- OGNI pagina protetta reindirizza a / se non autenticato
- Axios deve inviare cookies con withCredentials: true
- Gestire loading e errori per ogni operazione asincrona
- Il backend gira su porta 3000, il frontend su porta 5173 (default Vite)
- Configurare il proxy Vite per evitare problemi CORS in sviluppo

## Comandi
- Avviare: npm run dev
- Build: npm run build
- Preview: npm run preview