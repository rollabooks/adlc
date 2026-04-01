## UC-01: Aggiunta libro al catalogo
- **Attore**: Utente autenticato
- **Precondizione**: L'utente ha effettuato il login
- **Flusso principale**:
  1. L'utente clicca "Aggiungi libro"
  2. Compila titolo, autore, anno, genere
  3. Il sistema valida i dati
  4. Il sistema salva il libro nel database
  5. Il sistema mostra il libro nella lista aggiornata
- **Flusso alternativo**: Se il titolo è vuoto → errore di validazione
- **Postcondizione**: Il libro è visibile nella libreria dell'utente