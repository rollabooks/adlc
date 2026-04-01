# Progetto: Hello 0-Code

## Scopo
Un programma Python interattivo che saluta l'utente, calcola la sua età
e genera una "fortuna del giorno" casuale.

## Tecnologie
- Python 3.11+
- Solo librerie standard (random, datetime)
- Test con pytest

## Struttura
hello-0code/
├── _CONTEXT.md
├── main.py          ← Entry point
├── greeter.py       ← Logica di saluto e calcolo
├── fortunes.py      ← Lista di fortune e generatore
└── tests/
    ├── test_greeter.py
    └── test_fortunes.py

## Convenzioni
- snake_case per tutto
- Type hints su tutte le funzioni
- Docstring per ogni funzione pubblica
- Print formattato con f-strings

## Vincoli
- Solo librerie standard Python. Nessun pip install.
- L'anno di nascita deve essere validato (1900-anno corrente)
- Il nome non può essere vuoto
- Gestisci input non validi con messaggi chiari