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

### Changed
- Updated `README.md` quickstart and automation verification guidance to include new acceptance-gate commands.
