# Progetto: [Nome] Full-Stack

## Panoramica
[Descrizione in 3-4 frasi]

## Architettura
[Browser] → [Frontend :5173] → [Proxy /api] → [Backend :3000] → [PostgreSQL]

## Componenti

### Backend (./backend/)
- Contesto: ./backend/_CONTEXT.md
- Porta: 3000

### Frontend (./frontend/)
- Contesto: ./frontend/_CONTEXT.md
- Skill: ./frontend/SKILL.md
- Porta: 5173

### Mobile (./mobile/) — opzionale
- Contesto: ./mobile/_CONTEXT.md
- Skill: ./mobile/SKILL.md

## Contratto API
[Tabella endpoint condivisa tra tutti i componenti]

## Variabili d'Ambiente
### Backend: DATABASE_URL, JWT_SECRET, ...
### Frontend: VITE_API_URL

## Comandi
- Tutto: npm run dev (con concurrently)
- Backend: cd backend && npm run dev
- Frontend: cd frontend && npm run dev