# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A ZMK firmware config for the **dao** keyboard — a self-contained nRF52840 wireless split. Not a software project: there are no tests or linters. Building the firmware *is* the verification.

`build.yaml` defines the CI matrix. It currently produces four artifacts: `dao_left`, `dao_right`, and each half with the `settings_reset` shield (utility firmware to wipe BT pairings / stored settings). `.github/workflows/build.yml` is a thin wrapper around ZMK's reusable `build-user-config.yml`.

The `README.md` covers the keyboard from a user's perspective: default keymap, flashing, and the user's ongoing home-row-mod tuning notes. Consult it when working on keymap behavior tweaks.

## Build and verify locally

```
bash dao-build/run.sh
```

Runs the **same Docker image GitHub Actions uses** (`zmkfirmware/zmk-build-arm:stable`) and builds every target in `build.yaml` against the current working tree. A green local run is a strong predictor of green CI.

The first run downloads the west dependency tree into `dao-build/` (~few minutes, ~4 GB) and reuses it afterward. To force a fresh fetch (e.g. after changing the ZMK revision in `config/west.yml`), delete `dao-build/zmk` and re-run. `dao-build/` is git-ignored via `dao-build/.gitignore`.

## Two branches, two tracking strategies

| Branch | `config/west.yml` revision | Workflow ref in `.github/workflows/build.yml` |
|---|---|---|
| `main` | `main` (latest ZMK) | `@main` |
| `stable` | pinned to a verified ZMK SHA | pinned to the **same** SHA |

These two pin points must stay in sync — the ZMK reusable workflow and the ZMK source it builds must be from the same era. Bump both together or neither. A mismatch produces obscure failures (e.g. `KeyError: 'qualifiers'` when an old ZMK meets a new workflow).

`stable` exists because **tracking upstream `main` can break the build with no change to this repo** — ZMK has done major breaking changes (HWMv2 / Zephyr 4.1). When CI fails mysteriously on `main`, suspect upstream first; `stable` is the known-good fallback.

## Custom board: `config/boards/arm/dao/`

This is a **Zephyr Hardware Model v2 (HWMv2)** board. Do not revert it to HWMv1 (no `Kconfig.board`, no `<board>.yaml`).

Split topology: `dao_left` is BLE central + USB; `dao_right` is BLE peripheral, USB disabled.

Files and what each is for:

- `board.yml` — declares two boards (`dao_left`, `dao_right`) both on SoC `nrf52840`.
- `Kconfig.dao_left`, `Kconfig.dao_right` — each `select SOC_NRF52840_QIAA` and `select ZMK_BOARD_COMPAT` (the latter satisfies ZMK's post-build compat check).
- `Kconfig.defconfig` — shared Kconfig defaults (`ZMK_SPLIT`, `ZMK_SPLIT_ROLE_CENTRAL` on left only, etc.).
- `dao.dtsi` — shared devicetree (SoC, kscan matrix, both matrix transforms, USB, ADC, battery, LED, flash partitions).
- `dao_left.dts`, `dao_right.dts` — per-half overrides (`col-gpios`, plus `col-offset = <6>` on the right).
- `*_defconfig` — per-half Kconfig (USB on for left, off for right).
- `pre_dt_board.cmake` — suppresses duplicate unit-address dtc warnings from the nRF52840 SoC dtsi.

## Where edits go: two config layers

The keymap and Kconfig live at two layers. Edits usually belong at the **user** layer.

| Concern | Board defaults | User overrides (edit here) |
|---|---|---|
| Keymap | `config/boards/arm/dao/dao.keymap` | `config/dao.keymap` |
| Per-half Kconfig | `config/boards/arm/dao/dao_{left,right}_defconfig` | `config/dao_{left,right}.conf` |
| Shared board Kconfig | `config/boards/arm/dao/dao.conf` | (none — edit board-level) |

User-level files override and extend board-level. ZMK feature toggles and keymap tweaks belong at the user level; touch board files only for board-hardware changes (kscan, transforms, partitions, etc.).
