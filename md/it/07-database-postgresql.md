# Capitolo 7 — Progetto 4: Database e Modello Dati con PostgreSQL

## Cosa Costruirai

In questo capitolo trasformerai la Notes API del Capitolo 6 da storage in-memory a un **backend con database reale**:
- PostgreSQL come database relazionale
- Prisma come ORM (Object-Relational Mapper)
- Migrazioni automatiche per la gestione dello schema
- Primo contatto con MCP (Model Context Protocol) per l'integrazione database

**Tempo stimato**: 45-60 minuti  
**Prerequisito**: Progetto `notes-api` del Capitolo 6

---

> 💡 **Box Teoria — Database, ORM e Migrazioni.** In questo capitolo passerai da un semplice array in memoria a un **database relazionale** reale (PostgreSQL). I dati vengono organizzati in **tabelle** con colonne tipizzate (testo, numeri, date). Un **ORM** (Object-Relational Mapper) come Prisma traduce le operazioni nel linguaggio del database (SQL) al posto tuo: scrivi `prisma.note.create({title: "Ciao"})` e Prisma genera l'SQL corrispondente. Le **migrazioni** sono script che modificano la struttura del database in modo tracciabile — come un changelog per le tabelle. L'IA genererà tutto questo; il tuo compito è verificare che lo schema dei dati abbia senso.

> 📦 **Box Tooling — Stack scelto per questo esempio.**
> - **Database:** PostgreSQL 16
> - **ORM:** Prisma 6.x
> - **Migrazioni:** Prisma Migrate (integrate)
>
> **Alternative equivalenti:** MySQL/MariaDB con TypeORM, Python con SQLAlchemy, Go con GORM, MongoDB con Mongoose. Il **pattern** (database relazionale + ORM + migrazioni tracciabili) è universale. Se avessi scelto Drizzle al posto di Prisma, o SQLAlchemy al posto di entrambi, il metodo 0-code (Context Engineering + ADLC) sarebbe stato identico.

## 7.1 — Installare PostgreSQL

### 🔧 PRATICA — Setup PostgreSQL

**Opzione A — Docker (raccomandata):**
```bash
docker run --name notes-db -e POSTGRES_USER=notes -e POSTGRES_PASSWORD=notes123 -e POSTGRES_DB=notesdb -p 5432:5432 -d postgres:16
```

**Opzione B — Installazione locale (Windows):**
1. Scarica da [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
2. Installa con pgAdmin
3. Crea un database `notesdb`

**Opzione C — Cloud (Supabase/Neon):**
1. Vai su [supabase.com](https://supabase.com) o [neon.tech](https://neon.tech)
2. Crea un progetto gratuito
3. Copia la connection string

**Verifica connessione:**
```bash
# Se usi Docker:
docker exec -it notes-db psql -U notes -d notesdb -c "SELECT 1"
```

---

## 7.2 — Aggiornare il Contesto per il Database

> 📖 **Collegamento**: Stai per aggiungere Prisma come ORM — esattamente la decisione analizzata nell'esempio ADR-01 della Sezione 3.8. In un progetto autonomo, questa sarebbe una delle scelte da valutare nella Fase di Progettazione: l'IA ti presenterebbe Prisma, Drizzle e TypeORM con pro e contro, e tu sceglieresti. Qui la scelta è già fatta per ragioni didattiche.

### 🔧 PRATICA — Aggiorna il `_CONTEXT.md`

Aggiungi queste sezioni al `_CONTEXT.md` esistente del progetto `notes-api`:

```markdown
## Database

- RDBMS: PostgreSQL 16
- ORM: Prisma 6.x
- Connection string: definita in .env come DATABASE_URL
- Schema: prisma/schema.prisma

## Struttura Aggiornata

notes-api/
├── prisma/
│   ├── schema.prisma     ← Schema database
│   └── migrations/       ← Migrazioni automatiche (generate da Prisma)
├── src/
│   ├── services/
│   │   └── notesService.js  ← MODIFICATO: usa PrismaClient invece dell'array
│   ├── lib/
│   │   └── prisma.js        ← NUOVO: istanza singleton di PrismaClient
│   └── ... (resto invariato)
└── .env                      ← DATABASE_URL (NON committare)

## Schema Database (Prisma)

model Note {
  id        String   @id @default(uuid())
  title     String   @db.VarChar(200)
  content   String   @db.Text
  tags      String[] @default([])
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("notes")
}

## Vincoli Database (aggiungi ai vincoli esistenti)

- NON usare mai query SQL raw. USA SEMPRE Prisma Client.
- NON mettere la connection string nel codice. Usa .env.
- Le migrazioni DEVONO essere generate con `npx prisma migrate dev`.
- L'istanza PrismaClient DEVE essere un singleton (un'unica istanza per l'app).
- Usa @map per mappare camelCase JS → snake_case database.

## Comandi Database

- Generare migrazione: npx prisma migrate dev --name descrizione
- Applicare migrazioni: npx prisma migrate deploy
- Aprire Prisma Studio: npx prisma studio
- Reset database: npx prisma migrate reset
- Generare client: npx prisma generate
```

---

## 7.3 — Introduzione a MCP: L'IA Collegata al Database

Qui entra in gioco il **Model Context Protocol (MCP)** — il sistema che permette all'IA di interagire direttamente con strumenti esterni come database, file system e API.

### Cos'è MCP in 30 secondi

Normalmente, quando chiedi all'IA "mostrami le tabelle del database", lei non ha accesso al database. Può solo immaginare la risposta. Con MCP, l'IA può **effettivamente** interrogare il database, leggere i risultati reali e usarli per generare codice più accurato.

![Senza MCP vs. Con MCP](../../figures/it/03-mcp-confronto.png)

### 🔧 PRATICA — Configurare MCP Server PostgreSQL (opzionale ma consigliato)

Se usi Copilot in VS Code, puoi configurare un server MCP per PostgreSQL nella configurazione utente o workspace. Questo permite all'IA di interrogare il database in tempo reale.

Crea il file `.vscode/mcp.json` nel tuo progetto:

```json
{
  "servers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://notes:notes123@localhost:5432/notesdb"
      }
    }
  }
}
```

> 💡 **Suggerimento**: Se usi Claude Code, MCP è supportato nativamente. Se usi Copilot, il supporto MCP dipende dalla versione. Anche senza MCP, il progetto funziona perfettamente — l'IA semplicemente non potrà fare query live al database.

> 📖 **Approfondimento**: MCP è lo standard aperto di Anthropic per connettere modelli IA a strumenti esterni. Funziona come USB-C: un protocollo universale per qualsiasi connessione. I server MCP sono microservizi che espongono **Tools** (azioni), **Resources** (dati in sola lettura) e **Prompts** (template). Il server PostgreSQL espone tool per eseguire query e resource per leggere lo schema.

---

## 7.4 — Migrazione da In-Memory a PostgreSQL

### 🔧 PRATICA — Installazione Prisma e migrazione

In Copilot Agent Mode:

```text
Rileggi il _CONTEXT.md aggiornato. Il progetto Notes API deve migrare
da storage in-memory a PostgreSQL con Prisma.

Procedi così:
1. Installa Prisma come dipendenza
2. Inizializza Prisma con npx prisma init
3. Crea lo schema Prisma secondo il _CONTEXT.md
4. Crea il file .env con DATABASE_URL
5. Genera la migrazione iniziale
6. Crea src/lib/prisma.js (singleton PrismaClient)
7. Riscrivi src/services/notesService.js per usare Prisma
8. Aggiorna i test per usare un database di test
9. Verifica che tutti gli endpoint funzionino
```

L'IA eseguirà una serie di operazioni:
1. `npm install prisma @prisma/client`
2. `npx prisma init`
3. Creerà/modificherà lo schema
4. Eseguirà `npx prisma migrate dev --name init`
5. Riscriverà il service layer

### Cosa cambia nel codice

**Prima (in-memory):**
```javascript
// notesService.js - vecchia versione
let notes = [];

export function getAllNotes() {
  return notes;
}
```

**Dopo (PostgreSQL):**
```javascript
// notesService.js - nuova versione
import prisma from '../lib/prisma.js';

export async function getAllNotes() {
  return await prisma.note.findMany({
    orderBy: { createdAt: 'desc' }
  });
}
```

> Nota come il cambio è isolato nel service layer. I controller, le route e il middleware restano identici. Questo è il vantaggio dell'architettura a layer definita nel `_CONTEXT.md`.

---

## 7.5 — Verifica e Test

### 🔧 PRATICA — Test del database

```bash
# Avvia il server
npm run dev

# Crea una nota (ora salvata nel database!)
curl -X POST http://localhost:3000/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "Nota nel database", "content": "Questa è persistente!", "tags": ["postgres"]}'

# Riavvia il server e verifica che la nota sia ancora lì
# (Ctrl+C per fermare, poi npm run dev)
curl http://localhost:3000/api/notes
```

La nota è ancora lì dopo il riavvio! Lo storage in-memory perdeva tutto.

### 🔧 PRATICA — Prisma Studio

```bash
npx prisma studio
```

Si apre un'interfaccia web su `http://localhost:5555` dove puoi navigare visivamente il database, vedere le note, modificare i dati. È un ottimo strumento per verificare che tutto funzioni.

### 🔧 PRATICA — Test automatici

```bash
npm test
```

> ⚠️ **Attenzione**: I test devono usare un database separato o fare cleanup dopo ogni test. Verifica che l'IA abbia configurato questo correttamente nel file di setup dei test. Se i test scrivono nel database di sviluppo, chiedi a Copilot di correggere.

### 🎯 CHECKPOINT
- Le note persistono dopo il riavvio del server ✅
- Prisma Studio mostra i dati ✅
- Tutti gli endpoint funzionano con PostgreSQL ✅
- Test passano con database di test ✅

---

## 7.6 — Evolvere lo Schema

Il vero potere di Prisma emerge quando devi cambiare il modello dati.

### 🔧 PRATICA — Aggiungere un campo

```text
Aggiungi un campo "pinned" (boolean, default false) al modello Note.
Questo campo permette di "fissare" una nota in cima alla lista.
Aggiorna lo schema Prisma, genera la migrazione, aggiorna il service 
per ordinare le note pinnate prima, e aggiungi il supporto nell'endpoint 
PUT per modificare il pinned status.
Aggiorna i test.
```

L'IA:
1. Modificherà `prisma/schema.prisma`
2. Eseguirà `npx prisma migrate dev --name add-pinned`
3. Aggiornerà il service, il controller e i test

Tutto senza toccare una riga di codice a mano.

---

## 7.7 — Lezioni Apprese

### Aggiorna il `_CONTEXT.md`

```markdown
## Lezioni Database
- Prisma Studio (npx prisma studio) è utile per debug rapido
- I test devono usare un database separato o fare transaction rollback
- Dopo ogni modifica allo schema, SEMPRE generare migrazione prima di testare
- Il singleton PrismaClient evita il "too many connections" in dev con nodemon
```

---

## Riepilogo

| Aspetto | Dettaglio |
|:--|:--|
| **Database** | PostgreSQL 16 |
| **ORM** | Prisma 6 |
| **Migrazione** | Da in-memory a database reale |
| **MCP** | Server PostgreSQL configurato (opzionale) |
| **File modificati** | ~3-4 file, ~2 nuovi file |
| **Tempo** | ~45-60 minuti |

---

**→ Nel prossimo capitolo**: aggiungiamo autenticazione. Implementeremo OAuth 2.0 con Google e GitHub, JWT, sessioni e middleware di protezione degli endpoint.
