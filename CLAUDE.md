# Context Engineering Project Guidelines

## CRITICAL: Agent Workflow

YOU MUST use the specialized agents in `.claude/agents/` for ALL major tasks:

1. **Project Setup/New Features** → Use `pm` agent to manage TASK.md
2. **Feature Documentation** → Use `analyst` agent to create features/*.md from TASK.md
3. **Requirements Design** → Use `architect` agent to transform features/*.md → PRPs/*.md
4. **Implementation** → Use `dev` agent to execute PRPs with validation
5. **Verification** → Use `verifier` agent to confirm implementation ACTUALLY WORKS
6. **Bug Fixes** → Use `debugger` agent for single-pass debugging


### IMPORTANT: How Agents Work
- Agents are invoked using the Task tool with `subagent_type` parameter
- Agents CANNOT directly call other agents - they must instruct YOU to do it
- When an agent completes and says to use another agent, YOU must invoke it


## Project Structure Requirements

YOU MUST maintain this exact directory structure:

```
/
├── .claude/
│   ├── agents/         # Agent definitions (DO NOT MODIFY)
│   └── CLAUDE.md       # This file
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

### Task Execution Order
1. Read TASK.md for next incomplete task
2. Check if features/<N>-*.md exists
3. Check if PRPs/*.md exists
4. Use appropriate agent based on what's missing
5. After dev agent completes, invoke verifier agent
6. Only update TASK.md after verifier confirms success

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

## Agent-Specific Context

### Finding Project Details
- Project specifications → Read `project.md`
- Current tasks → Read `TASK.md`
- Feature details → Read `features/*.md`
- Implementation plans → Read `PRPs/*.md`
- Test commands → Check `project.md` or `package.json`

### When Starting Work
1. ALWAYS check TASK.md first
2. Identify appropriate agent for the task
3. Use agent rather than implementing directly
4. Verify work against acceptance criteria
5. Update TASK.md status

## Validation Gates

### Before Marking Complete
- [ ] All tests pass
- [ ] Linter has no errors
- [ ] Type checker passes
- [ ] Code follows project patterns
- [ ] Documentation updated if needed
- [ ] TASK.md status updated

## Error Recovery

### If Agent Fails
1. Check agent output for specific errors
2. Verify prerequisites exist (files, directories)
3. Try to fix and re-run agent
4. If still failing, document issue and continue

### If Structure Broken
1. Identify missing directories
2. Create required structure
3. Move misplaced files to correct locations
4. Update any broken references

## Communication

### Progress Updates
- Use concise, factual language
- Reference task numbers from TASK.md
- Include file paths when mentioning files
- Report blockers immediately

### Asking for Clarification
- Check project.md first
- Check TASK.md for context
- Check existing PRPs for patterns
- Then ask user with specific questions

## IMPORTANT Reminders

- YOU MUST use agents for feature work
- YOU MUST maintain directory structure
- YOU MUST keep tests in tests/ directory
- YOU MUST update TASK.md after completing tasks
- YOU MUST run quality checks before committing
- NEVER implement features without going through the Context Engineering workflow
- NEVER create files outside the defined structure
- NEVER commit without running tests and linters

## Quick Reference

### Agent Commands
```
# For new project or adding features
Use pm agent via Task tool

# For creating feature documentation
Use analyst agent via Task tool

# For creating PRPs
Use architect agent via Task tool  

# For implementing PRPs
Use dev agent via Task tool

# For fixing bugs
Use debugger agent via Task tool

This file is the source of truth for project organization. Follow it exactly.