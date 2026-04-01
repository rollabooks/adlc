# Appendix C — Commands and Shortcuts

---

## C.1 — VS Code

| Shortcut | Action |
|:--|:--|
| `Ctrl+Shift+P` (Win/Linux) / `Cmd+Shift+P` (Mac) | Command Palette |
| `Ctrl+Shift+I` (Win/Linux) / `Cmd+Shift+I` (Mac) | Open Copilot Chat (Agent Mode) |
| `Ctrl+I` (Win/Linux) / `Cmd+I` (Mac) | Copilot Inline Chat |
| `Tab` | Accept Copilot suggestion |
| `Esc` | Dismiss Copilot suggestion |
| `Ctrl+`` ` | Open/close integrated terminal |
| `Ctrl+Shift+E` | Explorer (files) |
| `Ctrl+Shift+G` | Source Control (Git) |
| `Ctrl+P` | Quick Open (find file) |
| `Ctrl+Shift+F` | Search across all files |

---

## C.2 — Node.js and npm

| Command | Description |
|:--|:--|
| `npm init -y` | Create package.json |
| `npm install <package>` | Install dependency |
| `npm install -D <package>` | Install as dev dependency |
| `npm run dev` | Start in development mode (if configured) |
| `npm run build` | Production build |
| `npm audit` | Check for vulnerabilities |
| `npm audit fix` | Automatically fix vulnerabilities |
| `npx <command>` | Run a package without installing it globally |

---

## C.3 — Prisma

| Command | Description |
|:--|:--|
| `npx prisma init` | Initialize Prisma in the project |
| `npx prisma migrate dev --name <name>` | Create and apply migration (development) |
| `npx prisma migrate deploy` | Apply pending migrations (production) |
| `npx prisma generate` | Regenerate the Prisma client |
| `npx prisma studio` | Open web interface to explore the database |
| `npx prisma db push` | Sync schema without migration |
| `npx prisma db seed` | Run database seed |

---

## C.4 — Git

| Command | Description |
|:--|:--|
| `git init` | Initialize repository |
| `git add .` | Stage all modified files |
| `git commit -m "message"` | Create commit |
| `git status` | File status |
| `git log --oneline` | Compact commit history |
| `git branch <name>` | Create branch |
| `git checkout <name>` | Switch branch |
| `git merge <name>` | Merge branch |
| `git push origin main` | Push to remote |

---

## C.5 — Flutter

| Command | Description |
|:--|:--|
| `flutter create <name>` | Create new project |
| `flutter run` | Launch app (emulator/device) |
| `flutter run -d chrome` | Launch app in the browser |
| `flutter pub get` | Install dependencies |
| `flutter pub add <package>` | Add dependency |
| `flutter test` | Run tests |
| `flutter analyze` | Static code analysis |
| `flutter build apk --release` | Build Android APK |
| `flutter build appbundle` | Build AAB for Play Store |
| `flutter build ipa` | Build IPA for App Store |
| `flutter doctor` | Verify development environment |
| `flutter devices` | List available devices |
| `flutter screenshot` | Capture screenshot from emulator |

---

## C.6 — Docker (PostgreSQL)

| Command | Description |
|:--|:--|
| `docker run --name pg -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:16` | Start PostgreSQL |
| `docker start pg` | Restart container |
| `docker stop pg` | Stop container |
| `docker exec -it pg psql -U postgres` | Open PostgreSQL console |

---

## C.7 — Claude Code

| Command | Description |
|:--|:--|
| `claude` | Start interactive session |
| `claude "request"` | Execute single request |
| `claude --model sonnet` | Specify model |
| `/clear` | Clear session context |
| `/cost` | Show session cost |
| `/help` | Show available commands |

---

## C.8 — Deploy Commands

| Platform | Command/Action |
|:--|:--|
| **Railway** | `git push origin main` (automatic deploy) |
| **Vercel** | `git push origin main` (automatic deploy) |
| **Vercel CLI** | `npx vercel --prod` (manual deploy) |
| **Railway CLI** | `railway up` (manual deploy) |
