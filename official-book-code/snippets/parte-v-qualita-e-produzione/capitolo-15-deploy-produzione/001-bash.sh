cd backend

# Aggiorna .env con la connection string di Neon
# DATABASE_URL=postgresql://user:pass@ep-xxx.region.neon.tech/neondb?sslmode=require

# Esegui le migrazioni sul database di produzione
npx prisma migrate deploy

# Verifica
npx prisma studio