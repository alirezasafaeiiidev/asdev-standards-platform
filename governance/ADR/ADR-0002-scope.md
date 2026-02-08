# ADR-0002: Scope Lock for ASDEV Platform

- Status: Accepted
- Date: 2026-02-08
- Owners: ASDEV Platform maintainers

## Context

Without an explicit scope boundary, standards initiatives often drift into product logic, creating friction and low adoption.

## Decision

Lock ASDEV Platform scope as follows.

In scope:
- Governance and decision records
- Cross-repository engineering standards
- Reusable templates for docs, issue/PR workflows, and CI baseline
- Sync automation and divergence reporting

Out of scope:
- Product/business logic in consumer repositories
- Mandatory enforcement that blocks consumer development flow
- Vendor lock-in requirements that violate local-first principles

Operational constraints:
- Distribution model is PR-only.
- Merge is optional for consumer owners.
- Non-adoption is reported as divergence, not forced compliance.

## Consequences

Positive:
- Prevents ASDEV from becoming a central gatekeeping bottleneck.
- Keeps adoption collaborative and low-risk.

Tradeoffs:
- Consistency may converge slower than mandatory gating.
- Requires recurring sync/report cycles to manage drift.
