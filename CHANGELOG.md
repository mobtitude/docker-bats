<!-- SPDX-License-Identifier: MIT -->
# Changelog

## 0.4.0

- Upgrade Alpine 3.22.7 to 3.24.3, Bats 1.8.1 to 1.14.0, bats-assert 0.3.0 to 2.2.4, bats-file 0.2.0 to 0.4.0, and bats-mock 0.2.0 to 0.2.1. Retain bats-support 0.3.0 and jq 1.8.2.
- Use maintained bats-core repositories for bats-support, bats-assert, and bats-file downloads.
- Update curl to `8.23.0-r0`, Bash to `5.3.9-r1`, GNU Parallel to `20260322-r0`, and ncurses to `6.6_p20260516-r0`, with matching pins on AMD64 and ARM64.
- Add AMD64 and ARM64 validation and multi-platform GHCR publication gated on runtime tests, Dockle, and Trivy for both architectures, including release tags.
- Update workflow actions to supported runtimes so the release and lint workflows can run.
- Add optional `PLATFORM` and `NO_CACHE` build controls and platform-aware tests; preserve local version defaults and Git-tag-based release versions.
- Add helper, mock cleanup, parallel execution, expected-failure, temporary-directory, read-only mount, and default-command checks. Prepare GNU Parallel's user directory for nonroot execution.
- Preserve `/opt` helper paths, the Bats entrypoint, default help, `/work`, and UID/GID 65532. Helper upgrades may require changes in downstream tests; validate existing suites before upgrading.

Local validation on 2026-10-27: no-cache builds, all 15 runtime tests, and default help passed on AMD64 and ARM64. Dockle passed with informational findings only; Trivy 0.76.1 reported zero vulnerabilities on both images. Hadolint, Markdown lint, YAML lint, and actionlint passed. A local OCI archive was verified to contain both platforms. Release tagging, publication, and post-publication checks remain pending.

## 0.3.0

- Add jq 1.8.2 (Alpine package `1.8.2-r0`) for JSON processing in Bats tests.
- Update the builder curl package pin from `8.14.1-r3` to `8.14.1-r4` to match the Alpine repository.
- Add runtime tests for jq version output, JSON extraction, invalid JSON, Bats help, and nonroot execution.
- Document `mobtitude/bats:0.3.0`, JSON testing, and volume mounts at `/work`.
- Preserve the existing Alpine, Bats, helper libraries, entrypoint, and release process. Publication is manual.

## 0.2.0

This entry is reconstructed from Git history and the locally available `mobtitude/bats:0.2.0` image. No Git release tags are available to establish exact release boundaries or publication dates.

- Switch from `grayhemp/bats-mock` 1.0-beta.1 to maintained `mh182/bats-mock` 0.2.0 and update the builder curl pin from `8.14.1-r2` to `8.14.1-r3` ([e218bf4](https://github.com/mobtitude/docker-bats/commit/e218bf4e9c06835c4ec6a6d2f28bd83f68fae75e)).
- Retain Bats 1.8.1, bats-support 0.3.0, bats-assert 0.3.0, and bats-file 0.2.0, as confirmed by the bundled metadata in the local image.
- Update the test task from `docker-compose` to `docker compose` ([144e98b](https://github.com/mobtitude/docker-bats/commit/144e98b14ff45c9870e165770725fc66d88f61be)).

## Earlier history

These changes are recorded in Git history, but their mapping to earlier image release versions is unavailable. Commit dates below are not publication dates.

- **2025-10-10:** Update Alpine from 3.17.2 to 3.22.2 and the curl, Bash, GNU Parallel, and ncurses package pins; fix bats-mock archive extraction ([d36437c](https://github.com/mobtitude/docker-bats/commit/d36437c78fd2c7fcc3346625dafb379649525cb3)).
- **2025-10-10:** Add `grayhemp/bats-mock` 1.0-beta.1 under `/opt/bats-mock` ([77606ee](https://github.com/mobtitude/docker-bats/commit/77606ee7f709810f7b3fe94141743b4c90a1f29c)).
- **2022-09-25:** Run the image as `nonroot` with UID/GID 65532 in `/work` ([c77b683](https://github.com/mobtitude/docker-bats/commit/c77b6834d7ddbc1f9a95eac8c9d97dba45a3fb1d)).
- **2020-04-24:** Introduce the Alpine-based image with Bats 1.1.0, bats-support 0.3.0, bats-assert 0.3.0, bats-file 0.2.0, Bash, GNU Parallel, and the Bats entrypoint with default help output ([036191e](https://github.com/mobtitude/docker-bats/commit/036191e97089c9bc8560a2d40f7a41cdf77e4588)).
