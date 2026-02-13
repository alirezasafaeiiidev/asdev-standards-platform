# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Added `CODEX_AUTOMATION_SPEC.md` as the in-repository automation contract.
- Added deterministic automation compliance mapping in `docs/automation-compliance.md`.
- Added new verification scripts:
  - `scripts/run-task.sh`
  - `scripts/typecheck.sh`
  - `scripts/build-check.sh`
  - `scripts/security-audit.sh`
  - `scripts/check-coverage-threshold.sh`
- Added make targets for acceptance gates: `typecheck`, `e2e`, `build`, `security-audit`, `coverage`, and `verify`.
- Added contract tests for verification wiring, task logging, coverage threshold, and security-audit behavior.
- Added new sync templates:
  - `platform/repo-templates/AGENTS.md`
  - `platform/repo-templates/CODEX_AUTOMATION_SPEC.md`
- Added new template IDs:
  - `agents-runtime-guidance`
  - `codex-automation-spec`
- Added brand attribution standard and rollout assets:
  - `standards/branding/brand-attribution-v1.md`
  - `platform/repo-templates/brand/v1/README.md`
  - `platform/repo-templates/brand/v1/src/lib/brand.ts`
  - `platform/repo-templates/brand/v1/src/components/brand/BrandFooter.tsx`
  - `platform/repo-templates/brand/v1/src/components/brand/BrandLink.tsx`
  - `docs/brand-rollout.md`
- Added brand template IDs in `platform/repo-templates/templates.yaml`:
  - `brand-v1-lib`
  - `brand-v1-footer`
  - `brand-v1-link`

### Changed
- Updated `README.md` quickstart and automation verification guidance to include new acceptance-gate commands.
- Updated all sync target manifests to roll out `AGENTS.md` and `CODEX_AUTOMATION_SPEC.md` across target repositories.
- Added execution status report for technical_execution_docs_v2 rollout:
  - `docs/technical-execution-v2-status-2026-02-13.md`
- Updated `README.md` with Technical Execution v2 references and rollout PR pointers.
- Updated `sync/targets.yaml` labels for brand rollout tracking.
