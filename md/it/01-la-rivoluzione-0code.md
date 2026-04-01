# Capitolo 1 — La Rivoluzione 0-Code: Vederla in Azione

## Cosa Imparerai

Alla fine di questo capitolo saprai:
- Come si presenta una sessione di lavoro in 0-code (dal vivo)
- Perché il contesto è tutto e come cambia i risultati
- Cosa costruirai con questo libro (anteprima dei 9 progetti)

> 📖 Se non hai ancora letto l'[Introduzione](00-introduzione.md), fallo ora. Spiega il framework ADLC, il confronto con l'SDLC tradizionale, e le tre competenze fondamentali (Context Engineering, Risk Design, Confidence Tagging) su cui si basa tutto il libro.

---

## 1.1 — Una Sessione di Lavoro in 0-Code: Dal Vivo

La teoria la conosci dall'Introduzione. Ora vediamo come funziona **concretamente** — che aspetto ha una sessione di lavoro in 0-code, cosa appare sullo schermo, cosa fai tu e cosa fa l'IA.

### Il setup: 30 secondi

Apri VS Code. Apri una cartella vuota. Apri la chat di Copilot in Agent Mode. Scrivi:

```text
Crea un'applicazione Python che converte temperature tra Celsius, 
Fahrenheit e Kelvin. L'utente sceglie la conversione da un menu 
interattivo nel terminale. Aggiungi un file di test con pytest.
```

### Cosa succede nei 60 secondi successivi

Copilot in Agent Mode:
1. **Crea** il file `converter.py` con le funzioni di conversione
2. **Crea** il file `test_converter.py` con i test unitari
3. **Esegue** `pytest` nel terminale integrato
4. **Legge** l'output: 6 test passati su 6
5. **Ti notifica**: "Ho creato i file e i test passano tutti. Vuoi che aggiunga qualcosa?"

Tu hai scritto 3 righe di istruzioni. L'IA ha generato ~80 righe di codice funzionante e testato.

Ma ecco il punto: il codice è **generico**. Funziona, ma non segue una struttura specifica, non ha gestione degli errori sofisticata, non ha documentazione interna.

### Lo stesso task, con contesto

Ora immagina di scrivere prima un file `_CONTEXT.md`:

```markdown
# Progetto: Temperature Converter

## Scopo
CLI tool per conversione temperature con focus su precisione scientifica.

## Vincoli
- Kelvin non può essere negativo (0 K = zero assoluto)
- Arrotondamento sempre a 2 decimali
- Messaggi di errore in italiano
- Naming: snake_case per tutto

## Struttura
converter/
├── main.py          ← Entry point con menu
├── conversions.py   ← Funzioni pure di conversione
├── validators.py    ← Validazione input
└── tests/
    ├── test_conversions.py
    └── test_validators.py
```

E poi scrivi a Copilot:

```text
Leggi il _CONTEXT.md e implementa l'applicazione completa 
seguendo tutte le specifiche.
```

Il risultato è **radicalmente diverso**: codice separato in moduli, validazione dello zero assoluto, test specifici per i casi limite, messaggi in italiano, struttura pulita.

**Stesse 3 righe di richiesta. Risultati incomparabili.** La variabile che cambia è il contesto.

---

## 1.2 — Il Contesto è Tutto

Questo è il principio più importante dell'intero libro, e merita di essere cristallizzato con un esempio concreto della differenza.

**Richiesta vaga:**
```text
Crea un'API per gestire gli utenti
```

**Risultato**: codice generico, probabilmente senza validazione, senza autenticazione, con naming inconsistente.

**Richiesta con contesto:**
```text
Crea un'API REST con Express.js per la gestione utenti. 
Struttura: src/routes/, src/controllers/, src/models/.
Database: PostgreSQL con Prisma ORM.
Endpoint: GET /users, GET /users/:id, POST /users, PUT /users/:id, DELETE /users/:id.
Validazione input con Zod.
Risposte JSON standard: { success: boolean, data: T, error?: string }.
Gestione errori centralizzata con middleware.
```

**Risultato**: codice strutturato, validato, con pattern consistenti e pronto per la produzione.

La differenza non è nell'IA. È nel contesto. Nel Capitolo 3 imparerai a scrivere file `_CONTEXT.md` professionali; nel Capitolo 4 inizierai a costruire il tuo primo progetto reale.

> ⚠️ **Una nota sulle aspettative.** Questo libro non richiede di saper programmare, ma richiede **curiosità e disponibilità ad apprendere concetti nuovi**. A partire dal Capitolo 6 incontrerai termini come API, middleware, database, autenticazione, token JWT. L'IA scriverà tutto il codice, ma il tuo ruolo di *architetto di contesto* richiede di comprendere *cosa* stai chiedendo di costruire — non *come* scriverlo. Nell'Introduzione trovi un "Crash Course" con i concetti fondamentali, e ogni capitolo avanzato include un "Box Teoria" con le spiegazioni necessarie. Se un termine ti è oscuro, consulta il Glossario (Appendice A).

---

## 1.3 — Cosa Costruirai con Questo Libro

Questo libro è strutturato come una **progressione di progetti reali**, ognuno più complesso del precedente, ognuno che costruisce sulle competenze acquisite nel precedente.

### Progetto 1 — Hello World (Capitolo 4)
Il tuo primo programma generato interamente dall'IA. Imparerai a formulare richieste, leggere l'output e iterare.

### Progetto 2 — CLI Tool (Capitolo 5)
Un'applicazione da riga di comando completa: parsing CSV/JSON, argomenti, test automatici. Il tuo primo `_CONTEXT.md` strutturato.

### Progetto 3 — REST API (Capitolo 6)
Il tuo primo server web con Express.js: endpoint CRUD, validazione, documentazione Swagger.

### Progetti 4-7 — Applicazione Web Full-Stack con OAuth 2.0 (Capitoli 7-10)
Il cuore del libro. Costruirai:
- **Progetto 4** (Cap. 7): Backend Node.js/Express con PostgreSQL e Prisma
- **Progetto 5** (Cap. 8): Autenticazione OAuth 2.0 (Google/GitHub) con JWT
- **Progetto 6** (Cap. 9): Frontend React con rotte protette e primo SKILL.md
- **Progetto 7** (Cap. 10): Integrazione end-to-end e dashboard CRUD completa

### Progetti 8-9 — App Mobile Flutter (Capitoli 11-12)
- **Progetto 8** (Cap. 11): Setup Flutter, prima app mobile e SKILL.md Flutter
- **Progetto 9** (Cap. 12): Login OAuth da mobile, CRUD sincronizzato, deep link

### Progetto finale — Deploy Completo (Capitoli 13-15)
Tutto in produzione:
- Backend su cloud (Railway/Render)
- Frontend su Vercel
- Database PostgreSQL gestito
- App mobile su Play Store
- CI/CD automatizzato

---

## 1.4 — Requisiti per Seguire Questo Libro

### Cosa devi sapere
- Usare un computer (Windows, macOS o Linux)
- Concetti base di come funziona un'applicazione (anche solo come utente)
- L'inglese tecnico di base (i nomi dei comandi e delle tecnologie sono in inglese)

### Cosa NON devi sapere
- Non devi saper programmare in Python, JavaScript, Dart o qualsiasi linguaggio
- Non devi aver mai usato React, Node.js, Flutter o PostgreSQL
- Non devi aver mai usato un terminale o la riga di comando
- Non devi aver mai usato Git (ma lo imparerai strada facendo)

### Cosa ti serve
- Un computer con Windows 10/11, macOS 10.15+ o Linux
- Una connessione internet stabile
- Un account GitHub (gratuito)
- Un abbonamento a GitHub Copilot OPPURE accesso a Claude Code
- VS Code installato (gratuito)

> 💰 **Quanto costa?** GitHub Copilot Individual costa 10$/mese. Claude Code funziona a consumo tramite API Anthropic. Il costo per completare tutti i progetti del libro è paragonabile a quello di un corso online (~20-50€). Nel Capitolo 2 vedremo le opzioni gratuite disponibili e come minimizzare la spesa.

---

## 1.5 — La Promessa di Questo Libro

Alla fine di questa lettura avrai:

1. **Costruito** un'applicazione web completa con backend, frontend e autenticazione OAuth 2.0
2. **Costruito** un'app mobile Flutter connessa al tuo backend
3. **Deployato** tutto in produzione — accessibile da chiunque nel mondo
4. **Senza aver scritto manualmente** una singola riga di codice

E soprattutto avrai acquisito un **metodo** — il Context Engineering e l'ADLC — che ti permetterà di costruire qualsiasi altra applicazione con lo stesso approccio.

Non è magia. È ingegneria del contesto. E inizia nel prossimo capitolo, con l'installazione del tuo ambiente di sviluppo.

---

> *"Nell'era dello sviluppo 0-code, le parole umane perdono il loro ruolo di veicolo comunicativo informale e assumono il peso e le conseguenze di direttive in un linguaggio di programmazione procedurale ad alto livello."*

---

**→ Nel prossimo capitolo**: installeremo VS Code, configureremo GitHub Copilot e genereremo il nostro primo pezzo di codice.
