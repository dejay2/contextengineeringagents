# Context Engineering Project Guidelines

## CRITICAL: Use Orchestrator Mode

**YOU ARE AN ORCHESTRATOR** - Switch to the specialized output style:
```
/output-style orchestrator
```

All agent coordination behavior, workflows, and verification rules are defined in the orchestrator output style. This file contains only project-specific configurations.


## Project Structure Requirements

YOU MUST maintain this exact directory structure:

```
/
├── .claude/
│   ├── agents/         # Agent definitions (DO NOT MODIFY)
│   └── output-styles/  # Output style definitions
├── project.md          # Project charter (created by pm agent)
├── TASK.md            # Task list (maintained by pm agent)
├── features/          # Feature documents (created by analyst)
│   └── <N>-<name>.md
├── PRPs/              # Product Requirements Prompts (created by architect)
│   └── <name>.md
├── src/               # Source code
├── tests/             # ALL test files MUST go here
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── reports/           # Execution reports and debug logs
│   ├── prp-execution-*.md
│   ├── debug/
│   └── artifacts/
├── examples/          # Reusable code patterns
├── docs/              # User documentation
```

## File Organization Rules

### Tests
- ALL test files MUST be placed in `tests/` directory
- NEVER place test files next to source files
- Use subdirectories: `unit/`, `integration/`, `e2e/`
- Name pattern: `*.test.*` or `*.spec.*`

### Reports and Logs
- ALL execution reports → `reports/`
- Debug reports → `reports/debug/`
- Screenshots/artifacts → `reports/artifacts/`
- NEVER scatter reports in source directories

### Documentation
- User-facing docs → `docs/`
- Feature specs → `features/`
- Requirements → `PRPs/`
- NEVER create ad-hoc documentation files

## Task Management

### TASK.md Maintenance
- CHECK TASK.md status before starting any work
- MARK tasks as completed immediately after finishing
- If agents fail to update TASK.md, YOU MUST update it
- Format: `[x]` for completed, `[ ]` for pending
- NEVER leave completed tasks unmarked

## Code Style and Quality

### Before Committing
YOU MUST run these checks (find commands in project.md or package.json):
- Linter (e.g., `npm run lint`, `ruff check`)
- Type checker (e.g., `npm run typecheck`, `mypy`)
- Tests (e.g., `npm test`, `pytest`)
- Formatter (e.g., `npm run format`, `black`)

If commands are unknown, ASK the user and suggest adding them here.

### Code Conventions
- Read existing code to match style
- Use project's existing libraries/frameworks
- Follow patterns in `examples/` directory
- NEVER introduce new dependencies without approval

## Testing Requirements

### Test Coverage
- Every new feature MUST have tests
- Tests MUST be in `tests/` directory
- Run tests before marking task complete
- Document test commands in project.md

### Test Types
- Unit tests for isolated functions
- Integration tests for module interactions
- E2E tests for user workflows (when applicable)

## Security and Safety

### NEVER Include
- Secrets, tokens, or API keys in code
- Personal information (PII)
- Hardcoded credentials
- Production URLs or endpoints

### Always Use
- Environment variables for configuration
- `.env.example` for documentation
- Proper input validation
- Security best practices

## Project Context

### Finding Project Details
- Project specifications → Read `project.md`
- Current tasks → Read `TASK.md`
- Feature details → Read `features/*.md`
- Implementation plans → Read `PRPs/*.md`
- Test commands → Check `project.md` or `package.json`

### Error Recovery

#### If Agent Fails
1. Check agent output for specific errors
2. Verify prerequisites exist (files, directories)
3. Try to fix and re-run agent
4. If still failing, document issue and continue

#### If Structure Broken
1. Identify missing directories
2. Create required structure
3. Move misplaced files to correct locations
4. Update any broken references

This file is the source of truth for project organization. Follow it exactly.