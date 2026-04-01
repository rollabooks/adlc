## Vincoli (OBBLIGATORI)

- NON usare mai query SQL raw. Usa SEMPRE Prisma ORM.
- NON salvare mai password in chiaro. Usa bcrypt con salt rounds >= 12.
- NON esporre mai stack trace negli errori di produzione.
- NON usare `any` in TypeScript. Definisci sempre i tipi.
- NON installare dipendenze senza motivo documentato.