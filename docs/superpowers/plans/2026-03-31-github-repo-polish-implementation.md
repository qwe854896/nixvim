# GitHub Repository Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prepare the nixvim repository for public GitHub hosting with documentation, standard repo files, and CI workflows.

**Architecture:** Add standard repository files (README, LICENSE, .editorconfig) and six GitHub Actions workflows (check, build, fmt, lint, deadnix, update-flakes). All CI workflows use DeterminateSystems Nix installer and magic-nix-cache. The flake update workflow creates auto-PRs weekly.

**Tech Stack:** GitHub Actions, DeterminateSystems/nix-installer-action, DeterminateSystems/magic-nix-cache-action, peter-evans/create-pull-request

**Spec:** `docs/superpowers/specs/2026-03-31-github-repo-polish-design.md`

---

## File Structure

| File | Action | Purpose |
|------|--------|---------|
| `.gitignore` | Modify | Add `session-*.md` pattern |
| `LICENSE` | Create | MIT license |
| `.editorconfig` | Create | Editor settings (2-space indent, UTF-8, LF) |
| `README.md` | Create | Main documentation |
| `.github/workflows/check.yml` | Create | `nix flake check` on push/PR |
| `.github/workflows/build.yml` | Create | `nix build .` on push/PR |
| `.github/workflows/fmt.yml` | Create | `nix fmt -- --ci` on push/PR |
| `.github/workflows/lint.yml` | Create | `statix check .` on push/PR |
| `.github/workflows/deadnix.yml` | Create | `deadnix --fail .` on push/PR |
| `.github/workflows/update-flakes.yml` | Create | Weekly auto-PR with `nix flake update` |

---

### Task 1: Housekeeping -- gitignore and untracked plan doc

**Files:**
- Modify: `.gitignore`
- Stage: `docs/superpowers/plans/2026-03-31-flake-output-additions-implementation.md`

- [ ] **Step 1: Add session file pattern to .gitignore**

Append `session-*.md` to `.gitignore`. The file currently contains:

```
.worktrees/
result
.direnv
```

After edit:

```
.worktrees/
result
.direnv
session-*.md
```

- [ ] **Step 2: Commit housekeeping changes**

```bash
git add .gitignore docs/superpowers/plans/2026-03-31-flake-output-additions-implementation.md
git commit -m "chore: gitignore session files and commit plan doc"
```

---

### Task 2: Add LICENSE and .editorconfig

**Files:**
- Create: `LICENSE`
- Create: `.editorconfig`

- [ ] **Step 1: Create MIT LICENSE file**

Create `LICENSE` with the following content (copyright year 2026, author Jun-Hong Cheng):

```
MIT License

Copyright (c) 2026 Jun-Hong Cheng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 2: Create .editorconfig**

Create `.editorconfig` with the following content:

```ini
root = true

[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespace = true

[*.{nix,lua}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

- [ ] **Step 3: Commit LICENSE and .editorconfig**

```bash
git add LICENSE .editorconfig
git commit -m "chore: add MIT license and editorconfig"
```

---

### Task 3: Create README.md

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write README.md**

Create `README.md` with the following content:

````markdown
# nixvim

Standalone Neovim configuration built with [Nixvim](https://github.com/nix-community/nixvim).

## Quick Start

```bash
nix run github:qwe854896/nixvim
```

## Features

- Fully reproducible Nix-native Neovim configuration
- Modular plugin organization by category
- Language-specific LSP, formatter, and linter tooling
- Imperative Lua override system for runtime customization without rebuilds

## Plugin Overview

<details>
<summary>Click to expand plugin list</summary>

| Category | Plugins |
|----------|---------|
| UI | catppuccin, lualine, bufferline, which-key, snacks (dashboard, notifications, indent guides) |
| Editor | treesitter, mini.nvim (ai, comment, icons, pairs, surround, trailspace), todo-comments, undotree, flash |
| Completion | blink-cmp, copilot, luasnip, friendly-snippets |
| LSP | lspconfig, conform (format-on-save), lint, fidget |
| Navigation | fzf-lua, yazi |
| Git | gitsigns, lazygit |
| Utils | direnv, trouble |

</details>

## Language Support

| Language | LSP Server | Formatter | Linter |
|----------|-----------|-----------|--------|
| Nix | nixd | nixfmt | statix, deadnix |
| C/C++ | clangd | clang-format | -- |
| Zig | zls | zig fmt | -- |
| Haskell | hls | ormolu | -- |
| Python | basedpyright | ruff | ruff |
| Shell | bashls | shfmt | shellcheck |
| Lua | lua_ls | -- | -- |
| JSON | jsonls | -- | -- |
| YAML | yamlls | -- | -- |

## Installation

### Standalone

Try it without installing:

```bash
nix run github:qwe854896/nixvim
```

Install to your profile:

```bash
nix profile install github:qwe854896/nixvim
```

### As a Flake Input

Add to your flake inputs and include the package in your configuration:

```nix
{
  inputs.nixvim.url = "github:qwe854896/nixvim";

  # In your NixOS or Home-Manager config:
  # environment.systemPackages = [ inputs.nixvim.packages.${system}.default ];
  # or
  # home.packages = [ inputs.nixvim.packages.${system}.default ];
}
```

### From Template

Bootstrap a new Nixvim configuration from the included starter template:

```bash
mkdir my-nixvim && cd my-nixvim
nix flake init -t github:qwe854896/nixvim
nix run .
```

## Customization

This configuration supports imperative Lua overrides without requiring a Nix rebuild. Place `.lua` files in `~/.config/nixvim/lua/` and they will be automatically loaded at startup.

Three override files are provided as starting points:

| File | Purpose |
|------|---------|
| `user-init.lua` | General startup hooks and settings |
| `user-keymaps.lua` | Additional key mappings |
| `user-theme.lua` | Highlight and colorscheme tweaks |

Copy them to get started:

```bash
mkdir -p ~/.config/nixvim/lua
cp lua/user-*.lua ~/.config/nixvim/lua/
```

Edit the files and uncomment the examples you want to use. Changes take effect on the next Neovim restart -- no rebuild needed.

## Acknowledgments

- [nix-community/nixvim](https://github.com/nix-community/nixvim) -- the framework that makes this possible
- [elythh/nixvim](https://github.com/elythh/nixvim), [khaneliman/khanelivim](https://github.com/khaneliman/khanelivim), [dc-tec/nixvim](https://github.com/dc-tec/nixvim) -- configs that inspired the structure and CI setup

## License

[MIT](LICENSE)
````

- [ ] **Step 2: Commit README.md**

```bash
git add README.md
git commit -m "docs: add README"
```

---

### Task 4: Create CI validation workflows

**Files:**
- Create: `.github/workflows/check.yml`
- Create: `.github/workflows/build.yml`
- Create: `.github/workflows/fmt.yml`
- Create: `.github/workflows/lint.yml`
- Create: `.github/workflows/deadnix.yml`

- [ ] **Step 1: Create .github/workflows/ directory**

```bash
mkdir -p .github/workflows
```

- [ ] **Step 2: Create check.yml**

Create `.github/workflows/check.yml`:

```yaml
name: Check

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - uses: DeterminateSystems/magic-nix-cache-action@main
      - run: nix flake check
```

- [ ] **Step 3: Create build.yml**

Create `.github/workflows/build.yml`:

```yaml
name: Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - uses: DeterminateSystems/magic-nix-cache-action@main
      - run: nix build .
```

- [ ] **Step 4: Create fmt.yml**

Create `.github/workflows/fmt.yml`:

```yaml
name: Format

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  fmt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - uses: DeterminateSystems/magic-nix-cache-action@main
      - run: nix fmt -- --ci
```

- [ ] **Step 5: Create lint.yml**

Create `.github/workflows/lint.yml`:

```yaml
name: Lint

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - uses: DeterminateSystems/magic-nix-cache-action@main
      - run: nix develop . -c statix check .
```

- [ ] **Step 6: Create deadnix.yml**

Create `.github/workflows/deadnix.yml`:

```yaml
name: Deadnix

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deadnix:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - uses: DeterminateSystems/magic-nix-cache-action@main
      - run: nix develop . -c deadnix --fail .
```

- [ ] **Step 7: Commit all five CI validation workflows**

```bash
git add .github/workflows/check.yml .github/workflows/build.yml .github/workflows/fmt.yml .github/workflows/lint.yml .github/workflows/deadnix.yml
git commit -m "ci: add check, build, format, lint, and deadnix workflows"
```

---

### Task 5: Create flake update workflow

**Files:**
- Create: `.github/workflows/update-flakes.yml`

- [ ] **Step 1: Create update-flakes.yml**

Create `.github/workflows/update-flakes.yml`:

```yaml
name: Update Flakes

on:
  schedule:
    - cron: "0 0 * * 1"
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - run: nix flake update
      - uses: peter-evans/create-pull-request@v7
        with:
          token: ${{ secrets.REPO_TOKEN }}
          commit-message: "chore: update flake inputs"
          title: "chore: update flake inputs"
          branch: chore/update-flake-inputs
          assignees: qwe854896
```

This workflow requires a repository secret named `REPO_TOKEN`. The PR must be created with `secrets.REPO_TOKEN` so it triggers the normal `pull_request` workflows.

- [ ] **Step 2: Commit the update workflow**

```bash
git add .github/workflows/update-flakes.yml
git commit -m "ci: add weekly flake update workflow"
```

---

### Task 6: Local verification

This task verifies that all existing checks still pass locally. The GitHub Actions workflows themselves can only be fully tested once pushed to GitHub, but we verify the underlying commands work.

- [ ] **Step 1: Verify formatting passes**

```bash
nix fmt -- --ci
```

Expected: exits 0 (no formatting changes needed).

- [ ] **Step 2: Verify linting passes**

```bash
nix develop . -c statix check .
```

Expected: exits 0 (no warnings).

- [ ] **Step 3: Verify deadnix passes**

```bash
nix develop . -c deadnix --fail .
```

Expected: exits 0 (no dead code found).

- [ ] **Step 4: Verify flake check passes**

```bash
nix flake check
```

Expected: exits 0.

- [ ] **Step 5: Verify build passes**

```bash
nix build .
```

Expected: exits 0, produces `result` symlink.

- [ ] **Step 6: Fix any issues found**

If any of the above commands fail, fix the issues and amend the relevant prior commit or create a fix commit. Re-run the failing command to confirm the fix.

- [ ] **Step 7: Commit the spec and plan for this feature**

```bash
git add docs/superpowers/specs/2026-03-31-github-repo-polish-design.md docs/superpowers/plans/2026-03-31-github-repo-polish-implementation.md
git commit -m "docs: add GitHub repo polish design and plan"
```
