## Comunicazione tra Servizi

| Da | A | Metodo | Descrizione |
|:--|:--|:--|:--|
| Gateway | Auth | HTTP | Verifica token |
| Gateway | Notes | HTTP | Proxy richieste note |
| Notes | Notification | Event (Redis) | Nuova nota → notifica |

## Eventi

| Evento | Producer | Consumer | Payload |
|:--|:--|:--|:--|
| note.created | Notes | Notification | { userId, noteId, title } |
| user.deleted | Auth | Notes, Notification | { userId } |