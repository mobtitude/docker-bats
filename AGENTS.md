# Repository Guidelines

## Project Structure & Module Organization

This repository packages Bats and its support libraries in an Alpine-based Docker image. `Dockerfile` defines the builder and runtime stages, pinned dependency versions, and Bats entrypoint. `Taskfile.yml` exposes development commands through Go Task; `tasks/` contains tool-specific task definitions. `test/docker-compose.test.yml` provides the image smoke test. `.github/workflows/` contains build, lint, scan, and release automation; `.github/linters/` holds lint configuration. There is no separate application source or asset directory.

## Build, Test, and Development Commands

Install Docker with Buildx and Compose, plus Go Task v3.

- `task` lists available tasks.
- `task docker:build` builds and tags the image using `BATS_CORE_VERSION` from `Dockerfile`, including a `latest` tag.
- `task docker:test` runs the Compose smoke test, invoking Bats with `--help`.
- `task lint` runs Dockle, Hadolint, markdownlint, Trivy, and yamllint. Build the image first; install the host tools required by their task definitions.
- `task hadolint:lint`, `task markdownlint:lint`, and `task yamllint:lint` run individual checks.

## Coding Style & Naming Conventions

Use two-space YAML indentation, with sequence markers aligned to their parent key. Prefer single quotes for YAML strings. Follow `.github/linters/` configuration. Keep Dockerfile instructions uppercase, version arguments in `UPPER_SNAKE_CASE`, and multiline shell continuations aligned with existing instructions. Preserve SPDX license headers. Name task modules `tasks/<Tool>Tasks.yml` and expose commands through their existing namespaces.

## Testing Guidelines

The current automated test checks container startup and Bats help output; no coverage threshold is configured. Run `task docker:build` and `task docker:test` after image changes. For additional behavioral coverage, use descriptive `*.bats` files under `test/` and wire them into the test command. Verify affected support libraries when updating their versions.

## Commit & Pull Request Guidelines

History uses short, descriptive subjects such as “Fixed build.” and “Updated README.” Follow that style and keep commits focused. Pull requests should explain the change, link relevant issues, and report build, test, and lint results. For dependency updates, identify changed versions and update usage documentation when behavior changes.
