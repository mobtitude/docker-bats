<!-- SPDX-License-Identifier: MIT -->
# Bats Docker image

This repository provides a lightweight Alpine-based Docker image for [bats-core](https://github.com/bats-core/bats-core), [bats-support](https://github.com/bats-core/bats-support), [bats-assert](https://github.com/bats-core/bats-assert), [bats-file](https://github.com/bats-core/bats-file) and [bats-mock](https://github.com/mh182/bats-mock). It also bundles [jq](https://jqlang.org/) 1.8.2 for JSON processing in tests.

## Supported tags and respective Dockerfile links

- `ghcr.io/mobtitude/bats:0.4.0` [Dockerfile](Dockerfile)
- `ghcr.io/mobtitude/bats:0.3.0` [Dockerfile for 0.3.0](https://github.com/mobtitude/docker-bats/blob/0.3.0/Dockerfile)
- `ghcr.io/mobtitude/bats:0.2.0` [Dockerfile for 0.2.0](https://github.com/mobtitude/docker-bats/blob/0.2.0/Dockerfile)

Version 0.4.0 targets `linux/amd64` and `linux/arm64` under the same GHCR tags. Docker selects the matching platform automatically; pass `--platform linux/amd64` or `--platform linux/arm64` to select one explicitly. Emulation is required when running a different architecture.

## Bundled versions in 0.4.0

| Component | Version |
| --- | --- |
| Alpine | 3.24.3 |
| Bats | 1.14.0 |
| bats-support | 0.3.0 |
| bats-assert | 2.2.4 |
| bats-file | 0.4.0 |
| bats-mock | 0.2.1 |
| Bash | 5.3.9 |
| GNU Parallel | 20260322 |
| ncurses | 6.6_p20260516 |
| jq | 1.8.2 |

## Usage

### Command line

To run all Bats tests in the current directory, run the following command:

```bash
docker run -it --rm -v "$(pwd):/work" ghcr.io/mobtitude/bats:0.4.0 .
```

### GitHub Actions

To use `bats` within GitHub Actions, add the following job to your workflow file:

```yaml
bats:
  runs-on: ubuntu-latest
  steps:
  - name: Checkout
    uses: actions/checkout@v6
  - name: bats
    uses: docker://ghcr.io/mobtitude/bats:0.4.0
    with:
      args: '.'
```

## Examples

### Run Bats tests of a single test file

```bash
docker run -it --rm -v "$(pwd):/work" ghcr.io/mobtitude/bats:0.4.0 my-test.bats
```

### Use `bats` options

```bash
docker run -it --rm -v "$(pwd):/work" ghcr.io/mobtitude/bats:0.4.0 --recursive --tap .
```

### Show help message

```bash
docker run -it --rm ghcr.io/mobtitude/bats:0.4.0
```

### Show version

```bash
docker run -it --rm ghcr.io/mobtitude/bats:0.4.0 --version
```

### Process JSON with jq in a test

Save this as `json.bats`:

```bash
#!/usr/bin/env bats

@test "extract a value from JSON" {
  run jq -r '.name' <<< '{"name":"bats"}'
  [ "$status" -eq 0 ]
  [ "$output" = 'bats' ]
}
```

Run it with the Bats entrypoint:

```bash
docker run --rm -v "$(pwd):/work:ro" ghcr.io/mobtitude/bats:0.4.0 json.bats
```

The image runs as `nonroot` (UID/GID 65532) in `/work`. Mounted test files must be readable by this user; any output directories must be writable by it.

Load bundled helpers with `load '/opt/bats-support/load'`, `load '/opt/bats-assert/load'`, `load '/opt/bats-file/load'`, and `load '/opt/bats-mock/load'`. These paths are unchanged. Helper upgrades can change APIs; check your own suites when moving from 0.3.0.

## Development and validation

Install Docker with Buildx and Compose, and Go Task v3. Build and test the host platform with:

```bash
task docker:build DOCKER_TAG=0.4.0
task docker:test DOCKER_TAG=0.4.0
```

`PLATFORM` optionally selects a single platform for builds and tests; when omitted, Docker uses its default platform. `NO_CACHE=true` disables the build cache. Use separate image names to retain both variants locally:

```bash
for arch in amd64 arm64; do
  image="ghcr.io/mobtitude/bats:0.4.0-${arch}"
  task docker:build DOCKER_TAG=0.4.0 IMAGE_NAME="$image" PLATFORM="linux/$arch" NO_CACHE=true
  task docker:test DOCKER_TAG=0.4.0 IMAGE_NAME="$image" PLATFORM="linux/$arch"
done
```

The Compose suite checks jq, helper libraries, mocking and cleanup, parallel execution and failure propagation, and nonroot behavior with a read-only `/work`. The test task also checks default help with no arguments. Fixtures under `test/fixtures/` are invoked by the suites, not discovered recursively.

Run `task lint` after building, with the host tools required by the linter tasks installed. CI validates both architectures with runtime tests, Dockle, and Trivy. The release workflow requires the same checks before building the multi-platform GHCR image.

## Release

Local `DOCKER_TAG` defaults to the Bats version from `Dockerfile`, not the image release version, so use the explicit overrides above for 0.4.0. Release image versions continue to come from Git tags. To create and push the signed release tag after validation:

```bash
task git:create-tag GIT_TAG=0.4.0
task git:push-tag GIT_TAG=0.4.0
```

The tag-triggered workflow publishes to GHCR after both architectures pass validation. After publication, inspect the manifest and pull and test each variant explicitly:

```bash
docker buildx imagetools inspect ghcr.io/mobtitude/bats:0.4.0
for arch in amd64 arm64; do
  docker pull --platform "linux/$arch" ghcr.io/mobtitude/bats:0.4.0
  docker run --rm --platform "linux/$arch" ghcr.io/mobtitude/bats:0.4.0
  docker run --rm --platform "linux/$arch" -v "$(pwd)/test:/work:ro" ghcr.io/mobtitude/bats:0.4.0 --tap /work
done
```

## License

This project is licensed under the [MIT License](LICENSE).

View license information for [bats-core](https://github.com/bats-core/bats-core/blob/master/LICENSE.md), [bats-support](https://github.com/bats-core/bats-support/blob/master/LICENSE), [bats-assert](https://github.com/bats-core/bats-assert/blob/master/LICENSE) and [bats-file](https://github.com/bats-core/bats-file/blob/master/LICENSE).

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in the [repo-info repository's alpine/ directory](https://github.com/docker-library/repo-info/tree/master/repos/alpine).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
