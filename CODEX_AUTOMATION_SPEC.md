# CODEX AUTOMATION SYSTEM SPECIFICATION

## OBJECTIVE

Turn Codex CLI into a deterministic, multi-stage, self-correcting software automation system capable of:

- Planning changes
- Implementing code
- Running tests
- Debugging failures
- Updating documentation
- Verifying stability
- Preparing PR-ready commits

---

## REPOSITORY CONTRACT

Codex MAY modify:

- src/**
- app/**
- lib/**
- tests/**
- docs/**
- scripts/**
- CHANGELOG.md
- README.md

Codex MUST NOT modify:

- ops/systemd/**
- ops/nginx/**
- .github/workflows/** (unless task explicitly requests CI change)
- package-lock.json / pnpm-lock.yaml / bun.lockb (except dependency updates)
- .env files

---

## PIPELINE STATE MACHINE

States:

1. PLAN
2. IMPLEMENT
3. TEST
4. DEBUG
5. DOCS
6. VERIFY
7. DONE
8. HALT

Transitions:

PLAN → IMPLEMENT (if plan approved or auto-approved)
IMPLEMENT → TEST (if no syntax errors)
TEST → DOCS (if all tests pass)
TEST → DEBUG (if tests fail)
DEBUG → TEST (retry)
DOCS → VERIFY
VERIFY → DONE (if all checks pass)
VERIFY → DEBUG (if regression detected)
Any state → HALT (if human approval required)

---

## FAILURE POLICY

- Max retry cycles per task: 3
- If same error repeats 2 times → escalate to HALT
- Never bypass failing test without modifying test OR code

---

## ACCEPTANCE CRITERIA

A change is valid only if:

- Lint passes
- Typecheck passes
- Unit tests pass
- E2E tests pass (if exist)
- Coverage ≥ defined threshold
- Build succeeds
- No security audit high-severity issues

---

## DOCUMENTATION RULE

After code modification:

- Update CHANGELOG.md (Keep a Changelog format)
- Update README if public behavior changed
- Add inline comments for non-obvious logic

---

## MULTI-TASK EXECUTION RULE

- Each task runs isolated
- Logs stored in logs/{task-id}.log
- Failures do not block unrelated tasks

---

## SECURITY GUARDRAILS

- No system-level modification
- No destructive file operations outside allowed paths
- No dependency installation without audit
- Rate limit external API calls
- Respect GitHub and OpenAI token limits

---

## STOP CONDITIONS

Codex must stop and request human input if:

- Ambiguous requirements
- Conflicting architectural decisions
- Security-sensitive file modification required
- Schema migration without migration plan
- Breaking public API

---

## SUCCESS METRICS

- Zero test regression
- Zero lint errors
- Stable build
- No coverage drop > 5%
- No new security vulnerabilities
