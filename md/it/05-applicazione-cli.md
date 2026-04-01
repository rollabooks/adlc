# Capitolo 5 — Progetto 2: Un'Applicazione CLI Completa

## Cosa Costruirai

Un **Task Manager da riga di comando** — un'applicazione Python professionale che:
- Gestisce task con operazioni CRUD (crea, leggi, aggiorna, elimina)
- Persiste i dati su file JSON
- Supporta filtri e ricerca
- Ha un sistema di priorità e scadenze
- Include test automatici con copertura completa

**Tempo stimato**: 30-45 minuti

---

## 5.1 — Il Contesto Professionale (ADLC Fase 0-2)

Questo progetto è il primo dove il `_CONTEXT.md` fa davvero la differenza tra un risultato mediocre e uno professionale.

### 🔧 PRATICA — Setup del progetto

1. Crea la cartella `taskmaster`
2. Aprila in VS Code
3. Crea il file `_CONTEXT.md`:

```markdown
# Progetto: TaskMaster CLI

## Scopo
Applicazione CLI per la gestione di task personali con persistenza locale.
È uno strumento che l'utente usa quotidianamente dal terminale per organizzare
il proprio lavoro.

## Tecnologie
- Python 3.11+
- Librerie: SOLO standard library (argparse, json, os, datetime, pathlib, enum)
- Testing: pytest
- Nessuna dipendenza esterna ammessa (nessun pip install)

## Struttura del Progetto

taskmaster/
├── _CONTEXT.md
├── main.py              ← Entry point. Solo parsing argomenti e chiamata a TaskManager
├── task_manager.py      ← Classe TaskManager: logica CRUD
├── models.py            ← Dataclass Task con tutti i campi
├── storage.py           ← Classe Storage: lettura/scrittura file JSON
├── formatters.py        ← Formattazione output per il terminale
├── tests/
│   ├── conftest.py      ← Fixtures condivise (tmp_path per storage, task di esempio)
│   ├── test_task_manager.py
│   ├── test_storage.py
│   └── test_formatters.py
└── data/
    └── tasks.json       ← Creato automaticamente al primo uso

## Modello Dati (Task)

Ogni task ha questi campi:
- id: int (auto-incrementale, non riutilizzato dopo cancellazione)
- title: str (obbligatorio, max 100 caratteri)
- description: str (opzionale, default "")
- status: enum [todo, in_progress, done] (default: todo)
- priority: enum [low, medium, high] (default: medium)
- created_at: str ISO 8601
- updated_at: str ISO 8601
- due_date: str ISO 8601 o null (opzionale)

## Comandi CLI

taskmaster add "Titolo del task"                         → Crea task
taskmaster add "Titolo" -d "Descrizione" -p high         → Crea con opzioni
taskmaster add "Titolo" --due 2026-04-15                 → Crea con scadenza
taskmaster list                                          → Lista tutti i task
taskmaster list --status todo                            → Filtra per stato
taskmaster list --priority high                          → Filtra per priorità
taskmaster list --overdue                                → Mostra task scaduti
taskmaster show 3                                        → Dettaglio task #3
taskmaster update 3 --status done                        → Aggiorna stato
taskmaster update 3 --title "Nuovo titolo" --priority low
taskmaster delete 3                                      → Elimina task #3
taskmaster stats                                         → Statistiche

## Convenzioni di Codice

- Naming: snake_case per tutto (file, funzioni, variabili, metodi)
- Classi: PascalCase (TaskManager, Storage, Task)
- Type hints: OBBLIGATORI su tutte le firme di funzione
- Docstring: su ogni classe e metodo pubblico
- Enum: usa enum.Enum per status e priority, mai stringhe libere
- Dataclass: usa @dataclass per il modello Task
- Pathlib: usa pathlib.Path, mai os.path per i percorsi file

## Vincoli di Implementazione

- NON usare variabili globali. Inietta le dipendenze come parametri.
- NON ignorare le eccezioni. Cattura e mostra errori specifici e utili.
- NON usare exit() nel mezzo del codice. Solo in main.py.
- Il file tasks.json DEVE essere creato automaticamente se non esiste.
- L'ID dei task DEVE essere auto-incrementale e MAI riutilizzato.
- Il formato del file JSON deve essere indentato (indent=2) per leggibilità.
- La cancellazione di un task chiede conferma all'utente (y/N).

## Output Terminale

L'output deve essere formattato, leggibile e colorato (se supportato):
- Lista task: formato tabellare allineato
- Task singolo: formato dettagliato multi-riga
- Errori: prefisso "❌ Errore:" 
- Conferme: prefisso "✅"
- Avvisi: prefisso "⚠️"

## Testing

- Framework: pytest
- Eseguire: python -m pytest tests/ -v
- Usare tmp_path (fixture pytest) per i test di storage — MAI scrivere
  nella directory reale data/
- Ogni test deve essere indipendente dagli altri
- Testare sia i casi positivi che gli edge case (task inesistente, ID invalido...)
```

> 📖 **Approfondimento**: Nota come questo `_CONTEXT.md` è molto più dettagliato di quello del Capitolo 4. Definisce il modello dati, i comandi CLI esatti, le convenzioni di codice e i vincoli di implementazione. Più è dettagliato il contesto, migliore sarà il codice generato.

---

## 5.2 — Generazione del Codice (ADLC Fase 3-4)

### 🔧 PRATICA — Fase 3: Proof of Value

Prima di generare tutto il progetto, facciamo un test rapido. In Copilot Agent Mode:

```text
Leggi il _CONTEXT.md. Come primo passo, genera solo il file models.py 
con la dataclass Task e gli enum Status e Priority. 
Nota: non generare nient'altro per ora.
```

Verifica che:
- Usa `@dataclass`
- Usa `enum.Enum` per Status e Priority  
- Tutti i campi hanno type hints
- I campi opzionali hanno valori default

Se il modello è corretto, procedi con il resto.

### 🔧 PRATICA — Fase 4: Generazione completa

```text
Perfetto. Ora implementa l'intero progetto secondo il _CONTEXT.md.
Procedi in quest'ordine:
1. storage.py (persistenza JSON)
2. task_manager.py (logica CRUD)
3. formatters.py (output terminale)
4. main.py (CLI con argparse)
5. tests/ (tutti i file di test)
```

> 💡 **Suggerimento**: Specificare l'ordine di implementazione aiuta l'IA a costruire il progetto layer per layer, evitando riferimenti circolari e dipendenze mancanti.

---

## 5.3 — Revisione del Codice Generato

Dopo che Copilot ha generato tutti i file, fai una revisione sistematica.

### Checklist di revisione

Per ogni file, verifica:

**`models.py`**
- [ ] `Status` e `Priority` sono Enum, non stringhe
- [ ] `Task` è una dataclass con tutti i campi del `_CONTEXT.md`
- [ ] Metodi `to_dict()` e `from_dict()` per serializzazione JSON
- [ ] `created_at` e `updated_at` generati automaticamente

**`storage.py`**
- [ ] Usa `pathlib.Path`, non `os.path`
- [ ] Crea il file JSON automaticamente se non esiste
- [ ] Legge e scrive con `indent=2`
- [ ] Gestisce `FileNotFoundError` e `JSONDecodeError`

**`task_manager.py`**
- [ ] L'ID è auto-incrementale e non viene riutilizzato
- [ ] Supporta tutti i comandi del `_CONTEXT.md`
- [ ] `update_task` modifica `updated_at`
- [ ] `delete_task` esiste e funziona

**`main.py`**
- [ ] Usa `argparse` con subcommand (add, list, show, update, delete, stats)
- [ ] Ogni subcommand ha i suoi argomenti specifici
- [ ] Gli errori mostrano messaggi utili, non stack trace

**`tests/`**
- [ ] Usa `tmp_path` per lo storage, non la directory reale
- [ ] Testa casi positivi e edge case
- [ ] Ogni test è indipendente

> ⚠️ **Attenzione**: Se trovi un problema, non modificare il codice a mano. Descrivi il problema a Copilot e chiedigli di correggerlo. Questo è il flusso 0-code.

---

## 5.4 — Test ed Esecuzione

### 🔧 PRATICA — Test

```bash
python -m pytest tests/ -v
```

Se qualche test fallisce, copia l'errore e incollalo nella chat di Copilot:

```text
Questo test fallisce con il seguente errore:
[incolla l'errore]
Correggi il codice per far passare il test.
```

### 🔧 PRATICA — Uso dell'applicazione

```bash
# Aggiungi task
python main.py add "Leggere il capitolo 6" -p high
python main.py add "Comprare il latte" --due 2026-04-01
python main.py add "Rispondere alle email" -d "Email del team" -p low

# Lista tutti
python main.py list

# Filtra
python main.py list --status todo
python main.py list --priority high

# Dettaglio
python main.py show 1

# Aggiorna
python main.py update 1 --status in_progress
python main.py update 1 --status done

# Statistiche
python main.py stats

# Elimina
python main.py delete 2
```

### 🎯 CHECKPOINT
Se tutti i comandi funzionano e i test passano, hai un'applicazione CLI professionale completa.

---

## 5.5 — Iterazione: Aggiungere Funzionalità

### 🔧 PRATICA — Esporta in formato Markdown

```text
Aggiungi un comando "export" che esporta tutti i task in un file Markdown 
formattato come tabella. 
Uso: python main.py export report.md
Il file deve contenere una tabella Markdown con tutti i task, organizzati 
per priorità (high → medium → low).
Aggiungi i test corrispondenti.
```

### 🔧 PRATICA — Ricerca per testo

```text
Aggiungi un comando "search" che cerca tra titoli e descrizioni dei task.
Uso: python main.py search "email"
La ricerca deve essere case-insensitive.
Aggiungi i test corrispondenti.
```

Ogni volta che aggiungi una funzionalità, l'IA:
1. Legge il `_CONTEXT.md` per conoscere le convenzioni
2. Analizza il codice esistente per integrarsi
3. Genera codice consistente con lo stile del progetto
4. Aggiunge test

---

## 5.6 — Il Pattern che Userai Sempre

Questo progetto ha stabilito il pattern che seguirai per tutto il libro:

```text
1. _CONTEXT.md       → Definisci il progetto (5-15 min)
2. Proof of Value     → Genera un pezzo piccolo e verifica (5 min)
3. Generazione        → L'IA implementa tutto (10-20 min)
4. Revisione          → Controlli la qualità (5-10 min)
5. Test               → Verifica che funzioni (2-5 min)
6. Iterazione         → Aggiungi funzionalità e correggi (continuo)
7. Aggiornamento      → Migliora il _CONTEXT.md (2 min)
```

Questo pattern scala: funziona per un CLI tool da 200 righe come per un'app web full-stack da 10.000.

---

## 5.7 — Lezioni Apprese (ADLC Fase 6)

### Aggiorna il tuo `_CONTEXT.md` con queste lezioni (se le hai incontrate):

```markdown
## Lezioni Apprese
- Specificare l'ordine di implementazione (storage → logic → UI → main → tests)
  migliora la coerenza del codice generato
- I test con tmp_path devono sempre creare un'istanza fresh di Storage
- argparse con subparsers richiede set_defaults(func=...) per il routing
- L'IA tende a dimenticare la conferma y/N sulla cancellazione: metterla nei vincoli
```

---

## Riepilogo del Progetto

| Aspetto | Dettaglio |
|:--|:--|
| **Linguaggio** | Python 3.11+ |
| **Dipendenze** | Zero (solo standard library) |
| **File generati** | ~7 file, ~400-600 righe totali |
| **Test** | ~15-20 test case |
| **Tempo totale** | ~30-45 minuti |
| **Codice scritto a mano** | Solo il `_CONTEXT.md` |

---

**→ Nel prossimo capitolo**: passiamo al web. Costruirai il tuo primo server REST API con Node.js e Express — il fondamento del progetto full-stack che crescerà nei capitoli successivi.
