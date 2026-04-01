curl -X POST http://localhost:3000/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "La mia prima nota", "content": "Generata in 0-code!", "tags": ["test"]}'