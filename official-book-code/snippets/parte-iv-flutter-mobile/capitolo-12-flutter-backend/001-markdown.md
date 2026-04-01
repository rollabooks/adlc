## Autenticazione Mobile

L'autenticazione su mobile usa una WebView per mostrare la pagina OAuth.
Dopo il login, il backend redirige a un URL speciale che l'app intercetta
per estrarre il token JWT.

### Flusso:
1. Utente tocca "Login con Google"
2. App apre una WebView con URL: {backend}/api/auth/google?platform=mobile
3. Google mostra la pagina di consenso
4. Backend riceve il callback OAuth
5. Backend redirige a: notesapp://auth/callback?token={jwt}&refresh={refresh_token}
6. App intercetta il deep link, salva i token, chiude la WebView

### Dipendenze aggiuntive:
- flutter_web_auth_2: per il flusso OAuth con custom scheme
- flutter_secure_storage: per salvare i token in modo sicuro