# Avvia il server
npm run dev

# Crea una nota (ora salvata nel database!)
curl -X POST http://localhost:3000/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "Nota nel database", "content": "Questa è persistente!", "tags": ["postgres"]}'

# Riavvia il server e verifica che la nota sia ancora lì
# (Ctrl+C per fermare, poi npm run dev)
curl http://localhost:3000/api/notes