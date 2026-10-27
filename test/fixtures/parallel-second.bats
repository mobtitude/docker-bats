#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

@test "second parallel fixture" {
  [ -w "$BATS_TEST_TMPDIR" ]
}
