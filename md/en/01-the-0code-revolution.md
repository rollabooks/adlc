# Chapter 1 — The 0-Code Revolution: Seeing It in Action

## What You'll Learn

By the end of this chapter you'll know:
- What a 0-code working session looks like (live)
- Why context is everything and how it changes the results
- What you'll build with this book (preview of the 9 projects)

> 📖 If you haven't read the [Introduction](00-introduction.md) yet, do so now. It explains the ADLC framework, the comparison with the traditional SDLC, and the three core competencies (Context Engineering, Risk Design, Confidence Tagging) that underpin the entire book.

---

## 1.1 — A 0-Code Working Session: Live

You already know the theory from the Introduction. Now let's see how it works **in practice** — what a 0-code working session actually looks like, what appears on screen, what you do, and what the AI does.

### The setup: 30 seconds

Open VS Code. Open an empty folder. Open the Copilot chat in Agent Mode. Type:

```text
Create a Python application that converts temperatures between Celsius,
Fahrenheit, and Kelvin. The user chooses the conversion from an interactive
terminal menu. Add a test file using pytest.
```

### What happens in the next 60 seconds

Copilot in Agent Mode:
1. **Creates** the file `converter.py` with the conversion functions
2. **Creates** the file `test_converter.py` with the unit tests
3. **Runs** `pytest` in the integrated terminal
4. **Reads** the output: 6 tests passed out of 6
5. **Notifies you**: "I've created the files and all tests pass. Would you like me to add anything?"

You wrote 3 lines of instructions. The AI generated ~80 lines of working, tested code.

But here's the point: the code is **generic**. It works, but it doesn't follow a specific structure, doesn't have sophisticated error handling, and lacks internal documentation.

### The same task, with context

Now imagine writing a `_CONTEXT.md` file first:

```markdown
# Project: Temperature Converter

## Purpose
CLI tool for temperature conversion with a focus on scientific precision.

## Constraints
- Kelvin cannot be negative (0 K = absolute zero)
- Always round to 2 decimal places
- Error messages must be in English
- Naming: snake_case everywhere

## Structure
converter/
├── main.py          ← Entry point with menu
├── conversions.py   ← Pure conversion functions
├── validators.py    ← Input validation
└── tests/
    ├── test_conversions.py
    └── test_validators.py
```

And then you tell Copilot:

```text
Read the _CONTEXT.md and implement the complete application
following all the specifications.
```

The result is **radically different**: code separated into modules, absolute-zero validation, specific edge-case tests, messages in English, and a clean structure.

**Same 3 lines of request. Incomparable results.** The variable that changed is the context.

---

## 1.2 — Context Is Everything

This is the most important principle in the entire book, and it deserves to be crystallized with a concrete example of the difference.

**Vague request:**
```text
Create an API to manage users
```

**Result**: generic code, probably without validation, without authentication, with inconsistent naming.

**Request with context:**
```text
Create a REST API with Express.js for user management.
Structure: src/routes/, src/controllers/, src/models/.
Database: PostgreSQL with Prisma ORM.
Endpoints: GET /users, GET /users/:id, POST /users, PUT /users/:id, DELETE /users/:id.
Input validation with Zod.
Standard JSON responses: { success: boolean, data: T, error?: string }.
Centralized error handling with middleware.
```

**Result**: structured, validated code with consistent patterns, ready for production.

The difference isn't in the AI. It's in the context. In Chapter 3 you'll learn how to write professional `_CONTEXT.md` files; in Chapter 4 you'll start building your first real project.

> ⚠️ **A note on expectations.** This book doesn't require programming skills, but it does require **curiosity and willingness to learn new concepts**. Starting from Chapter 6 you'll encounter terms like API, middleware, database, authentication, JWT tokens. The AI will write all the code, but your role as a *context architect* requires understanding *what* you're asking it to build — not *how* to write it. The Introduction includes a "Crash Course" covering the fundamental concepts, and each advanced chapter has a "Theory Box" with the necessary explanations. If a term is unfamiliar, consult the Glossary (Appendix A).

---

## 1.3 — What You'll Build with This Book

This book is structured as a **progression of real projects**, each more complex than the last, each building on the skills acquired in the previous one.

### Project 1 — Hello World (Chapter 4)
Your first program generated entirely by AI. You'll learn how to formulate requests, read the output, and iterate.

### Project 2 — CLI Tool (Chapter 5)
A complete command-line application: CSV/JSON parsing, arguments, automated tests. Your first structured `_CONTEXT.md`.

### Project 3 — REST API (Chapter 6)
Your first web server with Express.js: CRUD endpoints, validation, Swagger documentation.

### Projects 4–7 — Full-Stack Web Application with OAuth 2.0 (Chapters 7–10)
The heart of the book. You'll build:
- **Project 4** (Ch. 7): Node.js/Express backend with PostgreSQL and Prisma
- **Project 5** (Ch. 8): OAuth 2.0 authentication (Google/GitHub) with JWT
- **Project 6** (Ch. 9): React frontend with protected routes and your first SKILL.md
- **Project 7** (Ch. 10): End-to-end integration and a complete CRUD dashboard

### Projects 8–9 — Flutter Mobile App (Chapters 11–12)
- **Project 8** (Ch. 11): Flutter setup, first mobile app, and Flutter SKILL.md
- **Project 9** (Ch. 12): OAuth login from mobile, synchronized CRUD, deep links

### Final Project — Full Deployment (Chapters 13–15)
Everything into production:
- Backend on the cloud (Railway/Render)
- Frontend on Vercel
- Managed PostgreSQL database
- Mobile app on the Play Store
- Automated CI/CD

---

## 1.4 — Requirements to Follow This Book

### What you need to know
- How to use a computer (Windows, macOS, or Linux)
- Basic concepts of how an application works (even just as a user)
- Basic technical English (command and technology names are in English)

### What you DON'T need to know
- You don't need to know how to program in Python, JavaScript, Dart, or any language
- You don't need to have ever used React, Node.js, Flutter, or PostgreSQL
- You don't need to have ever used a terminal or the command line
- You don't need to have ever used Git (but you'll learn along the way)

### What you need
- A computer running Windows 10/11, macOS 10.15+, or Linux
- A stable internet connection
- A GitHub account (free)
- A GitHub Copilot subscription OR access to Claude Code
- VS Code installed (free)

> 💰 **How much does it cost?** GitHub Copilot Individual costs $10/month. Claude Code works on a consumption basis through the Anthropic API. The cost of completing all the projects in the book is comparable to an online course (~$20–50). In Chapter 2 we'll look at the free options available and how to minimize spending.

---

## 1.5 — The Promise of This Book

By the end of this read you will have:

1. **Built** a complete web application with a backend, frontend, and OAuth 2.0 authentication
2. **Built** a Flutter mobile app connected to your backend
3. **Deployed** everything to production — accessible by anyone in the world
4. **Without manually writing** a single line of code

And above all, you will have acquired a **method** — Context Engineering and the ADLC — that will enable you to build any other application using the same approach.

It's not magic. It's context engineering. And it starts in the next chapter, with setting up your development environment.

---

> *"In the era of 0-code development, human words lose their role as an informal means of communication and take on the weight and consequences of directives in a high-level procedural programming language."*

---

**→ In the next chapter**: we'll install VS Code, configure GitHub Copilot, and generate our first piece of code.
