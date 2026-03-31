# Multi-System Support Design

## Overview

Expand the nixvim flake from single-system support to the full `{x86_64,aarch64}-{linux,darwin}` matrix while preserving a single shared flake implementation and a consistent output surface on every supported system.

## Goals

- Support these four systems in the flake:
  - `x86_64-linux`
  - `aarch64-linux`
  - `x86_64-darwin`
  - `aarch64-darwin`
- Preserve full output parity across all four systems:
  - `packages.default`
  - `apps.default`
  - `apps.nvim`
  - `formatter`
  - `devShells.default`
  - `checks.default`
- Update CI so system-specific workflows validate the expanded matrix.
- Update public documentation so the supported systems match the actual flake behavior.

## Non-Goals

- No partial or best-effort system support.
- No large flake refactor into multiple helper files unless verification proves it is necessary.
- No platform-specific feature divergence unless it is required to keep outputs buildable.

## Current State

- `flake.nix` currently declares `systems = [ "x86_64-linux" ]`.
- `README.md` explicitly states that the flake targets `x86_64-linux` only.
- GitHub Actions validation workflows currently run as single jobs on `ubuntu-latest`.
- The flake already uses a shared `perSystem` implementation, so the main matrix expansion point is the `systems` list and any verification-driven platform adjustments.

## Design Decisions

### 1. Shared `perSystem` implementation

Keep the current `flake-parts` structure and continue using one shared `perSystem` block for all supported systems. The current implementation is already system-parameterized via `system`, `pkgs`, `nixvim.lib.${system}`, and `nixvim.legacyPackages.${system}`.

This keeps the change minimal and avoids speculative abstraction. If Darwin-specific packaging issues appear during verification, handle them with small conditionals inside the existing `perSystem` block rather than restructuring the flake.

### 2. Full output parity across the matrix

Every supported system should expose the same top-level flake outputs:

- `packages.${system}.default`
- `apps.${system}.default`
- `apps.${system}.nvim`
- `formatter.${system}`
- `devShells.${system}.default`
- `checks.${system}.default`

The goal is that consumers can use the same flake interface regardless of platform.

### 3. Minimal template changes

The exported template should remain intentionally minimal unless verification shows that it also needs explicit multi-system changes to stay aligned with the main flake. The preferred outcome is to keep the current template shape and only broaden its declared systems if that is required for correctness.

### 4. CI matrix split by responsibility

Keep the current workflow split and only expand the workflows whose behavior is system-specific.

- `check.yml`: convert to a system matrix
- `build.yml`: convert to a system matrix
- `fmt.yml`: remain single-run source-tree validation
- `lint.yml`: remain single-run source-tree validation
- `deadnix.yml`: remain single-run source-tree validation
- `update-flakes.yml`: remain single-run PR automation

This keeps CI efficient and avoids running identical source-level checks four times.

### 5. Practical runner mapping

The CI matrix should represent the intended four-system support explicitly. Use GitHub-hosted runners that map as closely as possible to the supported systems:

- Linux x86_64 runner for `x86_64-linux`
- Linux ARM runner for `aarch64-linux` if available on GitHub-hosted Actions
- Intel macOS runner for `x86_64-darwin`
- Apple Silicon macOS runner for `aarch64-darwin`

If GitHub-hosted runner naming or availability forces small adjustments, keep the workflow matrix entries explicit about which Nix `system` each job is validating.

## Files Expected to Change

### Required

- `flake.nix`
- `README.md`
- `.github/workflows/check.yml`
- `.github/workflows/build.yml`

### Possibly required after verification

- `.github/workflows/update-flakes.yml`
- `templates/minimal/flake.nix`
- docs that currently describe single-system support

## Verification Strategy

Before calling the work complete, verify:

1. `nix flake show` reflects the expanded system matrix.
2. `nix flake check` still passes on the current machine.
3. The flake evaluates for all four declared systems.
4. The CI workflow matrix correctly maps runner entries to the declared Nix systems.
5. README installation/support text matches the actual supported systems.

If verification reveals platform-specific package issues, fix them minimally and keep the behavior consistent across outputs.

## Risks and Mitigations

### Darwin package/tool differences

Some tools pulled into `devShells.default` or the Nixvim module graph may differ by platform.

Mitigation:
- Start with the shared implementation.
- Add the smallest necessary conditional only where verification shows a real incompatibility.

### CI runner availability drift

GitHub-hosted runner labels and architecture availability may change.

Mitigation:
- Make the workflow matrix entries explicit about the target Nix `system`.
- Prefer stable runner labels where possible.
- Keep source-only checks outside the full system matrix.

### Documentation drift

The repo currently documents `x86_64-linux`-only support.

Mitigation:
- Update README support claims in the same change set as the flake and workflow updates.

## Expected Outcome

After implementation:

- The flake supports `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and `aarch64-darwin`.
- The repo exposes the same flake outputs on all four systems.
- CI validates the system-specific workflows across the expanded matrix.
- Public docs describe the actual supported systems instead of the old single-system limitation.
