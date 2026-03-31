# Multi-System Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand the nixvim flake and CI from `x86_64-linux`-only support to full `{x86_64,aarch64}-{linux,darwin}` coverage.

**Architecture:** Keep the existing shared `flake-parts` `perSystem` implementation and widen the declared system matrix instead of introducing new helper layers. Update only the system-specific workflows (`check.yml`, `build.yml`), keep source-only workflows single-run, and make the minimal template expose the same four-system package surface.

**Tech Stack:** Nix flakes, flake-parts, Nixvim, GitHub Actions, DeterminateSystems GitHub Actions, peter-evans/create-pull-request

**Spec:** `docs/superpowers/specs/2026-03-31-multi-system-support-design.md`

---

## File Structure

| File | Action | Purpose |
|------|--------|---------|
| `flake.nix` | Modify | Expand the main flake from one system to four while keeping one shared `perSystem` block |
| `templates/minimal/flake.nix` | Modify | Make the exported starter template expose packages for the same four systems |
| `README.md` | Modify | Replace the old single-system claim with the supported system matrix and update examples |
| `.github/workflows/check.yml` | Modify | Validate `nix flake check` on a four-runner OS/architecture matrix |
| `.github/workflows/build.yml` | Modify | Validate `nix build .` on the same four-runner OS/architecture matrix |

Execution context for the implementation phase: create a dedicated worktree branch named `multi-system-support`, implement the tasks there, then merge that branch back into `main` during Task 5.

---

### Task 1: Expand the main flake systems matrix

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Prove the new systems are missing today**

Run these evaluation checks from the repo root:

```bash
nix eval .#packages.aarch64-linux.default.drvPath --raw
nix eval .#packages.x86_64-darwin.default.drvPath --raw
nix eval .#packages.aarch64-darwin.default.drvPath --raw
```

Expected before the change: all three commands fail because `flake.nix` only declares `systems = [ "x86_64-linux" ]`.

- [ ] **Step 2: Expand `flake.nix` to the four-system matrix**

Update the `systems` declaration in `flake.nix` from:

```nix
      systems = [ "x86_64-linux" ];
```

to:

```nix
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
```

Do not restructure the existing `perSystem` block yet. Keep the shared `nixvimLib`, `nixvimModule`, `nvim`, `nvimApp`, `formatter`, `devShells.default`, `packages.default`, `apps`, and `checks.default` logic intact.

- [ ] **Step 3: Re-run the system-evaluation checks**

Run the same three commands again:

```bash
nix eval .#packages.aarch64-linux.default.drvPath --raw
nix eval .#packages.x86_64-darwin.default.drvPath --raw
nix eval .#packages.aarch64-darwin.default.drvPath --raw
```

Expected after the change: each command prints a `.drv` path instead of failing.

- [ ] **Step 4: Commit the main flake expansion**

```bash
git add flake.nix
git commit -m "feat: expand main flake to four systems"
```

---

### Task 2: Expand the minimal template to the same four systems

**Files:**
- Modify: `templates/minimal/flake.nix`

- [ ] **Step 1: Prove the template still only exposes one system**

Run these evaluation checks:

```bash
nix eval ./templates/minimal#packages.aarch64-linux.default.drvPath --raw
nix eval ./templates/minimal#packages.x86_64-darwin.default.drvPath --raw
nix eval ./templates/minimal#packages.aarch64-darwin.default.drvPath --raw
```

Expected before the change: the commands fail because `templates/minimal/flake.nix` still hardcodes `system = "x86_64-linux"` and only exposes one package path.

- [ ] **Step 2: Make the template generate packages for all four systems**

Replace the `outputs =` block in `templates/minimal/flake.nix` with this implementation:

```nix
  outputs =
    { nixpkgs, nixvim, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit system;
            module = import ./config;
          };
        in
        {
          default = nvim;
        }
      );
    };
```

This intentionally reintroduces `nixpkgs` in the `outputs =` lambda because the template now needs `nixpkgs.lib.genAttrs` to generate the package set for each system.

- [ ] **Step 3: Re-run the template evaluation checks**

Run these commands again:

```bash
nix eval ./templates/minimal#packages.aarch64-linux.default.drvPath --raw
nix eval ./templates/minimal#packages.x86_64-darwin.default.drvPath --raw
nix eval ./templates/minimal#packages.aarch64-darwin.default.drvPath --raw
```

Expected after the change: each command prints a `.drv` path.

- [ ] **Step 4: Commit the template expansion**

```bash
git add templates/minimal/flake.nix
git commit -m "feat: expand template to four systems"
```

---

### Task 3: Update the README for the supported system matrix

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Prove the README still documents single-system support**

Run:

```bash
grep -n 'x86_64-linux only' README.md
grep -n 'aarch64-darwin' README.md
```

Expected before the change:
- the first command prints the existing limitation line
- the second command prints nothing and exits non-zero

- [ ] **Step 2: Update the support note and installation examples**

Make these three README edits.

Replace the Quick Start support note:

```md
This flake currently targets `x86_64-linux` only.
```

with:

```md
Supported systems: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and `aarch64-darwin`.
```

Update the flake input example line:

```nix
      system = "x86_64-linux";
```

to:

```nix
      system = "x86_64-linux"; # or aarch64-linux, x86_64-darwin, aarch64-darwin
```

Add one sentence after the template code block and before the existing minimal-template note:

```md
The main flake and the exported template support the same four systems.
```

- [ ] **Step 3: Re-run the README checks**

Run:

```bash
grep -n 'x86_64-linux only' README.md
grep -n 'aarch64-darwin' README.md
grep -n 'exported template support the same four systems' README.md
```

Expected after the change:
- the first command prints nothing and exits non-zero
- the second command prints the supported-systems line and the updated example comment
- the third command prints the new template-support sentence

- [ ] **Step 4: Commit the README update**

```bash
git add README.md
git commit -m "docs: update supported system matrix"
```

---

### Task 4: Convert `check.yml` and `build.yml` to a four-runner CI matrix

**Files:**
- Modify: `.github/workflows/check.yml`
- Modify: `.github/workflows/build.yml`

- [ ] **Step 1: Prove the workflows are still single-run jobs**

Run:

```bash
nix shell nixpkgs#yq-go --command yq '.jobs.check.strategy.matrix.include | length' .github/workflows/check.yml
nix shell nixpkgs#yq-go --command yq '.jobs.build.strategy.matrix.include | length' .github/workflows/build.yml
```

Expected before the change: both commands print `null` because neither workflow has a matrix.

- [ ] **Step 2: Replace `check.yml` with an explicit four-system matrix**

Update `.github/workflows/check.yml` to:

```yaml
name: Check

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  check:
    name: Check (${{ matrix.nix-system }})
    strategy:
      fail-fast: false
      matrix:
        include:
          - runner: ubuntu-24.04
            nix-system: x86_64-linux
          - runner: ubuntu-24.04-arm
            nix-system: aarch64-linux
          - runner: macos-15-intel
            nix-system: x86_64-darwin
          - runner: macos-15
            nix-system: aarch64-darwin
    runs-on: ${{ matrix.runner }}
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@v22
      - uses: DeterminateSystems/magic-nix-cache-action@v13
      - name: Assert runner matches target system
        run: |
          test "$(nix eval --impure --raw --expr builtins.currentSystem)" = "${{ matrix.nix-system }}"
      - run: nix flake check
```

- [ ] **Step 3: Replace `build.yml` with the same matrix shape**

Update `.github/workflows/build.yml` to:

```yaml
name: Build

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    name: Build (${{ matrix.nix-system }})
    strategy:
      fail-fast: false
      matrix:
        include:
          - runner: ubuntu-24.04
            nix-system: x86_64-linux
          - runner: ubuntu-24.04-arm
            nix-system: aarch64-linux
          - runner: macos-15-intel
            nix-system: x86_64-darwin
          - runner: macos-15
            nix-system: aarch64-darwin
    runs-on: ${{ matrix.runner }}
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@v22
      - uses: DeterminateSystems/magic-nix-cache-action@v13
      - name: Assert runner matches target system
        run: |
          test "$(nix eval --impure --raw --expr builtins.currentSystem)" = "${{ matrix.nix-system }}"
      - run: nix build .
```

- [ ] **Step 4: Re-run the workflow structure checks**

Run:

```bash
nix shell nixpkgs#yq-go --command yq '.jobs.check.strategy.matrix.include | length' .github/workflows/check.yml
nix shell nixpkgs#yq-go --command yq '.jobs.build.strategy.matrix.include | length' .github/workflows/build.yml
```

Expected after the change: both commands print `4`.

- [ ] **Step 5: Commit the workflow matrix update**

```bash
git add .github/workflows/check.yml .github/workflows/build.yml
git commit -m "ci: add four-system check and build matrix"
```

---

### Task 5: Verify the four-system flake, merge locally, and push `main`

**Files:**
- Verify: `flake.nix`
- Verify: `templates/minimal/flake.nix`
- Verify: `README.md`
- Verify: `.github/workflows/check.yml`
- Verify: `.github/workflows/build.yml`

- [ ] **Step 1: Verify the flake now evaluates across all declared systems**

Run:

```bash
nix flake show --all-systems
nix flake check --all-systems --no-build
nix eval .#packages.aarch64-linux.default.drvPath --raw
nix eval .#packages.x86_64-darwin.default.drvPath --raw
nix eval .#packages.aarch64-darwin.default.drvPath --raw
nix eval ./templates/minimal#packages.aarch64-linux.default.drvPath --raw
nix eval ./templates/minimal#packages.x86_64-darwin.default.drvPath --raw
nix eval ./templates/minimal#packages.aarch64-darwin.default.drvPath --raw
```

Expected: no evaluation failures. The `nix eval` commands should all print `.drv` paths.

- [ ] **Step 2: Verify the host-native local toolchain still passes**

Run:

```bash
nix fmt -- --ci
nix develop . -c statix check .
nix develop . -c deadnix --fail .
nix build .
nix flake check
```

Expected: all five commands exit successfully.

- [ ] **Step 3: Confirm the feature branch is clean**

Run:

```bash
git status --short
```

Expected: no output.

- [ ] **Step 4: Merge the worktree branch back to `main` locally**

Run these commands from the repository root after leaving the worktree branch:

```bash
git checkout main
git merge --no-ff multi-system-support
```

Expected: the merge completes without conflicts.

- [ ] **Step 5: Re-run the host-native verification suite on merged `main`**

Run:

```bash
nix fmt -- --ci
nix develop . -c statix check .
nix develop . -c deadnix --fail .
nix build .
nix flake check
```

Expected: all five commands still exit successfully on merged `main`.

- [ ] **Step 6: Push the verified `main` branch**

```bash
git push origin main
```

Expected: the remote `main` branch updates successfully.
