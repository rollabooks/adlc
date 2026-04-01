## Lezioni Database
- Prisma Studio (npx prisma studio) è utile per debug rapido
- I test devono usare un database separato o fare transaction rollback
- Dopo ogni modifica allo schema, SEMPRE generare migrazione prima di testare
- Il singleton PrismaClient evita il "too many connections" in dev con nodemon