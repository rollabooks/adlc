# Capitolo 9 — Progetto 6: Frontend Web con React e Autenticazione

## Cosa Costruirai

Un'applicazione frontend React completa che:
- Si collega al backend Notes API
- Permette login con Google e GitHub
- Mostra una dashboard con le note dell'utente
- Supporta operazioni CRUD complete
- Ha rotte protette (nessun accesso senza autenticazione)
- Usa un design system coerente

**Tempo stimato**: 60-90 minuti  
**Prerequisito**: Backend Notes API con autenticazione (Capitoli 6-8)

> 📦 **Box Tooling — Stack scelto per questo esempio.**
> - **Framework:** React 19 con Vite
> - **Styling:** Tailwind CSS 4
> - **Routing:** React Router 7
> - **HTTP Client:** Axios
>
> **Alternative equivalenti:** Vue.js/Nuxt, Svelte/SvelteKit, Angular, Next.js, Astro. Il **pattern** (componenti, routing protetto, gestione stato, chiamate API) è lo stesso in qualunque framework frontend moderno. Il file `SKILL.md` che creerai in questo capitolo funziona con qualsiasi stack — basta adattare le convenzioni.

---

## 9.1 — Setup del Progetto Frontend

### 🔧 PRATICA — Creare il progetto React

Apri un terminale NELLA STESSA directory dove hai il backend, e crea il frontend come progetto separato:

```bash
cd ..  # Torna alla directory padre di notes-api
npm create vite@latest notes-frontend -- --template react
cd notes-frontend
npm install
```

Ora hai due progetti affiancati:
```text
workspace/
├── notes-api/          ← Backend (Capitoli 6-8)
└── notes-frontend/     ← Frontend (questo capitolo)
```

### 🔧 PRATICA — Installare le dipendenze

```bash
npm install react-router-dom axios
npm install -D tailwindcss @tailwindcss/vite
```

---

## 9.2 — Agent Skill per il Frontend

Questo è il momento di introdurre il tuo primo **SKILL.md** — un documento che conferisce all'IA competenze specializzate per il frontend.

### 🔧 PRATICA — Crea il file `SKILL.md`

```markdown
---
name: react-frontend-developer
description: Skill per lo sviluppo di interfacce React con Tailwind CSS, 
  autenticazione OAuth e gestione stato con Context API.
---

# React Frontend Developer Skill

## Principi di Design

- Mobile-first: progetta prima per mobile, poi scala per desktop
- Componenti piccoli: ogni componente fa UNA cosa
- Nessuna logica di business nei componenti UI: usa hook personalizzati
- Accessibilità: tutti gli elementi interattivi devono essere accessibili da tastiera

## Stack Tecnologico

- React 18+ con Vite
- React Router 6 per la navigazione
- Tailwind CSS 4 per lo styling (utility-first)
- Axios per le chiamate API
- React Context per lo stato globale (auth)

## Struttura Componenti

src/
  components/
    ui/                  ← Componenti riutilizzabili (Button, Input, Card, Modal)
    layout/              ← Header, Footer, Sidebar, PageContainer
    notes/               ← NoteCard, NoteForm, NoteList, NoteDetail
    auth/                ← LoginButton, ProtectedRoute, UserMenu
  pages/
    LoginPage.jsx
    DashboardPage.jsx
    NoteDetailPage.jsx
    NotFoundPage.jsx
  hooks/
    useAuth.js           ← Hook per autenticazione
    useNotes.js          ← Hook per CRUD note
    useApi.js            ← Hook per chiamate API con error handling
  context/
    AuthContext.jsx      ← Provider autenticazione globale
  services/
    api.js               ← Istanza Axios configurata (base URL, interceptors)
  App.jsx
  main.jsx

## Convenzioni React

- Componenti: PascalCase, un file per componente
- Hook: camelCase con prefisso "use"
- Event handler: prefisso "handle" (handleSubmit, handleDelete)
- Props: destructuring nei parametri della funzione
- State: useState per stato locale, Context per stato globale
- Effetti: useEffect con dependency array esplicito, MAI vuoto senza motivo

## Vincoli

- NON usare class component. Solo functional component con hooks.
- NON fare fetch/axios nei componenti. Usa hook personalizzati.
- NON salvare il JWT in localStorage (vulnerabile a XSS). Usa httpOnly cookie 
  o in-memory con Context.
- NON hardcodare l'URL del backend. Usa VITE_API_URL da .env.
- Ogni pagina deve avere un loading state e un error state.
- I form devono avere validazione client-side prima del submit.

## Stile e Design

- Usa Tailwind CSS utility classes, non CSS custom
- Palette colori: slate per neutri, indigo come primario, red per errori, 
  green per successi
- Bordi arrotondati: rounded-lg standard
- Ombre: shadow-sm per cards, shadow-md per modali
- Spacing: p-4 per padding standard, gap-4 per grid/flexbox
- Tipografia: font-sans, text-sm per body, text-xl per titoli sezione
```

> 📖 **Approfondimento**: Il file `SKILL.md` funziona come il `_CONTEXT.md` ma è **specializzato**. Viene caricato dall'IA solo quando il tipo di lavoro lo richiede (Progressive Disclosure). Questo evita di sovraccaricare il contesto con informazioni sul frontend quando stai lavorando sul backend.

---

## 9.3 — Il Contesto del Frontend

### 🔧 PRATICA — Crea `_CONTEXT.md` nel progetto frontend

```markdown
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
```

---

## 9.4 — Generazione del Frontend

### 🔧 PRATICA — Generare l'intera applicazione

In Copilot Agent Mode:

```text
Leggi il _CONTEXT.md e il SKILL.md. Implementa l'intero frontend React.

Ordine di implementazione:
1. Configura Tailwind CSS con Vite
2. Crea src/services/api.js (istanza Axios configurata)
3. Crea src/context/AuthContext.jsx (provider + useAuth hook)
4. Crea i componenti UI base (Button, Input, Card)
5. Crea il layout (Header con UserMenu, PageContainer)
6. Crea LoginPage con bottoni Google e GitHub
7. Crea il ProtectedRoute component
8. Crea src/hooks/useNotes.js (hook CRUD per le note)
9. Crea DashboardPage (lista note + form creazione)
10. Crea componenti notes (NoteCard, NoteForm)
11. Crea NoteDetailPage (visualizzazione + modifica + elimina)
12. Configura React Router in App.jsx
13. Configura il proxy Vite per il backend
14. Crea .env con VITE_API_URL
```

---

## 9.5 — Configurazione del Proxy Vite

Per evitare problemi CORS durante lo sviluppo, il frontend deve proxyare le chiamate API al backend.

Nella configurazione Vite, l'IA dovrebbe aver generato qualcosa come:

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        secure: false
      }
    }
  }
});
```

> 💡 **Suggerimento**: Con questo proxy, nel frontend puoi chiamare `/api/notes` invece di `http://localhost:3000/api/notes`. Vite inoltra automaticamente le richieste al backend.

---

## 9.6 — Test dell'Applicazione

### 🔧 PRATICA — Avvio

Apri **due** terminali:

**Terminale 1 — Backend:**
```bash
cd notes-api
npm run dev
```

**Terminale 2 — Frontend:**
```bash
cd notes-frontend
npm run dev
```

Apri nel browser: `http://localhost:5173`

### Checklist di verifica

| Funzionalità | Test |
|:--|:--|
| **Login Page** | Vedi la pagina con i bottoni Google e GitHub |
| **OAuth Google** | Clicca → redirect a Google → login → redirect alla dashboard |
| **Dashboard** | Vedi la lista note (vuota all'inizio) |
| **Crea nota** | Compila il form → la nota appare nella lista |
| **Dettaglio** | Clicca una nota → pagina di dettaglio |
| **Modifica** | Modifica titolo/contenuto → salva → verifica |
| **Elimina** | Clicca elimina → conferma → la nota scompare |
| **Logout** | Clicca logout → redirect alla login page |
| **Protezione route** | Vai direttamente a /dashboard senza login → redirect a / |
| **User Menu** | Vedi nome e avatar dell'utente nel header |

### 🎯 CHECKPOINT
Se riesci a fare login, creare una nota, modificarla ed eliminarla, il frontend è completo.

---

## 9.7 — Iterazioni di Design

### 🔧 PRATICA — Migliorare l'aspetto

```text
La dashboard funziona ma è un po' spartana. Migliora il design:
1. Aggiungi un componente EmptyState quando non ci sono note 
   (icona + messaggio + bottone "Crea la tua prima nota")
2. Aggiungi animazioni di transizione sulle card (hover: scale-[1.02])
3. Mostra i tag come badge colorati sulle NoteCard
4. Aggiungi un campo di ricerca nella dashboard che filtra le note per titolo
5. Mostra la data di creazione formattata in modo relativo 
   ("2 ore fa", "ieri", etc.)
```

### 🔧 PRATICA — Responsive design

```text
Verifica che l'interfaccia sia responsive:
1. La lista note deve essere una griglia: 1 colonna su mobile, 
   2 su tablet, 3 su desktop
2. Il header deve collassare in un menu hamburger su mobile
3. I form devono essere full-width su mobile
4. I bottoni devono avere padding maggiore su mobile (touch target >= 44px)
```

---

## 9.8 — Aggiornamento Backend per il Frontend

Quando lavori in full-stack, a volte il frontend rivela la necessità di modifiche al backend. Per esempio:

```text
Il frontend ha bisogno di un endpoint di ricerca note. 
Torna al progetto notes-api e aggiungi:

GET /api/notes/search?q=termine
- Cerca nel titolo e nel contenuto
- Case-insensitive
- Restituisce le note dell'utente autenticato che matchano
- Aggiorna anche i test del backend
```

> Questo salto tra frontend e backend è normale nello sviluppo full-stack. Il `_CONTEXT.md` di ogni progetto tiene le cose ordinate.

---

## 9.9 — Commit

```bash
git init
git add .
git commit -m "feat: frontend React con login OAuth, dashboard note e CRUD completo"
```

---

## Riepilogo

| Aspetto | Dettaglio |
|:--|:--|
| **Framework** | React 18 + Vite |
| **Styling** | Tailwind CSS 4 |
| **Auth** | OAuth 2.0 via backend proxy |
| **State** | React Context (AuthContext) |
| **Pagine** | Login, Dashboard, NoteDetail, 404 |
| **Primo SKILL.md** | react-frontend-developer |
| **Tempo** | ~60-90 minuti |

---

**→ Nel prossimo capitolo**: l'integrazione finale. Collegheremo tutti i pezzi, configureremo la comunicazione end-to-end e affronteremo le sfide del full-stack: sincronizzazione stato, gestione errori cross-layer e sviluppo multi-agente.
