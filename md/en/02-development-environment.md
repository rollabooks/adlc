# Chapter 2 — The Development Environment: VS Code, Copilot, and Claude Code

## What You Will Learn

By the end of this chapter you will have:
- VS Code installed and configured for 0-code development
- GitHub Copilot active and working (or Claude Code)
- Generated your first code snippet with AI
- Understood the three modes of interacting with AI in VS Code

---

## 2.1 — Installing Visual Studio Code

Visual Studio Code (VS Code) is Microsoft's free code editor. It is the industry standard tool and, most importantly, the environment where GitHub Copilot and Claude Code operate at their full potential.

> ⚙️ **Version Note** — The instructions in this chapter are verified with VS Code 1.96+, GitHub Copilot Chat v0.25+, and Claude Code v1.x (Q1 2025). The interfaces of these tools evolve rapidly. If a button or menu does not exactly match what is described, consult the book's companion repository for up-to-date instructions: the concepts and method remain identical.

### 🔧 HANDS-ON — Installing VS Code

**Windows:**
1. Go to [code.visualstudio.com](https://code.visualstudio.com)
2. Download the installer for Windows
3. Run the installer. Select all integration options:
   - ✅ Add "Open with Code" to the context menu
   - ✅ Add to PATH

**macOS:**
```bash
brew install --cask visual-studio-code
```

**Linux (Ubuntu/Debian):**
```bash
sudo snap install code --classic
```

### 🎯 CHECKPOINT
Open VS Code. You should see the welcome screen. If you do, proceed.

---

## 2.2 — Essential Extensions

VS Code on its own is an advanced text editor. Its power comes from extensions. For 0-code development, you need only a few essential ones.

### 🔧 HANDS-ON — Installing extensions

Open the extensions panel (`Ctrl+Shift+X` on Windows, `Cmd+Shift+X` on macOS) and install:

| Extension | ID | Purpose |
|:--|:--|:--|
| **GitHub Copilot** | `GitHub.copilot` | The main AI engine |
| **GitHub Copilot Chat** | `GitHub.copilot-chat` | Chat and agent mode |
| **ESLint** | `dbaeumer.vscode-eslint` | JavaScript/TypeScript linting |
| **Prettier** | `esbenp.prettier-vscode` | Automatic formatting |
| **Thunder Client** | `rangav.vscode-thunder-client` | REST API testing (similar to Postman) |
| **Flutter** | `Dart-Code.flutter` | Flutter development (Part IV) |
| **Prisma** | `Prisma.prisma` | Database schema highlighting |

> 💡 **Tip**: Don't install Flutter and Prisma right away. You will install them when you reach the corresponding chapters. For now, Copilot and the JavaScript extensions are all you need.

---

## 2.3 — Configuring GitHub Copilot

GitHub Copilot is GitHub's (Microsoft's) AI tool integrated into VS Code. It uses models such as GPT-4o and Claude Sonnet to generate code, answer questions, and modify files.

### 🔧 HANDS-ON — Activating Copilot

1. **GitHub Account**: If you don't have one, create it at [github.com](https://github.com). It's free.

2. **Copilot Subscription**: Go to [github.com/features/copilot](https://github.com/features/copilot).
   - **Copilot Free**: Limited (2,000 completions + 50 chat messages/month) but sufficient for the first 3–4 chapters
   - **Copilot Individual**: $10/month — sufficient for the entire book
   - **Copilot Pro**: $39/month — unlimited Agent Mode (recommended for working without restrictions)

> 💰 **How much does it cost to complete the book?** With Copilot Individual ($10/month), the total cost to follow all 16 chapters is about $20–30, depending on your pace. With Claude Code (pay-per-use), the cost is comparable: roughly $15–40 for the tokens consumed throughout the entire journey. In either case, it is less than a single online course or one hour of consulting with a developer.
   
3. **Sign in to VS Code**: 
   - Open VS Code
   - Search for "GitHub: Sign In" in the Command Palette (`Ctrl+Shift+P`)
   - Authorize access with your GitHub account

4. **Verify**: Open a `.py` or `.js` file and start typing. If you see automatic suggestions in gray, Copilot is active.

### The Three Modes of Copilot

Copilot in VS Code has three interaction modes, each with an increasing level of autonomy:

| Mode | How to activate | What it does | When to use it |
|:--|:--|:--|:--|
| **Inline completion** | Automatic while you type | Suggests line-by-line completions | When you are writing code manually |
| **Chat** | Side panel (chat icon) | Free-form conversation, generates files, explains code | To ask for explanations, generate snippets |
| **Agent Mode** | In the chat, select "Agent" | Full autonomy: creates files, runs commands, iterates | **This is the 0-code mode** |

> ⚙️ **Version Note** — The Copilot chat interface (button placement, shortcuts, Agent mode label) changes with VS Code updates. If you cannot find an element, search the Command Palette (`Ctrl+Shift+P`): type "Copilot" to see all available options. What matters is the *functionality*: the mode that allows Copilot to create files, run commands, and iterate autonomously.

> ⚠️ **Warning**: Agent Mode is the mode you will use for 90% of the work in this book. Copilot in Agent Mode can create files, run terminal commands, install packages, and iterate autonomously on results. It is the equivalent of having a junior developer working alongside you.

### 🔧 HANDS-ON — Selecting the model

In Agent Mode you can choose which AI model to use. Look for the model selector in the chat interface and choose the most advanced model available.

> ⚙️ **Version Note** — The available models change frequently. At the time of writing, the recommended models are Claude Sonnet 4 (best context adherence), GPT-4o (fast and versatile), and Gemini 2.5 Pro (excellent context window). The general rule: choose the most recent model from the Claude or GPT family. All the concepts and techniques in this book work with any sufficiently advanced model — you are not locked in to a specific one.

---

## 2.4 — Alternative: Claude Code from the Terminal

If you prefer working from the terminal, or if you need even greater autonomy, you can use **Claude Code** — Anthropic's command-line tool.

### 🔧 HANDS-ON — Installing Claude Code

```bash
# Requires Node.js 18+
npm install -g @anthropic-ai/claude-code

# First launch and authentication
claude

# Navigate to the project folder and start
cd mio-progetto
claude
```

Claude Code operates directly on the file system: it reads files, modifies them, runs commands, and iterates — all from the terminal. It is particularly effective for:
- Complex, long-running projects
- Refactoring existing codebases
- Operations across many files simultaneously

### Copilot vs Claude Code: which one should you use?

| Aspect | Copilot Agent Mode | Claude Code |
|:--|:--|:--|
| **Interface** | GUI integrated in VS Code | Terminal |
| **Learning curve** | Low | Medium |
| **Autonomy** | High | Very high |
| **Ideal for** | New projects, visual work | Complex, multi-file projects |
| **Cost** | $10/month (Copilot Individual) | Pay-per-use (~$0.003–0.015/request) |

> 💰 **Cost comparison for the complete book**: With Copilot Individual at $10/month over 2–3 months ≈ $20–30. With Claude Code on a pay-per-use basis, for all the book's projects ≈ $15–40 depending on the complexity of the iterations. Both options are reasonable.

> 💡 **Tip**: For this book, all examples are presented using Copilot Agent Mode in VS Code. If you use Claude Code, the concepts are identical — only the interface changes. Every `_CONTEXT.md` you write works with both.

---

## Beyond VS Code: AI-Native IDEs in 2026

The landscape of development tools has been transformed. In 2026, IDEs designed **from the ground up** around AI orchestration have emerged, rather than as extensions bolted onto an existing editor.

| Feature | VS Code + Copilot | Cursor | Windsurf |
|:--|:--|:--|:--|
| **Architecture** | Extension for IDE | AI-native fork of VS Code | Standalone RAG IDE |
| **Base cost** | $10/month | $20/month | $20/month |
| **Key strength** | Ecosystem, extensions, native Git | Composer: coordinated multi-file editing | Deep RAG on monorepos |
| **Context** | Attached files and workspace | Semantic indexing (200K tokens) | Dynamic RAG extraction |
| **Ideal for** | Didactic projects, heterogeneous teams | Complex architectures, refactoring | Rapid prototyping, enterprise |

> 📘 Claude Code has also evolved significantly: it operates with context windows of up to 1 million tokens and supports persistent remote sessions (*Remote Control*), allowing you to delegate massive tasks to an agent that runs in the background on virtual machines, even for hours.

### Why This Book Uses VS Code

The choice of VS Code as the primary environment is not accidental:

- **Universality**: free, cross-platform, the most widely adopted editor in the world
- **Low barrier to entry**: $10/month for Copilot, versus $20 for competitors
- **Ecosystem**: native Git, thousands of extensions, first-party Microsoft support
- **Transferability**: Context Engineering skills (`_CONTEXT.md`, `SKILL.md`) work **identically** on Cursor, Windsurf, or any other IDE

> ⚠️ **Warning**: Tools change quickly: Cursor could integrate into VS Code, Windsurf could change its business model, superior alternatives could emerge. The **method** you learn in this book — Context Engineering, ADLC, Confidence Tagging — is tool-independent and survives any migration.

---

## 2.5 — Your First AI-Generated Code

It's time to get your hands dirty. We'll run a quick test to verify that everything is working.

### 🔧 HANDS-ON — Generating a Python function

1. **Create a working folder:**
   - Open VS Code
   - Open an empty folder: `C:\Progetti\test-0code` (or `~/progetti/test-0code`)

2. **Open Copilot Chat in Agent Mode:**
   - Open the Copilot chat (from the Command Palette: search for "Copilot Chat")
   - Select the "Agent" mode

> ⚙️ **Version Note** — The way to open the Copilot chat changes with VS Code updates: it may be an icon in the sidebar, a keyboard shortcut, or a command in the Command Palette (`Ctrl+Shift+P`). Consult the companion repository for up-to-date instructions.

3. **Type this prompt:**

```text
Crea un file Python chiamato calcolatrice.py che implementi una calcolatrice 
da riga di comando. Deve supportare le 4 operazioni base (+, -, *, /). 
L'utente inserisce due numeri e l'operazione da terminale. 
Gestisci la divisione per zero con un messaggio di errore chiaro.
Aggiungi un file di test con pytest.
```

4. **Observe what happens:**
   - Copilot will create the file `calcolatrice.py`
   - It will create the test file `test_calcolatrice.py`
   - It may run the tests automatically
   - It will ask for confirmation before important actions

5. **Try the result:**
   - Open the integrated terminal in VS Code
   - Run: `python calcolatrice.py`

### 🎯 CHECKPOINT
If the calculator works and the tests pass, your environment is configured correctly. You have just created your first program in 0-code.

---

## 2.6 — How to Communicate with AI: The Basics

Before moving on to real projects, it is essential to understand how to formulate effective prompts. This is the difference between mediocre results and excellent ones.

### The 5 Rules of an Effective Prompt

**1. Be specific, not generic**
```text
❌ "Create a server"
✅ "Create an Express.js server on port 3000 with a GET /health endpoint 
    that returns { status: 'ok', timestamp: Date.now() }"
```

**2. Specify the file structure**
```text
❌ "Organize the code well"
✅ "Structure the project like this:
    src/
      routes/
      controllers/
      models/
    tests/
    package.json"
```

**3. Define the constraints**
```text
❌ "Use a database"
✅ "Use PostgreSQL with Prisma ORM. Do not use raw SQL queries. 
    The schema must be in prisma/schema.prisma"
```

**4. Specify the response format**
```text
❌ "Handle errors"
✅ "All API responses must follow this format:
    { success: boolean, data: T | null, error: string | null }
    Errors must have appropriate status codes (400, 401, 404, 500)"
```

**5. Provide project context**
```text
❌ "Add authentication"
✅ "Add OAuth 2.0 authentication with Google. The backend is Express.js 
    with PostgreSQL. The frontend is React. Use passport.js on the server 
    side and React Context for the user state on the client side."
```

> 📖 **Deep Dive**: These rules are the simplified version of the **Context Engineering** discipline that we will explore in depth in Chapter 3 and apply systematically starting from Chapter 5.

---

## 2.7 — The Structure of a 0-Code Project

Every project you build in this book will have a recognizable structure:

```text
mio-progetto/
├── _CONTEXT.md          ← The "contract" with the AI
├── .copilot/
│   ├── instructions.md  ← Project-specific rules
│   └── skills/          ← Specialized competencies per phase
│       ├── analysis.md
│       ├── design.md
│       ├── react.md
│       └── ...           (one SKILL per phase/domain)
├── PROGRESS.md          ← Persistent memory (long-running projects)
├── .gitignore
├── README.md
├── src/                 ← Source code (generated by the AI)
│   ├── ...
├── tests/               ← Tests (generated by the AI)
│   ├── ...
└── package.json / requirements.txt / pubspec.yaml
```

The highlighted files — `_CONTEXT.md`, `.copilot/`, `PROGRESS.md` — are the only files that **you** write manually. Everything else is generated by the AI under your supervision.

> This is the center of gravity of the 0-code paradigm: **you write the context, the AI writes the code**.

---

## 2.8 — Recommended VS Code Configuration

### 🔧 HANDS-ON — Recommended settings

Open VS Code settings (Command Palette → "Open Settings (JSON)") and add:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.minimap.enabled": false,
  "files.autoSave": "onFocusChange",
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "github.copilot.chat.agent.enabled": true
}
```

These settings ensure:
- Automatic formatting on save
- Auto-save when you switch tabs
- Agent mode enabled for Copilot

---

## Summary

| What you did | Status |
|:--|:--|
| Installed VS Code | ✅ |
| Installed GitHub Copilot | ✅ |
| Chose the AI model (Claude Sonnet 4 recommended) | ✅ |
| Generated your first Python program | ✅ |
| Understood the 5 rules of an effective prompt | ✅ |
| Configured the development environment | ✅ |

---

**→ In the next chapter**: you will learn the ADLC method and write your first `_CONTEXT.md` — the document that transforms vague requests into quality software.
