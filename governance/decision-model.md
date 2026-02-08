# Decision Model

## Policy vs Standard vs Implementation

- Policy (`governance/`): mandatory principles and organizational constraints.
- Standard (`standards/`): technical conventions derived from policy.
- Implementation helper (`platform/`): templates/scripts that operationalize standards.

## Requirement Levels

- Must: governance-critical baseline. In Phase B, still distributed as advisory PRs.
- Should: strongly recommended quality improvements.
- Optional: repo-specific optimizations.

## Change Control

- Policy changes require ADR updates.
- Standard changes require reference to governing ADR(s).
- Template/script changes require reference to both standard and ADR source.
