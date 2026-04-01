## Comandi

- Avviare il server: `npm run dev`
- Eseguire i test: `npm test`
- Migrare il database: `npx prisma migrate dev`
- Generare il client Prisma: `npx prisma generate`
- Linting: `npm run lint`

## Workflow di Sviluppo

Quando implementi una nuova funzionalità:
1. Crea/modifica lo schema Prisma se serve
2. Genera la migrazione
3. Implementa service → controller → route (in quest'ordine)
4. Aggiungi test per il nuovo endpoint
5. Verifica che tutti i test passino
6. Aggiorna la documentazione Swagger