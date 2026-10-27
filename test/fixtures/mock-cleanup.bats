#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

@test "mock is created in the test temporary directory" {
  load '/opt/bats-mock/load'
  mock=$(mock_create)
  [[ "$mock" == "$BATS_TEST_TMPDIR/"* ]]
  run "$mock"
  [ "$status" -eq 0 ]
}
