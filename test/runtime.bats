#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

@test "jq reports the bundled version" {
  run jq --version
  [ "$status" -eq 0 ]
  [ "$output" = 'jq-1.8.2' ]
}

@test "jq extracts a value from JSON" {
  run jq -r '.name' <<< '{"name":"bats"}'
  [ "$status" -eq 0 ]
  [ "$output" = 'bats' ]
}

@test "jq fails on invalid JSON" {
  run jq . <<< '{"name":'
  [ "$status" -ne 0 ]
  [[ "$output" == *'parse error'* ]]
}

@test "Bats runs as the nonroot user in /work" {
  [ "$(id -un)" = 'nonroot' ]
  [ "$(id -u)" -eq 65532 ]
  [ "$(id -g)" -eq 65532 ]
  [ "$PWD" = '/work' ]
}

@test "Bats reports the bundled version" {
  run bats --version
  [ "$status" -eq 0 ]
  [ "$output" = 'Bats 1.14.0' ]
}

@test "test files are read-only and temporary directories are writable" {
  run touch /work/.write-test
  [ "$status" -ne 0 ]
  [[ "$output" == *'Read-only file system'* ]]
  [ -w "$BATS_TEST_TMPDIR" ]
  touch "$BATS_TEST_TMPDIR/writable"
  [ -f "$BATS_TEST_TMPDIR/writable" ]
}

@test "GNU Parallel user directory is writable" {
  [ -w "$HOME/.parallel" ]
  [ -f "$HOME/.parallel/will-cite" ]
}

@test "Bats displays help" {
  run bats --help
  [ "$status" -eq 0 ]
  [[ "$output" == *'Usage:'* ]]
}
