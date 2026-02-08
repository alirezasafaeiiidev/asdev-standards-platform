# ASDEV Platform

ASDEV Platform is a multi-repo standards and governance hub focused on standardization without monorepo lock-in.

## Scope

This repository defines:
- Governance policy and architecture decisions (`governance/`)
- Technical standards (`standards/`)
- Reusable templates and helper tooling (`platform/`)
- Sync configuration and rollout artifacts (`sync/`)

This repository does not own consumer-repo business logic.

## Repository Layout

```text
asdev_platform/
├─ governance/
├─ standards/
├─ platform/
├─ sync/
├─ brand/
├─ src/
├─ tests/
├─ docs/
├─ scripts/
└─ assets/
```

## Quickstart

```bash
make setup
make lint
make test
make run
```

## Phase B Deliverables

- ADR-based governance and scope lock
- Level 0 language-agnostic standards
- Versioned repo templates with source traceability
- Sync MVP scripts for PR-driven adoption and divergence reporting
