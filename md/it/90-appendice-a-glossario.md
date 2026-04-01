# Appendice A — Glossario

---

| Termine | Definizione | Primo uso |
|:--|:--|:--|
| **0-code** | Paradigma di sviluppo in cui il programmatore descrive cosa costruire e l'IA genera il codice. A differenza del no-code tradizionale, produce codice sorgente reale e modificabile. | Cap. 1 |
| **ADLC** | **Agent Development Life Cycle** — Ciclo di vita in 7 fasi per lo sviluppo con IA: Preparazione, Inquadramento, Definizione, Simulazione, Implementazione, Rilascio, Apprendimento. | Cap. 3 |
| **Agent Mode** | Modalità di GitHub Copilot in VS Code in cui l'IA può leggere file, eseguire comandi, creare file e navigare il progetto autonomamente. | Cap. 2 |
| **Agent Skill** | Competenza specializzata racchiusa in un file SKILL.md con metadati YAML. Caricata dall'IA quando il tipo di lavoro lo richiede (Progressive Disclosure). | Cap. 9 |
| **Allucinazione** | Generazione di informazioni false o inventate, presentate dal modello con apparente sicurezza. | Cap. 1 |
| **Claude Code** | Strumento CLI di Anthropic per lo sviluppo 0-code direttamente dal terminale. Alternativa a Copilot Agent Mode. | Cap. 2 |
| **PROGRESS.md** | File di memoria persistente tra sessioni. Diario del progetto che registra stato, decisioni, problemi risolti e prossimi passi. | Cap. 3, 10 |
| **Confidence Tagging** | Classificazione del codice generato per livello di rischio (🟢 LOW, 🟡 MEDIUM, 🔴 HIGH) per decidere l'intensità della revisione. | Cap. 14 |
| **Context Engineering** | Disciplina di progettazione delle informazioni fornite all'IA. Evoluzione del Prompt Engineering per progetti complessi e di lunga durata. | Cap. 3 |
| **_CONTEXT.md** | Documento di contesto del progetto che descrive scopo, architettura, convenzioni e vincoli. L'IA lo legge per generare codice coerente. | Cap. 3 |
| **CORS** | **Cross-Origin Resource Sharing** — Meccanismo di sicurezza del browser che blocca richieste tra domini diversi. Risolto con proxy (dev) o same-origin (prod). | Cap. 10 |
| **Deep Link** | URL con schema personalizzato (es. `notesapp://auth/callback`) che apre direttamente un'app mobile. Usato per il ritorno dal login OAuth. | Cap. 12 |
| **Dio** | Client HTTP per Dart/Flutter con supporto a interceptor, retry e cancellazione. Equivalente di Axios per Flutter. | Cap. 11 |
| **Express.js** | Framework web minimale per Node.js. Usato per costruire la REST API del progetto. | Cap. 6 |
| **Finestra di Contesto** | Quantità massima di informazioni (in token) che un LLM può elaborare in una singola richiesta. | Cap. 3 |
| **Flutter** | Framework di Google per la creazione di app mobile native (Android e iOS) da un unico codice Dart. | Cap. 11 |
| **GoRouter** | Libreria di routing dichiarativo per Flutter con supporto a redirect, deep link e navigazione protetta. | Cap. 11 |
| **Helmet.js** | Middleware Express che imposta header HTTP di sicurezza (CSP, HSTS, X-Frame-Options, ecc.). | Cap. 14 |
| **Hot Reload** | Funzionalità di Flutter che aggiorna l'interfaccia istantaneamente dopo una modifica al codice, senza riavviare l'app. | Cap. 11 |
| **httpOnly Cookie** | Cookie non accessibile da JavaScript (protezione XSS). Usato per salvare il JWT nel frontend web. | Cap. 8 |
| **JWT** | **JSON Web Token** — Token firmato che contiene l'identità dell'utente. Usato per autenticare le richieste API. | Cap. 8 |
| **LLM** | **Large Language Model** — Modello linguistico di grandi dimensioni. Il "motore" dietro Copilot e Claude. | Cap. 1 |
| **MCP** | **Model Context Protocol** — Standard per collegare l'IA a strumenti esterni (database, file system, API). | Cap. 7 |
| **Monorepo** | Struttura di progetto in cui backend, frontend e mobile risiedono nella stessa repository con contesti separati. | Cap. 10 |
| **MSW** | **Mock Service Worker** — Libreria per simulare risposte API nei test del frontend senza un backend reale. | Cap. 14 |
| **OAuth 2.0** | Protocollo di autenticazione delegata. L'utente fa login con Google/GitHub, l'app riceve un token senza gestire password. | Cap. 8 |
| **OWASP Top 10** | Lista delle 10 vulnerabilità di sicurezza più comuni nelle applicazioni web, pubblicata da OWASP. | Cap. 14 |
| **Passport.js** | Middleware di autenticazione per Express.js con strategie per OAuth, JWT, locale, ecc. | Cap. 8 |
| **Planner-Generator-Evaluator** | Pattern multi-agente in cui l'IA assume ruoli diversi: pianifica (analisi), genera (codice), valuta (revisione). | Cap. 10 |
| **Prisma** | ORM (Object-Relational Mapper) per Node.js/TypeScript. Traduce classi in tabelle SQL e fornisce un client tipizzato. | Cap. 7 |
| **Progressive Disclosure** | Caricamento incrementale delle informazioni: l'IA riceve solo il contesto necessario per il task corrente. | Cap. 9 |
| **Proof of Value** | Pattern di validazione: genera prima una parte piccola (un modello, un endpoint), verifica che sia corretta, poi procedi con il resto. | Cap. 5 |
| **Proxy Vite** | Configurazione di Vite che inoltra le chiamate `/api` dal frontend al backend durante lo sviluppo, evitando problemi CORS. | Cap. 9 |
| **Rate Limiting** | Limitazione del numero di richieste per IP/utente in un intervallo di tempo. Protezione contro abusi e brute force. | Cap. 14 |
| **Refresh Token** | Token a lunga durata (7 giorni) usato per ottenere nuovi access token senza ripetere il login. | Cap. 8 |
| **Riverpod** | Libreria di state management per Flutter. Provider reattivi con dependency injection. | Cap. 11 |
| **SKILL.md** | File che conferisce all'IA competenze specializzate per un dominio (React, Flutter, ecc.). Caricato on-demand. | Cap. 9 |
| **Swagger** | Strumento per documentazione e test interattivo di API REST. Genera una UI navigabile dagli endpoint. | Cap. 6 |
| **Token** | Unità di elaborazione dei modelli linguistici. Un frammento di parola (~3-4 caratteri in inglese). | Cap. 3 |
| **Vite** | Build tool moderno per progetti web. Veloce in sviluppo (HMR) e ottimizzato per la produzione. | Cap. 9 |
| **Zod** | Libreria di validazione per TypeScript/JavaScript. Definisce schemi e valida input con messaggi di errore chiari. | Cap. 6 |
| **0-Code** | Approccio allo sviluppo agentico dove l'operatore non scrive codice, ma definisce contesti, policy e vincoli in linguaggio naturale. | |
