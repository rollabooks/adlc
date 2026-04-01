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