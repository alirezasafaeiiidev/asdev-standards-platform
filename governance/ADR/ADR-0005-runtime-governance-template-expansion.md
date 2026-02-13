# ADR-0005: Runtime Governance Template Expansion

- Status: Accepted
- Date: 2026-02-13

## Context

Cross-repository automation requires a stable runtime contract and shared execution guardrails.
Existing template rollout covered `AGENT.md`, but did not guarantee presence of:

- `AGENTS.md` runtime guidance compatibility file
- `CODEX_AUTOMATION_SPEC.md` deterministic execution contract

This created drift risk across target repositories.

## Decision

Add and enforce two new template IDs in `platform/repo-templates/templates.yaml`:

- `agents-runtime-guidance` -> `AGENTS.md`
- `codex-automation-spec` -> `CODEX_AUTOMATION_SPEC.md`

Roll out both template IDs across all sync target manifests (`sync/targets*.yaml`) so updates are centrally managed via sync automation.

## Consequences

- Positive:
  - Consistent runtime governance and automation behavior across repos.
  - Lower onboarding ambiguity for codex/agent execution.
  - Traceable policy updates through template versioning and sync PRs.
- Tradeoffs:
  - Repositories must accept additional policy files in root.
  - Template-manifest changes require ADR updates (this document).

## Verification

- `make lint`
- `make test`
- successful sync PR creation for target repositories
