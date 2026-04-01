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