## Sicurezza
- [ ] JWT_SECRET >= 256 bit, in variabile d'ambiente
- [ ] Token scade (access: 1h, refresh: 7d)
- [ ] Logout invalida refresh token
- [ ] Input validato con Zod
- [ ] Errori non espongono stack trace
- [ ] Helmet.js attivo
- [ ] Rate limiting su auth
- [ ] CORS solo domini consentiti
- [ ] npm audit clean
- [ ] .env nel .gitignore

## Funzionalità
- [ ] Login OAuth funziona
- [ ] CRUD completo funziona
- [ ] Protezione route funziona
- [ ] Error handling end-to-end
- [ ] Mobile connesso al backend
- [ ] Health check endpoint

## Infrastruttura
- [ ] Database migrato in produzione
- [ ] Variabili d'ambiente impostate
- [ ] HTTPS attivo
- [ ] Monitoring attivo