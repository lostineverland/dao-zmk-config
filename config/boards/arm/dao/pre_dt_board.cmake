# Copyright (c) 2026 The ZMK Contributors
# SPDX-License-Identifier: MIT

# Suppress the duplicate unit-address warnings for the nRF52840 power/clock and
# acl/flash-controller nodes, which intentionally share unit-addresses.
# https://docs.zephyrproject.org/latest/build/dts/intro-input-output.html
list(APPEND EXTRA_DTC_FLAGS "-Wno-unique_unit_address_if_enabled")
