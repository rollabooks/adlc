## Convenzioni

- Naming: camelCase per variabili e funzioni, PascalCase per classi e tipi
- Risposte API: sempre nel formato { success: boolean, data: T, error?: string }
- Validazione: usa Zod per la validazione degli input di tutti gli endpoint
- Errori: gestiti centralmente tramite middleware errorHandler
- Async: usa async/await, mai callback
- Import: usa ESModules (import/export), mai require()