## ADR-01: Scelta ORM

### Contesto
Il backend richiede un ORM per PostgreSQL compatibile con Node.js.

### Opzioni
| Opzione | Pro | Contro |
|---------|-----|--------|
| **Prisma** | Type-safe, migrazioni auto, ottima DX | Meno flessibile per query complesse |
| **Drizzle** | Leggero, SQL-like, performante | Community più piccola, meno tutorial |
| **TypeORM** | Maturo, pattern Active Record | API verbose, manutenzione rallentata |

### Raccomandazione
Prisma — migliore per un progetto didattico con focus su produttività.

### Decisione
→ **[L'UMANO SCEGLIE QUI]**