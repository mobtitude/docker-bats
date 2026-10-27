#!/usr/bin/env bats
# SPDX-License-Identifier: MIT

@test "first parallel fixture" {
  [ -w "$BATS_TEST_TMPDIR" ]
}
