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