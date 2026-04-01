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