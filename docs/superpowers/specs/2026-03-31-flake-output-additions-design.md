# Flake Output Additions Design

## Overview

Extend the standalone Nixvim flake with standard developer-facing outputs and remove the now-finished implementation worktree. The additions should stay minimal and align with the repo's current single-system, single-package structure.

## Goals

- Add first-class flake outputs for `apps`, `formatter`, `devShells`, and `templates`
- Keep `nix run .` and `nix build .` working as they do now
- Provide a repo maintenance shell with Nix hygiene tools
- Add a minimal standalone Nixvim starter template rather than copying the full repository
- Remove the finished `implementation` worktree, its branch, and the temporary `checkhealth` file

## Output Design

### Apps

- `apps.default` runs the built Neovim package
- `apps.nvim` also runs the same built Neovim package explicitly

Both apps should point at the existing `packages.default` result so there is one source of truth for the executable.

### Formatter

- `formatter` uses `nixfmt-tree`

This enables `nix fmt` for the repository without introducing a separate formatting wrapper or custom script.

### Dev Shell

- `devShells.default` provides repo maintenance tools only
- Included tools:
  - `nixfmt-tree`
  - `statix`
  - `deadnix`

The shell is intentionally narrow in scope. It exists to maintain and lint the flake, not to replicate the packaged editor runtime.

### Templates

- `templates.default` is a minimal standalone Nixvim starter

The template should be small and teach the pattern clearly. It should include only the files needed to demonstrate a working flake-backed Nixvim setup, such as:

- `flake.nix`
- `config/default.nix`
- `config/options.nix`

The template should not mirror the full plugin and language structure from this repository.

## Cleanup

After the output changes are implemented:

- delete the untracked `checkhealth` file from `.worktrees/implementation`
- remove the `implementation` worktree
- delete the `implementation` branch

Cleanup should happen only after the merged `main` branch contains all desired changes.

## Verification

After implementation:

- run `nix fmt`
- run `nix build .`
- run `nix flake check`
- verify `nix run .` still launches the packaged Neovim binary
- verify the template is exposed from `templates.default`

## Constraints

- Keep the existing flake layout rather than introducing extra abstraction files unless necessary
- Prefer wiring new outputs from existing values in `flake.nix`
- Keep the template minimal and readable
- Do not remove or alter the documented imperative override contract during this work
