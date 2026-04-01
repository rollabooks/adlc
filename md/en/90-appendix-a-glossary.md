# Appendix A — Glossary

---

| Term | Definition | First use |
|:--|:--|:--|
| **0-code** | A development paradigm where the programmer describes what to build and the AI generates the code. Unlike traditional no-code, it produces real, editable source code. | Ch. 1 |
| **ADLC** | **Agent Development Life Cycle** — A 7-phase lifecycle for AI-assisted development: Preparation, Framing, Definition, Simulation, Implementation, Release, Learning. | Ch. 3 |
| **Agent Mode** | A mode in GitHub Copilot for VS Code where the AI can read files, execute commands, create files, and navigate the project autonomously. | Ch. 2 |
| **Agent Skill** | A specialized competency encapsulated in a SKILL.md file with YAML metadata. Loaded by the AI when the type of work requires it (Progressive Disclosure). | Ch. 9 |
| **Hallucination** | The generation of false or fabricated information, presented by the model with apparent confidence. | Ch. 1 |
| **Claude Code** | A CLI tool by Anthropic for 0-code development directly from the terminal. An alternative to Copilot Agent Mode. | Ch. 2 |
| **PROGRESS.md** | A persistent memory file across sessions. A project diary that records status, decisions, resolved issues, and next steps. | Ch. 3, 10 |
| **Confidence Tagging** | Classification of generated code by risk level (🟢 LOW, 🟡 MEDIUM, 🔴 HIGH) to determine the intensity of review needed. | Ch. 14 |
| **Context Engineering** | The discipline of designing the information provided to the AI. An evolution of Prompt Engineering for complex, long-duration projects. | Ch. 3 |
| **_CONTEXT.md** | A project context document that describes purpose, architecture, conventions, and constraints. The AI reads it to generate consistent code. | Ch. 3 |
| **CORS** | **Cross-Origin Resource Sharing** — A browser security mechanism that blocks requests between different domains. Resolved with a proxy (dev) or same-origin (prod). | Ch. 10 |
| **Deep Link** | A URL with a custom scheme (e.g., `notesapp://auth/callback`) that opens a mobile app directly. Used for returning from OAuth login. | Ch. 12 |
| **Dio** | An HTTP client for Dart/Flutter with support for interceptors, retry, and cancellation. The Flutter equivalent of Axios. | Ch. 11 |
| **Express.js** | A minimal web framework for Node.js. Used to build the project's REST API. | Ch. 6 |
| **Context Window** | The maximum amount of information (in tokens) that an LLM can process in a single request. | Ch. 3 |
| **Flutter** | A Google framework for building native mobile apps (Android and iOS) from a single Dart codebase. | Ch. 11 |
| **GoRouter** | A declarative routing library for Flutter with support for redirects, deep links, and protected navigation. | Ch. 11 |
| **Helmet.js** | An Express middleware that sets HTTP security headers (CSP, HSTS, X-Frame-Options, etc.). | Ch. 14 |
| **Hot Reload** | A Flutter feature that updates the interface instantly after a code change, without restarting the app. | Ch. 11 |
| **httpOnly Cookie** | A cookie not accessible from JavaScript (XSS protection). Used to store the JWT in the web frontend. | Ch. 8 |
| **JWT** | **JSON Web Token** — A signed token containing the user's identity. Used to authenticate API requests. | Ch. 8 |
| **LLM** | **Large Language Model** — A large-scale language model. The "engine" behind Copilot and Claude. | Ch. 1 |
| **MCP** | **Model Context Protocol** — A standard for connecting AI to external tools (databases, file systems, APIs). | Ch. 7 |
| **Monorepo** | A project structure where backend, frontend, and mobile reside in the same repository with separate contexts. | Ch. 10 |
| **MSW** | **Mock Service Worker** — A library for simulating API responses in frontend tests without a real backend. | Ch. 14 |
| **OAuth 2.0** | A delegated authentication protocol. The user logs in with Google/GitHub, and the app receives a token without managing passwords. | Ch. 8 |
| **OWASP Top 10** | A list of the 10 most common security vulnerabilities in web applications, published by OWASP. | Ch. 14 |
| **Passport.js** | An authentication middleware for Express.js with strategies for OAuth, JWT, local auth, etc. | Ch. 8 |
| **Planner-Generator-Evaluator** | A multi-agent pattern where the AI assumes different roles: plans (analysis), generates (code), evaluates (review). | Ch. 10 |
| **Prisma** | An ORM (Object-Relational Mapper) for Node.js/TypeScript. Translates classes into SQL tables and provides a typed client. | Ch. 7 |
| **Progressive Disclosure** | Incremental loading of information: the AI receives only the context needed for the current task. | Ch. 9 |
| **Proof of Value** | A validation pattern: first generate a small part (a model, an endpoint), verify it is correct, then proceed with the rest. | Ch. 5 |
| **Vite Proxy** | A Vite configuration that forwards `/api` calls from the frontend to the backend during development, avoiding CORS issues. | Ch. 9 |
| **Rate Limiting** | Restricting the number of requests per IP/user within a time interval. Protection against abuse and brute force attacks. | Ch. 14 |
| **Refresh Token** | A long-lived token (7 days) used to obtain new access tokens without repeating the login process. | Ch. 8 |
| **Riverpod** | A state management library for Flutter. Reactive providers with dependency injection. | Ch. 11 |
| **SKILL.md** | A file that gives the AI specialized competencies for a specific domain (React, Flutter, etc.). Loaded on-demand. | Ch. 9 |
| **Swagger** | A tool for interactive documentation and testing of REST APIs. Generates a navigable UI from endpoints. | Ch. 6 |
| **Token** | A processing unit for language models. A word fragment (~3–4 characters in English). | Ch. 3 |
| **Vite** | A modern build tool for web projects. Fast in development (HMR) and optimized for production. | Ch. 9 |
| **Zod** | A validation library for TypeScript/JavaScript. Defines schemas and validates input with clear error messages. | Ch. 6 |
| **0-Code** | An agentic development approach where the operator does not write code, but defines contexts, policies, and constraints in natural language. | |
