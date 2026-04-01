import re

file_path = r"c:\workspace\ADLC\example_contracts\WORKFLOW.md"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

old_section_pattern = r"## Complete Session Examples.*?(?=## Golden Rules for the Human)"

new_section = """\
## Complete Session Examples

### Example A: Analysis & Design Session (Phase 0-2)

```
HUMAN:   [opens chat \u2014 new project, no _CONTEXT.md yet]
AGENT:   "No _CONTEXT.md found. Starting Discovery (Phase 0).
          SKILL loaded: analysis.md
          I'll help define the domain. What is the project about?"