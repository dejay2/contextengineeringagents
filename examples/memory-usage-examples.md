# Memory Agent Usage Examples

## Example 1: Starting Work with Lock Check

### Scenario
Developer wants to work on task-001 (authentication feature).

### Memory Agent Prompt
```
Check if task-001 is available for work and retrieve any existing context about authentication decisions.
```

### Memory Agent Actions
```python
# 1. Check for existing locks
lock_file = "memory-bank/myproject/task-locks/task-001-*.json"
if exists(lock_file):
    lock_data = read(lock_file)
    if lock_age < 2_hours:
        return "Task-001 is locked by {lock_data.locked_by} since {lock_data.locked_at}"
    else:
        archive_stale_lock(lock_file)

# 2. Create new lock
new_lock = {
    "task_id": "001",
    "task_name": "authentication-feature",
    "locked_by": "analyst",
    "locked_at": "2024-01-20T10:30:00Z",
    "expected_duration": "45m"
}
write("memory-bank/myproject/task-locks/task-001-{timestamp}.json", new_lock)

# 3. Retrieve context
pm_context = read("memory-bank/myproject/agent-context/pm-decisions.json")
related_context = search_context("authentication", "security", "user-management")

return context_summary
```

## Example 2: Storing Architect Decisions

### Scenario
Architect agent has decided on JWT authentication with refresh tokens.

### Memory Agent Prompt
```
Store architecture decisions for task-001: chose JWT with refresh tokens over session-based auth.
```

### Memory Agent Actions
```python
# Store decision with full rationale
architect_context = {
    "agent": "architect",
    "task_id": "001",
    "timestamp": "2024-01-20T11:30:00Z",
    "decisions": [
        {
            "decision": "Use JWT for authentication",
            "rationale": "Stateless, scalable, works with microservices",
            "alternatives_considered": [
                "Session-based: Rejected due to scaling complexity",
                "OAuth-only: Overkill for internal users"
            ],
            "tradeoffs": "Need secure token storage on client"
        },
        {
            "decision": "Implement refresh token rotation",
            "rationale": "Security best practice, limits token exposure",
            "implementation_notes": "15min access token, 7day refresh token"
        }
    ],
    "constraints_discovered": [
        "Must support mobile apps (no secure cookie storage)",
        "Need to handle concurrent sessions"
    ],
    "next_agent_notes": "Dev must implement token blacklist for logout"
}

update("memory-bank/myproject/agent-context/architect-rationale.json", architect_context)
```

## Example 3: Handling Implementation Blocker

### Scenario
Dev agent discovers the chosen auth library doesn't support refresh token rotation.

### Memory Agent Prompt
```
Dev agent blocked on task-001: auth library missing refresh token rotation. Need architect review.
```

### Memory Agent Actions
```python
# 1. Store blocker with context
blocker = {
    "task_id": "001",
    "agent": "dev",
    "timestamp": "2024-01-20T14:00:00Z",
    "blocker_type": "technical_constraint",
    "description": "jsonwebtoken library doesn't support automatic refresh rotation",
    "attempted_solutions": [
        "Tried jsonwebtoken@9.0.0 - no rotation support",
        "Checked node-jsonwebtoken - same limitation"
    ],
    "needs_decision_from": "architect",
    "suggested_alternatives": [
        "Implement custom rotation logic",
        "Switch to auth0 library",
        "Use Passport.js with JWT strategy"
    ],
    "current_progress": "Basic JWT generation working, rotation blocked"
}

write("memory-bank/myproject/blockers/task-001-refresh-rotation.json", blocker)

# 2. Create checkpoint for rollback
checkpoint = {
    "task_id": "001",
    "timestamp": "2024-01-20T14:00:00Z",
    "git_commit": "a3f4b5c",
    "files_modified": ["src/auth/jwt.service.ts", "src/auth/auth.module.ts"],
    "can_resume": true,
    "resume_notes": "Basic JWT working, awaiting rotation decision"
}

write("memory-bank/myproject/checkpoints/{timestamp}-task-001.json", checkpoint)

# 3. Update task lock status
update_lock("task-001", {"status": "blocked", "blocked_reason": "library_limitation"})
```

## Example 4: Debugger Retrieving Full Context

### Scenario
User reports "Login fails with 'invalid signature' error after 15 minutes".

### Memory Agent Prompt
```
Retrieve all context about authentication implementation for debugging login signature error.
```

### Memory Agent Actions
```python
# Retrieve complete context chain
context = {
    "pm_decisions": read("pm-decisions.json").filter("authentication"),
    "analyst_specs": read("analyst-discoveries.json").filter("task_001"),
    "architect_design": read("architect-rationale.json").filter("JWT"),
    "dev_implementation": read("dev-implementation.json").filter("token"),
    "previous_bugs": search("jwt", "signature", "token", "refresh")
}

# Analyze for relevant insights
insights = [
    "Architect specified 15min access token expiry",
    "Dev implemented refresh at 14min mark",
    "Previous bug: Clock skew caused signature failures",
    "Validation gate: 'Test token refresh at boundary conditions'"
]

# Provide focused debug context
debug_context = {
    "likely_cause": "Token refresh happening after expiry, not before",
    "relevant_code": "src/auth/jwt.service.ts:refreshToken()",
    "test_to_check": "tests/unit/auth/token-refresh.spec.ts",
    "prior_decision": "15min expiry was firm requirement from PM",
    "suggested_fix": "Refresh at 13min instead of 14min"
}

return debug_context
```

## Example 5: Validation Gate Recording

### Scenario
PRP validation completed for authentication feature.

### Memory Agent Prompt
```
Record validation results for authentication PRP: passed with minor warnings.
```

### Memory Agent Actions
```python
validation_result = {
    "artifact": "PRPs/authentication.md",
    "validated_at": "2024-01-20T12:00:00Z",
    "validated_by": "architect",
    "status": "passed",
    "scores": {
        "completeness": 95,
        "clarity": 90,
        "testability": 100,
        "security": 85
    },
    "warnings": [
        "Consider adding rate limiting to prevent brute force",
        "Document token storage requirements for mobile"
    ],
    "required_fixes": [],
    "optional_improvements": [
        "Add sequence diagram for token refresh flow",
        "Include performance benchmarks"
    ],
    "ready_for_next_stage": true
}

write("memory-bank/myproject/validation-gates/prp-authentication.json", validation_result)
```

## Example 6: Parallel Work Coordination

### Scenario
Two developers trying to work simultaneously.

### Developer A Memory Request
```
Start work on task-001 (authentication).
```

### Developer B Memory Request (2 minutes later)
```
Start work on next available task.
```

### Memory Agent Coordination
```python
# For Developer A
task_001_lock = create_lock("task-001", "developer-a")
# Returns: "Lock acquired for task-001"

# For Developer B (2 minutes later)
available_tasks = []
for task in read_tasklist():
    if not has_lock(task):
        available_tasks.append(task)

# Returns: "Task-001 is locked by developer-a. Available tasks: task-002, task-003"
suggested_task = "task-002"
task_002_lock = create_lock("task-002", "developer-b")
# Returns: "Lock acquired for task-002"
```

## Example 7: Recovery After Failure

### Scenario
Dev agent crashed while implementing task-003.

### Memory Agent Prompt
```
Recover context and checkpoint for failed task-003 implementation.
```

### Memory Agent Actions
```python
# 1. Find last checkpoint
checkpoint = read_latest("checkpoints/task-003-*.json")

# 2. Retrieve execution history
history = read("execution-history/task-003-*.json")
last_successful_step = history.last_success

# 3. Get partial progress
partial_context = {
    "completed_steps": history.completed_steps,
    "failed_at": "Step 4: Database migration",
    "error": "Connection timeout during migration",
    "last_checkpoint": checkpoint.timestamp,
    "files_modified": checkpoint.files_modified,
    "can_resume_from": "Step 4 with increased timeout",
    "git_commit": checkpoint.git_commit
}

# 4. Provide recovery plan
recovery_plan = {
    "restore_from": checkpoint.git_commit,
    "skip_steps": history.completed_steps,
    "resume_at": "Step 4",
    "modifications_needed": {
        "database_timeout": "30s -> 60s"
    },
    "context_preserved": true
}

return recovery_plan
```

## Example 8: Cross-Feature Context

### Scenario
Working on payment feature that needs auth context.

### Memory Agent Prompt
```
Retrieve authentication implementation details needed for payment feature integration.
```

### Memory Agent Actions
```python
# Find related features
auth_context = {
    "implementation": read("agent-context/dev-implementation.json").filter("auth"),
    "interfaces": extract_interfaces("JWT", "User", "Session"),
    "decisions": read("architect-rationale.json").filter("auth")
}

# Extract integration points
integration_points = {
    "jwt_validation": {
        "endpoint": "/api/auth/validate",
        "method": "validateToken(token: string): User",
        "location": "src/auth/jwt.service.ts"
    },
    "user_context": {
        "shape": "{ id: string, email: string, roles: string[] }",
        "retrieval": "getCurrentUser(): Promise<User>"
    },
    "required_headers": {
        "authorization": "Bearer {access_token}"
    },
    "token_refresh": {
        "endpoint": "/api/auth/refresh",
        "timing": "Every 13 minutes"
    }
}

# Provide payment-specific guidance
payment_context = {
    "auth_integration": integration_points,
    "security_requirements": [
        "Validate token before processing payment",
        "Check user has 'payment' role",
        "Log all payment attempts with user ID"
    ],
    "prior_decisions": [
        "All payment APIs require valid JWT",
        "Payment history linked to user.id"
    ]
}

return payment_context
```

## Example 9: Clean Up Stale Locks

### Scenario
Maintenance task to clean up abandoned locks.

### Memory Agent Prompt
```
Clean up stale locks and archive old memory records.
```

### Memory Agent Actions
```python
# 1. Find and clean stale locks
stale_locks = []
for lock_file in list("task-locks/*.json"):
    lock = read(lock_file)
    age = now() - lock.locked_at
    
    if age > hours(2):
        stale_locks.append(lock)
        archive("task-locks/archive/", lock_file)
        delete(lock_file)

# 2. Archive old execution history (>30 days)
for history_file in list("execution-history/*.json"):
    if age_of(history_file) > days(30):
        archive("execution-history/archive/", history_file)

# 3. Compress old checkpoints
old_checkpoints = list("checkpoints/*.json").filter(age > days(7))
compress_and_archive(old_checkpoints)

# 4. Report
cleanup_report = {
    "stale_locks_removed": len(stale_locks),
    "locks_details": stale_locks,
    "history_archived": count_archived("execution-history"),
    "checkpoints_compressed": len(old_checkpoints),
    "space_recovered": "124MB",
    "next_cleanup": now() + days(7)
}

return cleanup_report
```

## Example 10: Project-Wide Memory Status

### Scenario
Get overview of all memory records for project health check.

### Memory Agent Prompt
```
Provide memory status overview for the entire project.
```

### Memory Agent Actions
```python
status = {
    "project": "myproject",
    "timestamp": now(),
    
    "active_locks": [
        {"task": "004", "locked_by": "dev", "duration": "23m"},
        {"task": "005", "locked_by": "analyst", "duration": "5m"}
    ],
    
    "recent_blockers": [
        {"task": "003", "reason": "Missing dependency", "age": "2h"}
    ],
    
    "validation_gates": {
        "passed": 12,
        "failed": 1,
        "pending": 3
    },
    
    "agent_activity": {
        "last_24h": {
            "pm": 1,
            "analyst": 4,
            "architect": 3,
            "dev": 5,
            "debugger": 2
        }
    },
    
    "context_stats": {
        "total_decisions": 47,
        "total_discoveries": 89,
        "total_blockers_resolved": 8,
        "checkpoints_available": 15
    },
    
    "health_indicators": {
        "lock_conflicts": 0,
        "context_gaps": 0,
        "stale_locks": 0,
        "memory_size": "42MB",
        "status": "healthy"
    }
}

return status
```

## Common Patterns

### Pattern 1: Lock-Check-Work-Release
```
1. Memory: Check lock availability
2. Memory: Create lock
3. Agent: Do work
4. Memory: Store context
5. Memory: Release lock
```

### Pattern 2: Context Chain Retrieval
```
1. Memory: Get PM requirements
2. Memory: Get analyst discoveries  
3. Memory: Get architect decisions
4. Combine into unified context
5. Provide to requesting agent
```

### Pattern 3: Validation Gate Flow
```
1. Agent: Complete artifact
2. Memory: Run validation
3. Memory: Store results
4. Memory: Trigger next agent if passed
5. Memory: Report blockers if failed
```

### Pattern 4: Blocker Resolution
```
1. Agent: Hit blocker
2. Memory: Store blocker context
3. Memory: Create checkpoint
4. Memory: Alert relevant agent
5. Resolution agent: Retrieve context
6. Resolution agent: Fix issue
7. Memory: Clear blocker
8. Original agent: Resume from checkpoint
```

## Tips for Effective Memory Usage

1. **Always provide task context** when requesting locks
2. **Store why, not just what** in decisions
3. **Create checkpoints before risky operations**
4. **Clean up locks immediately** after completion
5. **Use descriptive blocker messages** for faster resolution
6. **Archive old memory regularly** to maintain performance
7. **Check for related context** beyond just the current task
8. **Validate memory writes** succeeded before proceeding
9. **Include timestamps** in all memory records
10. **Document assumptions** as they may change