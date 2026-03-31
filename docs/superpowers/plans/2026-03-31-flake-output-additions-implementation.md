# Flake Output Additions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `apps`, `formatter`, `devShells`, and `templates` outputs to the standalone Nixvim flake, then remove the finished `implementation` worktree and branch.

**Architecture:** Keep the existing single-file `flake.nix` structure and wire the new outputs directly from the existing `nvim` package derivation. Add one minimal template directory under `templates/minimal` and expose it through the top-level flake outputs. Cleanup happens only after the new outputs are formatted, verified, and committed on `main`.

**Tech Stack:** Nix (flake-parts, nixvim), Neovim, git worktrees

---

## File Map

- `flake.nix` — extend the existing flake with `apps`, `formatter`, `devShells`, and `templates`
- `templates/minimal/flake.nix` — minimal standalone Nixvim starter flake
- `templates/minimal/config/default.nix` — template module entrypoint
- `templates/minimal/config/options.nix` — template editor defaults

---

### Task 1: Add Formatter and Dev Shell Outputs

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Reproduce the missing formatter and dev shell outputs**

Run:

```bash
nix fmt flake.nix
nix develop . -c statix --version
```

Expected before changes:

```text
error: flake 'git+file:///home/jhc/nixvim' does not provide attribute 'formatter.x86_64-linux'
/tmp/nix-shell.<random>: exec: statix: not found
```

- [ ] **Step 2: Update `flake.nix` to add `formatter` and `devShells.default`**

Replace `flake.nix` with:

```nix
{
  description = "Standalone Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvimModule = {
            inherit system;
            module = import ./config;
          };
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
        in
        {
          packages.default = nvim;

          formatter = pkgs.nixfmt-tree;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt-tree
              statix
              deadnix
            ];
          };

          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };
    };
}
```

- [ ] **Step 3: Re-run the formatter and dev shell checks**

Run:

```bash
nix fmt flake.nix
nix develop . -c statix --version
nix develop . -c deadnix --version
```

Expected after changes:

```text
nix fmt flake.nix
# exits 0

nix develop . -c statix --version
prints a statix version string

nix develop . -c deadnix --version
prints a deadnix version string
```

- [ ] **Step 4: Commit Task 1**

Run:

```bash
git add flake.nix
git commit -m "feat: add flake formatter and dev shell"
```

---

### Task 2: Add Apps and a Minimal Template

**Files:**
- Modify: `flake.nix`
- Create: `templates/minimal/flake.nix`
- Create: `templates/minimal/config/default.nix`
- Create: `templates/minimal/config/options.nix`

- [ ] **Step 1: Reproduce the missing named app and template outputs**

Run:

```bash
nix run .#nvim -- --version
rm -rf "/tmp/nixvim-template-smoke"
mkdir -p "/tmp/nixvim-template-smoke"
nix flake init -t /home/jhc/nixvim#default
```

Run the final command from inside `/tmp/nixvim-template-smoke`.

Expected before changes:

```text
error: flake 'git+file:///home/jhc/nixvim' does not provide attribute 'apps.x86_64-linux.nvim'
error: flake 'git+file:///home/jhc/nixvim' does not provide attribute 'templates.default' or 'default'
```

- [ ] **Step 2: Update `flake.nix` to add `apps` and expose the template**

Replace `flake.nix` with:

```nix
{
  description = "Standalone Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvimModule = {
            inherit system;
            module = import ./config;
          };
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
          nvimApp = {
            type = "app";
            program = "${nvim}/bin/nvim";
          };
        in
        {
          packages.default = nvim;

          apps = {
            default = nvimApp;
            nvim = nvimApp;
          };

          formatter = pkgs.nixfmt-tree;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt-tree
              statix
              deadnix
            ];
          };

          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

      flake = {
        templates.default = {
          path = ./templates/minimal;
          description = "Minimal standalone Nixvim starter";
        };
      };
    };
}
```

- [ ] **Step 3: Create `templates/minimal/flake.nix`**

Create `templates/minimal/flake.nix` with:

```nix
{
  description = "Minimal standalone Nixvim starter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }:
        let
          nixvimModule = {
            inherit system;
            module = import ./config;
          };
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
        in
        {
          packages.default = nvim;
        };
    };
}
```

- [ ] **Step 4: Create `templates/minimal/config/default.nix`**

Create `templates/minimal/config/default.nix` with:

```nix
{ ... }:
{
  imports = [
    ./options.nix
  ];
}
```

- [ ] **Step 5: Create `templates/minimal/config/options.nix`**

Create `templates/minimal/config/options.nix` with:

```nix
{ ... }:
{
  globals.mapleader = " ";

  opts = {
    number = true;
    relativenumber = true;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
  };
}
```

- [ ] **Step 6: Re-run the app and template checks**

Run:

```bash
nix run . -- --version
nix run .#nvim -- --version
rm -rf "/tmp/nixvim-template-smoke"
mkdir -p "/tmp/nixvim-template-smoke"
```

Then change into `/tmp/nixvim-template-smoke` and run:

```bash
nix flake init -t /home/jhc/nixvim#default
nix build .
```

Expected after changes:

```text
nix run . -- --version
prints a Neovim 0.11 version line

nix run .#nvim -- --version
prints a Neovim 0.11 version line

nix flake init -t /home/jhc/nixvim#default
# exits 0 and writes flake.nix plus config/

nix build .
# exits 0 inside the generated template directory
```

- [ ] **Step 7: Commit Task 2**

Run:

```bash
git add flake.nix templates/minimal
git commit -m "feat: add flake apps and template"
```

---

### Task 3: Format and Verify the Final Flake Outputs

**Files:**
- Modify: `flake.nix` (only if `nix fmt` rewrites it)
- Modify: `templates/minimal/flake.nix` (only if `nix fmt` rewrites it)
- Modify: `templates/minimal/config/default.nix` (only if `nix fmt` rewrites it)
- Modify: `templates/minimal/config/options.nix` (only if `nix fmt` rewrites it)

- [ ] **Step 1: Run the repo formatter**

Run:

```bash
nix fmt
git diff -- flake.nix templates/minimal
```

Expected:

```text
nix fmt
# exits 0

git diff -- flake.nix templates/minimal
# either empty or only formatting-only changes
```

- [ ] **Step 2: Run the final verification suite on `main`**

Run:

```bash
nix build .
nix flake check
nix run . -- --version
nix run .#nvim -- --version
nix develop . -c statix --version
nix develop . -c deadnix --version
```

Expected:

```text
nix build .
# exits 0

nix flake check
# exits 0

nix run . -- --version
prints a Neovim 0.11 version line

nix run .#nvim -- --version
prints a Neovim 0.11 version line

nix develop . -c statix --version
prints a statix version string

nix develop . -c deadnix --version
prints a deadnix version string
```

- [ ] **Step 3: Re-smoke-test the template after formatting**

Run:

```bash
rm -rf "/tmp/nixvim-template-smoke"
mkdir -p "/tmp/nixvim-template-smoke"
```

Then change into `/tmp/nixvim-template-smoke` and run:

```bash
nix flake init -t /home/jhc/nixvim#default
nix build .
```

Expected:

```text
nix flake init -t /home/jhc/nixvim#default
# exits 0

nix build .
# exits 0 in the generated template directory
```

- [ ] **Step 4: Commit the formatted output changes**

Run:

```bash
git add flake.nix templates/minimal
git commit -m "chore: format flake outputs"
```

If `nix fmt` produced no diff, skip this commit.

---

### Task 4: Remove the Finished Worktree and Branch

**Files:**
- Delete: `.worktrees/implementation/checkhealth`

- [ ] **Step 1: Remove the temporary `checkhealth` file**

Run:

```bash
rm -f ".worktrees/implementation/checkhealth"
git -C ".worktrees/implementation" status --short
```

Expected:

```text
git -C ".worktrees/implementation" status --short
# no output
```

- [ ] **Step 2: Remove the implementation worktree and branch**

Run:

```bash
git worktree remove ".worktrees/implementation"
git branch -d implementation
```

Expected:

```text
git worktree remove ".worktrees/implementation"
# exits 0

git branch -d implementation
Deleted branch implementation
```

- [ ] **Step 3: Verify cleanup completed**

Run:

```bash
git worktree list
git branch --list implementation
git status --short
```

Expected:

```text
git worktree list
contains only the `/home/jhc/nixvim` worktree on `main`

git branch --list implementation
# no output

git status --short
# no output
```
