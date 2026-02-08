# Coding Standards Level 0 (Language-Agnostic)

- Status: Active
- Version: 1.0.0
- Source ADRs: ADR-0001, ADR-0002

## Goals

Provide a low-friction baseline that can be applied to all repositories regardless of tech stack.

## Requirements

### Must

- Repository contains a minimum `README.md` structure.
- Repository has a pull request template.
- Repository has baseline issue templates for bug and feature request.
- Repository has a minimum `CONTRIBUTING.md`.
- Repository has a lightweight CI sanity workflow (lint/test placeholders).

### Should

- Commit and branch naming follow documented conventions.
- CI workflow should be extended with stack-specific jobs.

### Optional

- `.editorconfig`
- `CODEOWNERS`

## Naming Conventions

- Branch: `type/short-description` (example: `chore/asdev-sync-20260208`)
- Commit: Conventional Commits (example: `chore: sync ASDEV Level 0 templates`)
- PR title: concise and traceable to standard/adrs
