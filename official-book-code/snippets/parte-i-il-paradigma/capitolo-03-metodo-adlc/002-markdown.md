## Struttura del Progetto

src/
  routes/          → Definizioni degli endpoint (solo routing)
  controllers/     → Logica dei controller (validazione, risposta)
  services/        → Business logic (interazione con DB)
  middleware/      → Auth, error handling, logging
  utils/           → Funzioni helper
prisma/
  schema.prisma    → Schema database
tests/
  unit/
  integration/