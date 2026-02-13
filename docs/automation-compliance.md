# Automation Compliance Matrix

This document maps `CODEX_AUTOMATION_SPEC.md` acceptance criteria to executable checks in this repository.

## Acceptance Criteria Mapping

- Lint passes: `make lint`
- Typecheck passes: `make typecheck`
- Unit tests pass: `make test`
- E2E tests pass (if exist): no E2E suite currently exists in this repository
- Coverage >= defined threshold: `make coverage`
- Build succeeds: `make build`
- No security audit high-severity issues: `make security-audit`

## State Machine Execution

The deterministic verify entrypoint is:

```bash
make verify
```

`make verify` executes stage checks through `scripts/run-task.sh`, which enforces:

- task isolation per stage
- logs under `logs/{task-id}.log`
- retry cap (`TASK_MAX_RETRIES`, default `3`)
- halt escalation when the same failure fingerprint repeats twice

## Coverage Definition

This repository is script/governance-oriented and has no language-native line coverage tool in baseline dependencies.
Coverage is defined as a test inclusion ratio:

- covered: number of `tests/test_*.sh` files invoked by `tests/test_scripts.sh`
- total: number of `tests/test_*.sh` files excluding `tests/test_scripts.sh`

Threshold defaults to `90%` and is configurable via `COVERAGE_THRESHOLD`.

## Verification Commands

For mandatory hub verification:

```bash
make setup
make ci
make test
```

For full automation acceptance validation:

```bash
make verify
```
