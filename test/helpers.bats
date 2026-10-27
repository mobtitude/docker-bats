#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

setup() {
  load '/opt/bats-support/load'
  load '/opt/bats-assert/load'
  load '/opt/bats-file/load'
  load '/opt/bats-mock/load'
}

@test "bats-support formats failures" {
  run fail 'support failure'
  [ "$status" -eq 1 ]
  [[ "$output" == *'support failure'* ]]
}

@test "bats-assert checks command status and output" {
  run printf '%s\n' 'helper libraries loaded'
  assert_success
  assert_output 'helper libraries loaded'
}

@test "bats-file checks temporary file creation and removal" {
  local file="$BATS_TEST_TMPDIR/helper-file"
  touch "$file"
  assert_file_exist "$file"
  rm "$file"
  assert_file_not_exist "$file"
}

@test "bats-mock configures and records invocations" {
  local mock
  mock=$(mock_create)
  mock_set_output "$mock" 'mock response'
  mock_set_status "$mock" 7

  run "$mock" first second
  assert_failure 7
  assert_output 'mock response'
  [ "$(mock_get_call_num "$mock")" -eq 1 ]
  [ "$(mock_get_call_args "$mock")" = 'first second' ]
}

@test "Bats cleans up mocks after a nested suite" {
  local tmpdir="$BATS_TEST_TMPDIR/nested"
  mkdir "$tmpdir"
  run env BATS_TMPDIR="$tmpdir" bats --tap /work/fixtures/mock-cleanup.bats
  assert_success
  [[ "$output" == *'ok 1'* ]]
  [ -z "$(find "$tmpdir" -mindepth 1 -print)" ]
}
