# Repository Guidelines

## Project Structure & Module Organization
This repository is currently a clean scaffold with no committed source files yet. Use the structure below as the default layout for new work:
- `src/`: application code organized by feature (for example, `src/auth/`, `src/api/`).
- `tests/`: automated tests mirroring `src/` paths.
- `assets/`: static assets (images, fixtures, sample data).
- `scripts/`: local automation (build/test helpers, migration scripts).
- `docs/`: design notes, architecture decisions, and onboarding docs.

Keep modules small and cohesive. Prefer feature-first folders over large utility dumps.

## Build, Test, and Development Commands
No build tooling is configured yet. When initializing the project, expose a minimal, consistent command set:
- `make setup`: install dependencies and prepare local tooling.
- `make test`: run the full automated test suite.
- `make lint`: run static checks/format validation.
- `make run`: start the app locally.

If `make` is not used, provide equivalent `npm`, `pytest`, or language-native commands in `README.md`.

## Coding Style & Naming Conventions
- Use 4 spaces for Python, 2 spaces for JavaScript/TypeScript/JSON/YAML.
- File and module names: `snake_case` for Python, `kebab-case` for frontend assets, `PascalCase` for React components/classes.
- Function names: descriptive verbs (`create_user`, `fetchMetrics`).
- Run formatter/linter before pushing (for example, `ruff format`, `eslint --fix`, `prettier --write`).

## Testing Guidelines
Place tests under `tests/` with names matching source modules:
- Python: `tests/test_<module>.py`
- JS/TS: `<name>.test.ts` or `<name>.spec.ts`

Add unit tests for all new logic and regression tests for bug fixes. Target meaningful coverage on changed code, not only global percentages.

## Commit & Pull Request Guidelines
Git history is not available yet, so adopt Conventional Commits from the start:
- `feat: add user session validator`
- `fix: handle null API response`
- `docs: add local setup steps`

PRs should include:
- concise summary of what changed and why,
- linked issue/ticket (if applicable),
- test evidence (command + result),
- screenshots for UI changes.

## Security & Configuration Tips
Never commit secrets. Keep local overrides in ignored files such as `.env.local`. Document required environment variables in `.env.example` as the project grows.
