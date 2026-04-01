---
name: react-developer
description: Skill per sviluppo frontend React con Tailwind CSS.
---

# React Developer Skill

## Stack
- React 18+ con Vite
- Tailwind CSS 4
- React Router 6
- Axios per HTTP

## Struttura
src/
  components/ui/     ← Componenti riutilizzabili
  components/layout/ ← Header, Footer, Container
  pages/             ← Pagine (una per route)
  hooks/             ← Hook personalizzati
  context/           ← Context API per stato globale
  services/          ← Chiamate API (Axios)

## Convenzioni
- Componenti: PascalCase, functional only, un file per componente
- Hook: camelCase con prefisso "use"
- NON fare fetch nei componenti, usa hook personalizzati
- NON usare localStorage per token JWT
- Ogni pagina: loading state + error state + empty state