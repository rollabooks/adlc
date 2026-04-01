# Appendice C — Comandi e Scorciatoie

---

## C.1 — VS Code

| Scorciatoia | Azione |
|:--|:--|
| `Ctrl+Shift+P` (Win/Linux) / `Cmd+Shift+P` (Mac) | Command Palette |
| `Ctrl+Shift+I` (Win/Linux) / `Cmd+Shift+I` (Mac) | Apri Copilot Chat (Agent Mode) |
| `Ctrl+I` (Win/Linux) / `Cmd+I` (Mac) | Copilot Inline Chat |
| `Tab` | Accetta suggerimento Copilot |
| `Esc` | Rifiuta suggerimento Copilot |
| `Ctrl+`` ` | Apri/chiudi terminale integrato |
| `Ctrl+Shift+E` | Explorer (file) |
| `Ctrl+Shift+G` | Source Control (Git) |
| `Ctrl+P` | Quick Open (cerca file) |
| `Ctrl+Shift+F` | Cerca in tutti i file |

---

## C.2 — Node.js e npm

| Comando | Descrizione |
|:--|:--|
| `npm init -y` | Crea package.json |
| `npm install <pacchetto>` | Installa dipendenza |
| `npm install -D <pacchetto>` | Installa come dev dependency |
| `npm run dev` | Avvia in modalità sviluppo (se configurato) |
| `npm run build` | Build di produzione |
| `npm audit` | Controlla vulnerabilità |
| `npm audit fix` | Correggi vulnerabilità automaticamente |
| `npx <comando>` | Esegui pacchetto senza installarlo globalmente |

---

## C.3 — Prisma

| Comando | Descrizione |
|:--|:--|
| `npx prisma init` | Inizializza Prisma nel progetto |
| `npx prisma migrate dev --name <nome>` | Crea e applica migrazione (sviluppo) |
| `npx prisma migrate deploy` | Applica migrazioni pendenti (produzione) |
| `npx prisma generate` | Rigenera il client Prisma |
| `npx prisma studio` | Apri interfaccia web per esplorare il database |
| `npx prisma db push` | Sincronizza schema senza migrazione |
| `npx prisma db seed` | Esegui seed del database |

---

## C.4 — Git

| Comando | Descrizione |
|:--|:--|
| `git init` | Inizializza repository |
| `git add .` | Aggiungi tutti i file modificati |
| `git commit -m "messaggio"` | Crea commit |
| `git status` | Stato dei file |
| `git log --oneline` | Cronologia commit compatta |
| `git branch <nome>` | Crea branch |
| `git checkout <nome>` | Cambia branch |
| `git merge <nome>` | Unisci branch |
| `git push origin main` | Pusha su remote |

---

## C.5 — Flutter

| Comando | Descrizione |
|:--|:--|
| `flutter create <nome>` | Crea nuovo progetto |
| `flutter run` | Avvia app (emulatore/dispositivo) |
| `flutter run -d chrome` | Avvia app nel browser |
| `flutter pub get` | Installa dipendenze |
| `flutter pub add <pacchetto>` | Aggiungi dipendenza |
| `flutter test` | Esegui test |
| `flutter analyze` | Analisi statica del codice |
| `flutter build apk --release` | Build APK Android |
| `flutter build appbundle` | Build AAB per Play Store |
| `flutter build ipa` | Build IPA per App Store |
| `flutter doctor` | Verifica ambiente di sviluppo |
| `flutter devices` | Lista dispositivi disponibili |
| `flutter screenshot` | Cattura screenshot dall'emulatore |

---

## C.6 — Docker (PostgreSQL)

| Comando | Descrizione |
|:--|:--|
| `docker run --name pg -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:16` | Avvia PostgreSQL |
| `docker start pg` | Riavvia container |
| `docker stop pg` | Ferma container |
| `docker exec -it pg psql -U postgres` | Apri console PostgreSQL |

---

## C.7 — Claude Code

| Comando | Descrizione |
|:--|:--|
| `claude` | Avvia sessione interattiva |
| `claude "richiesta"` | Esegui richiesta singola |
| `claude --model sonnet` | Specifica modello |
| `/clear` | Pulisci contesto della sessione |
| `/cost` | Mostra costo della sessione |
| `/help` | Mostra comandi disponibili |

---

## C.8 — Comandi di Deploy

| Piattaforma | Comando/Azione |
|:--|:--|
| **Railway** | `git push origin main` (deploy automatico) |
| **Vercel** | `git push origin main` (deploy automatico) |
| **Vercel CLI** | `npx vercel --prod` (deploy manuale) |
| **Railway CLI** | `railway up` (deploy manuale) |
