# ADR-0001: ASDEV Platform Governance Model

- Status: Accepted
- Date: 2026-02-08
- Owners: ASDEV Platform maintainers

## Context

ASDEV operates across multiple repositories that need consistent engineering standards while preserving repository autonomy.

## Decision

Adopt a governance model with explicit policy and decision traceability:
- Policy-level decisions are captured as ADRs.
- Standards are versioned and mapped to policy references.
- Changes are distributed via PRs to consumer repositories.
- Consumer repository owners retain merge authority.

Decision hierarchy:
- ADRs (`governance/ADR/`) are the source of truth for policy.
- Standards (`standards/`) are implementation-level interpretation of policy.
- Templates and scripts (`platform/`) are operational helpers.

## Consequences

Positive:
- Improves auditability and reduces undocumented decision drift.
- Keeps repository ownership clear.
- Enables incremental rollout through advisory adoption.

Tradeoffs:
- Requires discipline in maintaining ADRs and standard references.
- Adds lightweight process overhead for policy-level changes.
