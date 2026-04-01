# T-003.1 — Modello Prisma Book
Epic: E-003 | SP: 2 | Stato: 🔲 TODO | Rischio: LOW

## Obiettivo
Definire il modello Book nello schema Prisma con tutti i campi da PRD.

## Acceptance Criteria
- [ ] Il modello Book è definito in schema.prisma
- [ ] Include i campi: title, author, year, genre, isbn?, coverUrl?,
      status (enum), rating?, notes?
- [ ] La relazione con User è configurata (userId, foreign key)
- [ ] La migrazione è eseguita senza errori
- [ ] Un test verifica la creazione di un record Book

## File coinvolti
- backend/prisma/schema.prisma
- backend/tests/models/book.test.js

## SEC/PERF applicabili
- SEC-02: Ogni query filtra per userId
- PERF-02: Indice su Book.userId e Book.status