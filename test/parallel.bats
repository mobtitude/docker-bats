#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

@test "GNU Parallel runs multiple Bats files successfully" {
  run bats --tap --jobs 2 /work/fixtures/parallel-first.bats /work/fixtures/parallel-second.bats
  [ "$status" -eq 0 ]
  [[ "$output" == *'1..2'* ]]
  [[ "$output" == *'ok 1 first parallel fixture'* ]]
  [[ "$output" == *'ok 2 second parallel fixture'* ]]
}

@test "parallel Bats execution propagates failures" {
  run bats --tap --jobs 2 /work/fixtures/parallel-first.bats /work/fixtures/parallel-failure.bats
  [ "$status" -eq 1 ]
  [[ "$output" == *'ok 1 first parallel fixture'* ]]
  [[ "$output" == *'not ok 2 expected parallel failure'* ]]
}
