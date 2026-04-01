# Chapter 5 — Project 2: A Complete CLI Application

## What You'll Build

A **command-line Task Manager** — a professional Python application that:
- Manages tasks with CRUD operations (create, read, update, delete)
- Persists data to a JSON file
- Supports filtering and search
- Has a priority and deadline system
- Includes automated tests with full coverage

**Estimated time**: 30–45 minutes

---

## 5.1 — The Professional Context (ADLC Phase 0-2)

This project is the first where the `_CONTEXT.md` truly makes the difference between a mediocre result and a professional one.

### 🔧 **Hands-on** — Project Setup

1. Create the `taskmaster` folder
2. Open it in VS Code
3. Create the `_CONTEXT.md` file:

```markdown
# Project: TaskMaster CLI

## Purpose
CLI application for personal task management with local persistence.
It's a tool the user uses daily from the terminal to organize
their work.

## Technologies
- Python 3.11+
- Libraries: ONLY standard library (argparse, json, os, datetime, pathlib, enum)
- Testing: pytest
- No external dependencies allowed (no pip install)

## Project Structure

taskmaster/
├── _CONTEXT.md
├── main.py              ← Entry point. Only argument parsing and call to TaskManager
├── task_manager.py      ← TaskManager class: CRUD logic
├── models.py            ← Task dataclass with all fields
├── storage.py           ← Storage class: JSON file read/write
├── formatters.py        ← Terminal output formatting
├── tests/
│   ├── conftest.py      ← Shared fixtures (tmp_path for storage, sample tasks)
│   ├── test_task_manager.py
│   ├── test_storage.py
│   └── test_formatters.py
└── data/
    └── tasks.json       ← Automatically created on first use

## Data Model (Task)

Each task has these fields:
- id: int (auto-incremental, not reused after deletion)
- title: str (required, max 100 characters)
- description: str (optional, default "")
- status: enum [todo, in_progress, done] (default: todo)
- priority: enum [low, medium, high] (default: medium)
- created_at: str ISO 8601
- updated_at: str ISO 8601
- due_date: str ISO 8601 or null (optional)

## CLI Commands

taskmaster add "Task title"                              → Create task
taskmaster add "Title" -d "Description" -p high          → Create with options
taskmaster add "Title" --due 2026-04-15                  → Create with deadline
taskmaster list                                          → List all tasks
taskmaster list --status todo                            → Filter by status
taskmaster list --priority high                          → Filter by priority
taskmaster list --overdue                                → Show overdue tasks
taskmaster show 3                                        → Detail of task #3
taskmaster update 3 --status done                        → Update status
taskmaster update 3 --title "New title" --priority low
taskmaster delete 3                                      → Delete task #3
taskmaster stats                                         → Statistics

## Code Conventions

- Naming: snake_case for everything (files, functions, variables, methods)
- Classes: PascalCase (TaskManager, Storage, Task)
- Type hints: MANDATORY on all function signatures
- Docstring: on every public class and method
- Enum: use enum.Enum for status and priority, never free-form strings
- Dataclass: use @dataclass for the Task model
- Pathlib: use pathlib.Path, never os.path for file paths

## Implementation Constraints

- DO NOT use global variables. Inject dependencies as parameters.
- DO NOT ignore exceptions. Catch and display specific, useful errors.
- DO NOT use exit() in the middle of the code. Only in main.py.
- The tasks.json file MUST be created automatically if it doesn't exist.
- Task IDs MUST be auto-incremental and NEVER reused.
- The JSON file format must be indented (indent=2) for readability.
- Deleting a task asks the user for confirmation (y/N).

## Terminal Output

Output must be formatted, readable, and colored (if supported):
- Task list: aligned tabular format
- Single task: detailed multi-line format
- Errors: prefix "❌ Error:" 
- Confirmations: prefix "✅"
- Warnings: prefix "⚠️"

## Testing

- Framework: pytest
- Run: python -m pytest tests/ -v
- Use tmp_path (pytest fixture) for storage tests — NEVER write
  to the real data/ directory
- Each test must be independent of the others
- Test both positive cases and edge cases (nonexistent task, invalid ID...)
```

> 📖 **Deep Dive**: Notice how this `_CONTEXT.md` is far more detailed than the one in Chapter 4. It defines the data model, the exact CLI commands, code conventions, and implementation constraints. The more detailed the context, the better the generated code will be.

---

## 5.2 — Code Generation (ADLC Phase 3-4)

### 🔧 **Hands-on** — Phase 3: Proof of Value

Before generating the entire project, let's run a quick test. In Copilot Agent Mode:

```text
Read the _CONTEXT.md. As a first step, generate only the models.py file
with the Task dataclass and the Status and Priority enums.
Note: don't generate anything else for now.
```

Verify that:
- It uses `@dataclass`
- It uses `enum.Enum` for Status and Priority
- All fields have type hints
- Optional fields have default values

If the model is correct, proceed with the rest.

### 🔧 **Hands-on** — Phase 4: Full Generation

```text
Perfect. Now implement the entire project according to the _CONTEXT.md.
Proceed in this order:
1. storage.py (JSON persistence)
2. task_manager.py (CRUD logic)
3. formatters.py (terminal output)
4. main.py (CLI with argparse)
5. tests/ (all test files)
```

> 💡 **Tip**: Specifying the implementation order helps the AI build the project layer by layer, avoiding circular references and missing dependencies.

---

## 5.3 — Reviewing the Generated Code

After Copilot has generated all the files, perform a systematic review.

### Review Checklist

For each file, verify:

**`models.py`**
- [ ] `Status` and `Priority` are Enums, not strings
- [ ] `Task` is a dataclass with all the fields from `_CONTEXT.md`
- [ ] `to_dict()` and `from_dict()` methods for JSON serialization
- [ ] `created_at` and `updated_at` generated automatically

**`storage.py`**
- [ ] Uses `pathlib.Path`, not `os.path`
- [ ] Creates the JSON file automatically if it doesn't exist
- [ ] Reads and writes with `indent=2`
- [ ] Handles `FileNotFoundError` and `JSONDecodeError`

**`task_manager.py`**
- [ ] ID is auto-incremental and never reused
- [ ] Supports all commands from the `_CONTEXT.md`
- [ ] `update_task` modifies `updated_at`
- [ ] `delete_task` exists and works

**`main.py`**
- [ ] Uses `argparse` with subcommands (add, list, show, update, delete, stats)
- [ ] Each subcommand has its own specific arguments
- [ ] Errors display useful messages, not stack traces

**`tests/`**
- [ ] Uses `tmp_path` for storage, not the real directory
- [ ] Tests both positive cases and edge cases
- [ ] Each test is independent

> ⚠️ **Warning**: If you find an issue, don't modify the code by hand. Describe the problem to Copilot and ask it to fix it. This is the 0-code workflow.

---

## 5.4 — Testing and Execution

### 🔧 **Hands-on** — Testing

```bash
python -m pytest tests/ -v
```

If any test fails, copy the error and paste it into the Copilot chat:

```text
This test fails with the following error:
[paste the error]
Fix the code to make the test pass.
```

### 🔧 **Hands-on** — Using the Application

```bash
# Add tasks
python main.py add "Read chapter 6" -p high
python main.py add "Buy milk" --due 2026-04-01
python main.py add "Reply to emails" -d "Team emails" -p low

# List all
python main.py list

# Filter
python main.py list --status todo
python main.py list --priority high

# Detail
python main.py show 1

# Update
python main.py update 1 --status in_progress
python main.py update 1 --status done

# Statistics
python main.py stats

# Delete
python main.py delete 2
```

### 🎯 **CHECKPOINT**
If all commands work and the tests pass, you have a complete professional CLI application.

---

## 5.5 — Iteration: Adding Features

### 🔧 **Hands-on** — Export to Markdown Format

```text
Add an "export" command that exports all tasks to a Markdown file
formatted as a table.
Usage: python main.py export report.md
The file should contain a Markdown table with all tasks, organized
by priority (high → medium → low).
Add the corresponding tests.
```

### 🔧 **Hands-on** — Text Search

```text
Add a "search" command that searches through task titles and descriptions.
Usage: python main.py search "email"
The search must be case-insensitive.
Add the corresponding tests.
```

Every time you add a feature, the AI:
1. Reads the `_CONTEXT.md` to learn the conventions
2. Analyzes the existing code to integrate smoothly
3. Generates code consistent with the project's style
4. Adds tests

---

## 5.6 — The Pattern You'll Use Forever

This project established the pattern you'll follow throughout the book:

```text
1. _CONTEXT.md       → Define the project (5-15 min)
2. Proof of Value     → Generate a small piece and verify (5 min)
3. Generation         → The AI implements everything (10-20 min)
4. Review             → You check the quality (5-10 min)
5. Testing            → Verify it works (2-5 min)
6. Iteration          → Add features and fix issues (ongoing)
7. Update             → Improve the _CONTEXT.md (2 min)
```

This pattern scales: it works for a 200-line CLI tool just as well as for a 10,000-line full-stack web app.

---

## 5.7 — Lessons Learned (ADLC Phase 6)

### Update your `_CONTEXT.md` with these lessons (if you encountered them):

```markdown
## Lessons Learned
- Specifying the implementation order (storage → logic → UI → main → tests)
  improves the consistency of the generated code
- Tests with tmp_path must always create a fresh Storage instance
- argparse with subparsers requires set_defaults(func=...) for routing
- The AI tends to forget the y/N confirmation on deletion: include it in the constraints
```

---

## Project Summary

| Aspect | Detail |
|:--|:--|
| **Language** | Python 3.11+ |
| **Dependencies** | Zero (standard library only) |
| **Generated files** | ~7 files, ~400–600 total lines |
| **Tests** | ~15–20 test cases |
| **Total time** | ~30–45 minutes |
| **Code written by hand** | Only the `_CONTEXT.md` |

---

**→ In the next chapter**: we move to the web. You'll build your first REST API server with Node.js and Express — the foundation of the full-stack project that will grow in the following chapters.
