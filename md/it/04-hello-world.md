# Capitolo 4 — Progetto 1: Hello World in 0-Code

## Cosa Costruirai

Un programma Python interattivo che:
- Saluta l'utente per nome
- Calcola l'età a partire dall'anno di nascita
- Genera una "fortuna del giorno" casuale
- Ha test automatici funzionanti

**Tempo stimato**: 15-20 minuti

---

## 4.1 — Preparare il Progetto (ADLC Fase 0-2)

### 🔧 PRATICA — Setup iniziale

1. Apri VS Code
2. Crea una nuova cartella: `hello-0code`
3. Apri la cartella in VS Code (`File → Open Folder`)
4. Crea un file `_CONTEXT.md` nella root con questo contenuto:

```markdown
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
```

### 🎯 CHECKPOINT
Dovresti avere una cartella con un solo file: `_CONTEXT.md`. Tutto il resto lo genererà l'IA.

---

## 4.2 — La Prima Richiesta (ADLC Fase 3-4)

### 🔧 PRATICA — Generare il codice

1. Apri Copilot Chat in Agent Mode (`Ctrl+Shift+I`, seleziona "Agent")

2. Scrivi questa richiesta:

```text
Leggi il file _CONTEXT.md e implementa l'intero progetto seguendo 
la struttura e i vincoli definiti.

Il programma deve:
1. Chiedere il nome dell'utente
2. Chiedere l'anno di nascita
3. Calcolare l'età
4. Mostrare un saluto personalizzato con l'età
5. Mostrare una fortuna del giorno casuale (almeno 10 fortune diverse)

Crea anche i test unitari per greeter.py e fortunes.py.
```

3. **Osserva l'IA al lavoro**: Copilot in Agent Mode creerà i file uno per uno. Per ogni file ti mostrerà il contenuto e ti chiederà se accettare le modifiche.

4. **Accetta o correggi**: Se il codice ti sembra corretto, accetta. Se noti qualcosa di strano, chiedi una modifica.

---

## 4.3 — Analisi dell'Output

Vediamo cosa l'IA dovrebbe aver generato. Non preoccuparti se il tuo output è leggermente diverso — l'importante è che rispetti la struttura del `_CONTEXT.md`.

### Output atteso: `greeter.py`

```python
from datetime import datetime


def get_user_name() -> str:
    """Chiede il nome all'utente e lo valida."""
    while True:
        name = input("Come ti chiami? ").strip()
        if name:
            return name
        print("Il nome non può essere vuoto. Riprova.")


def get_birth_year() -> int:
    """Chiede l'anno di nascita e lo valida."""
    current_year = datetime.now().year
    while True:
        try:
            year = int(input("In che anno sei nato/a? "))
            if 1900 <= year <= current_year:
                return year
            print(f"L'anno deve essere tra 1900 e {current_year}.")
        except ValueError:
            print("Inserisci un numero valido.")


def calculate_age(birth_year: int) -> int:
    """Calcola l'età a partire dall'anno di nascita."""
    return datetime.now().year - birth_year


def greet(name: str, age: int) -> str:
    """Genera il messaggio di saluto personalizzato."""
    return f"Ciao {name}! Hai {age} anni."
```

### Cosa osservare

Controlla che l'IA abbia rispettato il `_CONTEXT.md`:

| Vincolo del contesto | Rispettato? |
|:--|:--|
| snake_case per funzioni | ✅ `get_user_name`, `calculate_age` |
| Type hints | ✅ `-> str`, `-> int` |
| Docstring | ✅ Su ogni funzione |
| Validazione anno (1900-corrente) | ✅ `if 1900 <= year <= current_year` |
| Nome non vuoto | ✅ `if name:` |
| Solo librerie standard | ✅ Solo `datetime` |

> 💡 **Suggerimento**: Questa verifica è il tuo lavoro principale come sviluppatore 0-code. Non devi scrivere il codice, ma devi saper **leggere e validare** che rispetti i requisiti.

---

## 4.4 — Eseguire e Testare (ADLC Fase 5)

### 🔧 PRATICA — Esecuzione del programma

1. Apri il terminale integrato (`Ctrl+ò`)
2. Esegui:

```bash
python main.py
```

3. Interagisci con il programma:
```text
Come ti chiami? Marco
In che anno sei nato/a? 1990
Ciao Marco! Hai 36 anni.
🔮 La tua fortuna del giorno: "Il codice migliore è quello che non devi scrivere."
```

### 🔧 PRATICA — Esecuzione dei test

```bash
pip install pytest    # Se non è già installato
python -m pytest tests/ -v
```

Output atteso:
```text
tests/test_greeter.py::test_calculate_age PASSED
tests/test_greeter.py::test_greet PASSED
tests/test_greeter.py::test_greet_message_format PASSED
tests/test_fortunes.py::test_get_fortune_returns_string PASSED
tests/test_fortunes.py::test_fortune_not_empty PASSED
========================= 5 passed =========================
```

### 🎯 CHECKPOINT
Se il programma funziona e i test passano, hai completato il tuo primo progetto in 0-code.

---

## 4.5 — Iterare e Migliorare

Il vero potere del 0-code emerge nell'iterazione. Proviamo ad aggiungere funzionalità senza toccare il codice.

### 🔧 PRATICA — Aggiungere una funzionalità

Nella chat di Copilot, scrivi:

```text
Aggiungi una funzionalità "zodiac": dopo il saluto, mostra il segno zodiacale 
dell'utente basato sull'anno di nascita (zodiaco cinese). 
Aggiungi la logica in un nuovo file zodiac.py con i relativi test.
Aggiorna main.py per usare questa nuova funzionalità.
```

L'IA:
1. Creerà `zodiac.py` con la logica del zodiaco cinese
2. Creerà `tests/test_zodiac.py` 
3. Modificherà `main.py` per integrare la nuova funzionalità
4. Seguirà automaticamente le convenzioni del `_CONTEXT.md` (snake_case, type hints, docstring)

### 🔧 PRATICA — Correggere un bug

Se il programma ha un comportamento inatteso, non modificare il codice. Descrivi il problema a Copilot:

```text
Quando inserisco l'anno 2024 come anno di nascita, il programma dice 
che ho 2 anni. Dovrebbe dire 1 anno se non ho ancora compiuto gli anni 
quest'anno, o 2 se li ho già compiuti. Correggi calcolando con mese e 
giorno, non solo l'anno.
```

L'IA correggerà il codice e aggiornerà i test relativi.

---

## 4.6 — Lezioni dal Primo Progetto (ADLC Fase 6)

### Cosa hai imparato

1. **Il `_CONTEXT.md` guida tutto**: la struttura dei file, le convenzioni, i vincoli — l'IA li ha seguiti perché li hai definiti nel contesto.

2. **La richiesta iniziale può essere generica**: non devi specificare ogni dettaglio nella richiesta. I dettagli stanno nel contesto, la richiesta indica l'obiettivo.

3. **L'iterazione è gratuita**: aggiungere funzionalità o correggere bug è veloce come descrivere il problema.

4. **Tu revisioni, l'IA implementa**: il tuo lavoro è stato leggere il codice e verificare che rispettasse i requisiti, non scriverlo.

### 🔧 PRATICA — Aggiorna il contesto

Se durante questo progetto l'IA ha commesso errori ricorrenti, aggiungili come vincoli al `_CONTEXT.md`. Per esempio:

```markdown
## Lezioni Apprese
- Calcolare l'età usando datetime.date completo, non solo l'anno
- I test devono usare fixture per i dati di test, non valori hardcoded
```

Questo contesto sarà la base per i tuoi prossimi progetti.

---

## Riepilogo del Progetto

| Fase ADLC | Cosa hai fatto | Tempo |
|:--|:--|:--|
| Fase 0-2 | Creato `_CONTEXT.md` | 5 min |
| Fase 3-4 | Generato codice con Copilot | 5 min |
| Fase 5 | Testato e verificato | 3 min |
| Iterazione | Aggiunto zodiaco e fix bug | 5 min |
| Fase 6 | Aggiornato contesto | 2 min |
| **Totale** | **Applicazione completa con test** | **~20 min** |

---

**→ Nel prossimo capitolo**: alziamo il livello. Costruirai un'applicazione CLI completa per la gestione di task — con persistenza su file, argomenti da riga di comando e un contesto strutturato di livello professionale.
