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