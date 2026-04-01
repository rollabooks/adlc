# Progetto: TaskMaster CLI

## Scopo
Un'applicazione da riga di comando per la gestione di task personali.
L'utente può aggiungere, listare, completare e eliminare task.
I dati vengono salvati in un file JSON locale.

## Tecnologie
- Linguaggio: Python 3.11+
- Librerie: solo moduli standard (argparse, json, os, datetime)
- Nessuna dipendenza esterna ammessa

## Struttura

taskmaster/
├── _CONTEXT.md
├── main.py              ← Entry point CLI
├── task_manager.py      ← Logica di gestione task
├── storage.py           ← Persistenza su file JSON
├── tests/
│   ├── test_task_manager.py
│   └── test_storage.py
└── data/
    └── tasks.json       ← Database locale (creato automaticamente)


## Convenzioni
- Naming: snake_case per tutto (file, funzioni, variabili)
- Docstring: ogni funzione pubblica deve avere una docstring
- Type hints: usa type hints su tutte le firme di funzione
- Output CLI: messaggi chiari e formattati per l'utente

## Vincoli
- NON usare librerie esterne (pip install). Solo standard library.
- NON usare variabili globali. Passa sempre i dati come parametri.
- NON ignorare gli errori. Gestisci FileNotFoundError, JSONDecodeError, etc.
- Il file tasks.json deve essere creato automaticamente se non esiste.

## Comandi CLI
- `python main.py add "Comprare il latte"` → Aggiunge un task
- `python main.py list` → Mostra tutti i task
- `python main.py list --status done` → Filtra per status
- `python main.py done 3` → Segna il task #3 come completato
- `python main.py delete 3` → Elimina il task #3

## Testing
- Framework: pytest
- Eseguire i test: `python -m pytest tests/ -v`
- Ogni modulo deve avere copertura test >= 80%