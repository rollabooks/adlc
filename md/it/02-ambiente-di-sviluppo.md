# Capitolo 2 — L'Ambiente di Sviluppo: VS Code, Copilot e Claude Code

## Cosa Imparerai

Alla fine di questo capitolo avrai:
- VS Code installato e configurato per lo sviluppo 0-code
- GitHub Copilot attivo e funzionante (oppure Claude Code)
- Generato il tuo primo frammento di codice con l'IA
- Compreso le tre modalità di interazione con l'IA in VS Code

---

## 2.1 — Installazione di Visual Studio Code

Visual Studio Code (VS Code) è l'editor di codice gratuito di Microsoft. È lo strumento standard dell'industria e, soprattutto, è l'ambiente dove GitHub Copilot e Claude Code operano al massimo delle loro capacità.

> ⚙️ **Nota di versione** — Le istruzioni di questo capitolo sono verificate con VS Code 1.96+, GitHub Copilot Chat v0.25+ e Claude Code v1.x (Q1 2025). Le interfacce di questi strumenti evolvono rapidamente. Se un pulsante o un menu non corrisponde esattamente a quanto descritto, consulta il repository companion del libro per le istruzioni aggiornate: i concetti e il metodo restano identici.

### 🔧 PRATICA — Installazione VS Code

**Windows:**
1. Vai su [code.visualstudio.com](https://code.visualstudio.com)
2. Scarica l'installer per Windows
3. Esegui l'installer. Seleziona tutte le opzioni di integrazione:
   - ✅ Aggiungi "Apri con Code" al menu contestuale
   - ✅ Aggiungi al PATH

**macOS:**
```bash
brew install --cask visual-studio-code
```

**Linux (Ubuntu/Debian):**
```bash
sudo snap install code --classic
```

### 🎯 CHECKPOINT
Apri VS Code. Dovresti vedere la schermata di benvenuto. Se sì, procedi.

---

## 2.2 — Le Estensioni Essenziali

VS Code da solo è un editor di testo avanzato. La sua potenza viene dalle estensioni. Per lo sviluppo 0-code, ne servono poche ma fondamentali.

### 🔧 PRATICA — Installazione estensioni

Apri il pannello estensioni (`Ctrl+Shift+X` su Windows, `Cmd+Shift+X` su macOS) e installa:

| Estensione | ID | A cosa serve |
|:--|:--|:--|
| **GitHub Copilot** | `GitHub.copilot` | Il motore IA principale |
| **GitHub Copilot Chat** | `GitHub.copilot-chat` | Chat e agent mode |
| **ESLint** | `dbaeumer.vscode-eslint` | Linting JavaScript/TypeScript |
| **Prettier** | `esbenp.prettier-vscode` | Formattazione automatica |
| **Thunder Client** | `rangav.vscode-thunder-client` | Test API REST (simile a Postman) |
| **Flutter** | `Dart-Code.flutter` | Sviluppo Flutter (Part IV) |
| **Prisma** | `Prisma.prisma` | Evidenziazione schema database |

> 💡 **Suggerimento**: Non installare subito Flutter e Prisma. Li installerai quando arriverai ai capitoli corrispondenti. Per ora ti bastano Copilot e le estensioni JavaScript.

---

## 2.3 — Configurazione di GitHub Copilot

GitHub Copilot è lo strumento IA di GitHub (Microsoft) integrato in VS Code. Utilizza modelli come GPT-4o e Claude Sonnet per generare codice, rispondere a domande e modificare file.

### 🔧 PRATICA — Attivazione Copilot

1. **Account GitHub**: Se non ne hai uno, crealo su [github.com](https://github.com). È gratuito.

2. **Abbonamento Copilot**: Vai su [github.com/features/copilot](https://github.com/features/copilot).
   - **Copilot Free**: Limitato (2000 completamenti + 50 messaggi chat/mese) ma sufficiente per i primi 3-4 capitoli
   - **Copilot Individual**: 10$/mese — sufficiente per l'intero libro
   - **Copilot Pro**: 39$/mese — Agent Mode illimitato (raccomandato per lavorare senza restrizioni)

> 💰 **Quanto costa completare il libro?** Con Copilot Individual (10$/mese), il costo totale per seguire tutti i 16 capitoli è di circa 20-30€, a seconda del tuo ritmo. Con Claude Code (pay-per-use), il costo è paragonabile: circa 15-40€ per i token consumati durante tutto il percorso. In entrambi i casi, è meno di un singolo corso online o di un'ora di consulenza con uno sviluppatore.
   
3. **Login in VS Code**: 
   - Apri VS Code
   - Cerca "GitHub: Sign In" nella Command Palette (`Ctrl+Shift+P`)
   - Autorizza l'accesso con il tuo account GitHub

4. **Verifica**: Apri un file `.py` o `.js` e inizia a digitare. Se vedi suggerimenti automatici in grigio, Copilot è attivo.

### Le tre modalità di Copilot

Copilot in VS Code ha tre modalità di interazione, ognuna con un livello di autonomia crescente:

| Modalità | Come si attiva | Cosa fa | Quando usarla |
|:--|:--|:--|:--|
| **Completamento inline** | Automatico mentre scrivi | Suggerisce completamenti riga per riga | Quando stai scrivendo codice manualmente |
| **Chat** | Pannello laterale (icona chat) | Conversazione libera, genera file, spiega codice | Per chiedere spiegazioni, generare snippet |
| **Agent Mode** | Nella chat, seleziona "Agent" | Autonomia completa: crea file, esegue comandi, itera | **Questa è la modalità 0-code** |

> ⚙️ **Nota di versione** — L'interfaccia della chat di Copilot (posizione dei pulsanti, scorciatoie, nome della modalità Agent) cambia con gli aggiornamenti di VS Code. Se non trovi un elemento, cerca nella Command Palette (`Ctrl+Shift+P`): digita "Copilot" per vedere tutte le opzioni disponibili. Quello che conta è la *funzionalità*: la modalità che consente a Copilot di creare file, eseguire comandi e iterare autonomamente.

> ⚠️ **Attenzione**: L'Agent Mode è la modalità che userai per il 90% del lavoro in questo libro. Copilot in Agent Mode può creare file, eseguire comandi nel terminale, installare pacchetti e iterare autonomamente sui risultati. È l'equivalente di avere un junior developer che lavora al tuo fianco.

### 🔧 PRATICA — Selezionare il modello

In Agent Mode puoi scegliere il modello IA da utilizzare. Cerca il selettore modello nell'interfaccia della chat e scegli il modello più avanzato disponibile.

> ⚙️ **Nota di versione** — I modelli disponibili cambiano frequentemente. Al momento della stesura, i modelli raccomandati sono Claude Sonnet 4 (migliore aderenza al contesto), GPT-4o (veloce e versatile) e Gemini 2.5 Pro (ottima finestra di contesto). La regola generale: scegli il modello più recente della famiglia Claude o GPT. Tutti i concetti e le tecniche del libro funzionano con qualsiasi modello sufficientemente avanzato — non sei vincolato a uno specifico.

---

## 2.4 — Alternativa: Claude Code da Terminale

Se preferisci lavorare da terminale, o se hai bisogno di un'autonomia ancora maggiore, puoi usare **Claude Code** — lo strumento a riga di comando di Anthropic.

### 🔧 PRATICA — Installazione Claude Code

```bash
# Richiede Node.js 18+
npm install -g @anthropic-ai/claude-code

# Primo avvio e autenticazione
claude

# Navigare nella cartella del progetto e avviare
cd mio-progetto
claude
```

Claude Code opera direttamente nel file system: legge file, li modifica, esegue comandi e itera — tutto dal terminale. È particolarmente efficace per:
- Progetti complessi a lunga durata
- Refactoring di codebase esistenti
- Operazioni su molti file contemporaneamente

### Copilot vs Claude Code: quale usare?

| Aspetto | Copilot Agent Mode | Claude Code |
|:--|:--|:--|
| **Interfaccia** | GUI integrata in VS Code | Terminale |
| **Curva di apprendimento** | Bassa | Media |
| **Autonomia** | Alta | Molto alta |
| **Ideale per** | Progetti nuovi, lavoro visuale | Progetti complessi, multi-file |
| **Costo** | 10$/mese (Copilot Individual) | Pay-per-use (~0.003-0.015$/richiesta) |

> 💰 **Confronto costi per il libro completo**: Con Copilot Individual a 10$/mese impiegando 2-3 mesi = ~20-30€. Con Claude Code a consumo, per tutti i progetti del libro = ~15-40€ a seconda della complessità delle iterazioni. Entrambe le opzioni sono ragionevoli.

> 💡 **Suggerimento**: Per questo libro, tutti gli esempi sono presentati con Copilot Agent Mode in VS Code. Se usi Claude Code, i concetti sono identici — cambia solo l'interfaccia. Ogni `_CONTEXT.md` che scriverai funziona con entrambi.

---

## Oltre VS Code: Gli IDE AI-Nativi del 2026

Il panorama degli strumenti di sviluppo si è trasformato. Nel 2026 sono emersi IDE progettati **dalle fondamenta** attorno all'orchestrazione dell'IA, non come estensioni applicate a un editor esistente.

| Caratteristica | VS Code + Copilot | Cursor | Windsurf |
|:--|:--|:--|:--|
| **Architettura** | Estensione per IDE | Fork AI-nativo di VS Code | IDE standalone RAG |
| **Costo base** | 10$/mese | 20$/mese | 20$/mese |
| **Punto di forza** | Ecosistema, estensioni, Git nativo | Composer: modifica multi-file coordinata | RAG profondo su monorepo |
| **Contesto** | File allegati e workspace | Indicizzazione semantica (200K token) | Estrazione dinamica RAG |
| **Ideale per** | Progetti didattici, team eterogenei | Architetture complesse, refactoring | Prototipazione rapida, enterprise |

> 📘 Anche Claude Code si è evoluto significativamente: opera con finestre di contesto fino a 1 milione di token e supporta sessioni remote persistenti (*Remote Control*), permettendo di delegare task massivi a un agente che opera in background su macchine virtuali, anche per ore.

### Perché questo libro usa VS Code

La scelta di VS Code come ambiente principale non è casuale:

- **Universalità**: gratuito, multipiattaforma, il più adottato al mondo
- **Bassa barriera d'ingresso**: 10$/mese per Copilot, contro i 20$ dei concorrenti
- **Ecosistema**: Git nativo, migliaia di estensioni, supporto first-party di Microsoft
- **Trasferibilità**: le competenze di Context Engineering (`_CONTEXT.md`, `SKILL.md`) funzionano **identicamente** su Cursor, Windsurf o qualsiasi altro IDE

> ⚠️ **Attenzione**: Gli strumenti cambiano velocemente: Cursor potrebbe integrarsi in VS Code, Windsurf potrebbe cambiare modello di business, potrebbero emergere alternative superiori. Il **metodo** che impari in questo libro — Context Engineering, ADLC, Confidence Tagging — è indipendente dallo strumento e sopravvive a qualsiasi migrazione.

---

## 2.5 — Il Tuo Primo Codice Generato dall'IA

È ora di sporcarsi le mani. Faremo un test rapido per verificare che tutto funzioni.

### 🔧 PRATICA — Generare una funzione Python

1. **Crea una cartella di lavoro:**
   - Apri VS Code
   - Apri una cartella vuota: `C:\Progetti\test-0code` (o `~/progetti/test-0code`)

2. **Apri Copilot Chat in Agent Mode:**
   - Apri la chat di Copilot (dalla Command Palette: cerca "Copilot Chat")
   - Seleziona la modalità "Agent"

> ⚙️ **Nota di versione** — Il modo per aprire la chat di Copilot cambia con gli aggiornamenti di VS Code: potrebbe essere un'icona nella barra laterale, una scorciatoia da tastiera o un comando nella Command Palette (`Ctrl+Shift+P`). Consulta il repository companion per le istruzioni aggiornate.

3. **Scrivi questa richiesta:**

```text
Crea un file Python chiamato calcolatrice.py che implementi una calcolatrice 
da riga di comando. Deve supportare le 4 operazioni base (+, -, *, /). 
L'utente inserisce due numeri e l'operazione da terminale. 
Gestisci la divisione per zero con un messaggio di errore chiaro.
Aggiungi un file di test con pytest.
```

4. **Osserva cosa succede:**
   - Copilot creerà il file `calcolatrice.py`
   - Creerà il file di test `test_calcolatrice.py`
   - Potrebbe eseguire i test automaticamente
   - Ti chiederà conferma prima di azioni importanti

5. **Prova il risultato:**
   - Apri il terminale integrato di VS Code
   - Esegui: `python calcolatrice.py`

### 🎯 CHECKPOINT
Se la calcolatrice funziona e i test passano, il tuo ambiente è configurato correttamente. Hai appena creato il tuo primo programma in 0-code.

---

## 2.6 — Come Comunicare con l'IA: Le Basi

Prima di procedere con i progetti, è fondamentale capire come formulare richieste efficaci. Questa è la differenza tra risultati mediocri e risultati eccellenti.

### Le 5 regole della richiesta efficace

**1. Sii specifico, non generico**
```text
❌ "Crea un server"
✅ "Crea un server Express.js su porta 3000 con un endpoint GET /health 
    che restituisca { status: 'ok', timestamp: Date.now() }"
```

**2. Specifica la struttura dei file**
```text
❌ "Organizza il codice bene"
✅ "Struttura il progetto così:
    src/
      routes/
      controllers/
      models/
    tests/
    package.json"
```

**3. Definisci i vincoli**
```text
❌ "Usa un database"
✅ "Usa PostgreSQL con Prisma ORM. Non usare query SQL raw. 
    Lo schema deve essere in prisma/schema.prisma"
```

**4. Specifica il formato delle risposte**
```text
❌ "Gestisci gli errori"
✅ "Tutte le risposte API devono seguire questo formato:
    { success: boolean, data: T | null, error: string | null }
    Gli errori devono avere status code appropriati (400, 401, 404, 500)"
```

**5. Dai il contesto del progetto**
```text
❌ "Aggiungi l'autenticazione"
✅ "Aggiungi autenticazione OAuth 2.0 con Google. Il backend è Express.js 
    con PostgreSQL. Il frontend è React. Usa passport.js lato server 
    e React Context per lo stato utente lato client."
```

> 📖 **Approfondimento**: Queste regole sono la versione semplificata della disciplina del **Context Engineering** che approfondiremo nel Capitolo 3 e applicheremo sistematicamente a partire dal Capitolo 5.

---

## 2.7 — La Struttura di un Progetto 0-Code

Ogni progetto che costruirai in questo libro avrà una struttura riconoscibile:

```text
mio-progetto/
├── _CONTEXT.md          ← Il "contratto" con l'IA
├── .copilot/
│   ├── instructions.md  ← Regole specifiche del progetto
│   └── skills/          ← Competenze specializzate per fase
│       ├── analysis.md
│       ├── design.md
│       ├── react.md
│       └── ...           (una SKILL per fase/dominio)
├── PROGRESS.md          ← Memoria persistente (progetti lunghi)
├── .gitignore
├── README.md
├── src/                 ← Codice sorgente (generato dall'IA)
│   ├── ...
├── tests/               ← Test (generati dall'IA)
│   ├── ...
└── package.json / requirements.txt / pubspec.yaml
```

I file evidenziati — `_CONTEXT.md`, `.copilot/`, `PROGRESS.md` — sono gli unici file che **tu** scrivi manualmente. Tutto il resto è generato dall'IA sotto la tua supervisione.

> Questo è il centro di gravità del paradigma 0-code: **tu scrivi il contesto, l'IA scrive il codice**.

---

## 2.8 — Configurazioni Consigliate per VS Code

### 🔧 PRATICA — Settings consigliati

Apri le impostazioni di VS Code (Command Palette → "Open Settings (JSON)") e aggiungi:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.minimap.enabled": false,
  "files.autoSave": "onFocusChange",
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "github.copilot.chat.agent.enabled": true
}
```

Queste impostazioni garantiscono:
- Formattazione automatica al salvataggio
- Salvataggio automatico quando cambi tab
- Agent mode abilitato per Copilot

---

## Riepilogo

| Cosa hai fatto | Stato |
|:--|:--|
| Installato VS Code | ✅ |
| Installato GitHub Copilot | ✅ |
| Scelto il modello IA (Claude Sonnet 4 raccomandato) | ✅ |
| Generato il primo programma Python | ✅ |
| Compreso le 5 regole della richiesta efficace | ✅ |
| Configurato l'ambiente di lavoro | ✅ |

---

**→ Nel prossimo capitolo**: imparerai il metodo ADLC e scriverai il tuo primo file `_CONTEXT.md` — il documento che trasforma richieste vaghe in software di qualità.
