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