# GitHub Repository Polish Design

## Overview

Prepare the nixvim repository for public hosting on GitHub at `github:qwe854896/nixvim`. This covers repository documentation, standard community files, editor configuration, and CI workflows.

## Decisions

- License: MIT (copyright Jun-Hong Cheng 2026)
- CI approach: separate workflow files (one per concern)
- Flake update strategy: weekly auto-PR via `peter-evans/create-pull-request`
- Extra files: minimal set (README, LICENSE, .editorconfig -- no CONTRIBUTING.md, issue templates, etc.)
- Screenshot: skipped for now (can be added later)
- Existing `docs/superpowers/` directory: kept in public repo
- Untracked plan doc: committed; session files: gitignored via `session-*.md`

## Repository Files

### New Files

| File | Purpose |
|------|---------|
| `README.md` | Main documentation |
| `LICENSE` | MIT license |
| `.editorconfig` | Consistent editor settings |
| `.github/workflows/check.yml` | Flake validation |
| `.github/workflows/build.yml` | Package build |
| `.github/workflows/fmt.yml` | Formatting check |
| `.github/workflows/lint.yml` | Static analysis |
| `.github/workflows/deadnix.yml` | Dead code detection |
| `.github/workflows/update-flakes.yml` | Automated flake updates |

### Modified Files

| File | Change |
|------|--------|
| `.gitignore` | Add `session-*.md` |

### Files to Commit

| File | Status |
|------|--------|
| `docs/superpowers/plans/2026-03-31-flake-output-additions-implementation.md` | Currently untracked, commit it |

## README.md Structure

Sections in order:

1. **Title and tagline**: `# nixvim` + "Standalone Neovim configuration built with Nixvim."
2. **Quick Start**: `nix run github:qwe854896/nixvim`
3. **Features**: Brief design philosophy bullets:
   - Fully reproducible Nix-native Neovim configuration
   - Modular plugin organization by category
   - Language-specific LSP/formatter/linter tooling
   - Imperative Lua override system for runtime customization without rebuilds
4. **Plugin Overview**: Collapsible table organized by category:
   - UI: catppuccin, lualine, bufferline, snacks (dashboard, notifications, indent guides)
   - Editor: treesitter, mini.nvim suite, todo-comments, undotree, flash
   - Completion: blink-cmp, copilot, luasnip, friendly-snippets
   - LSP: lspconfig, conform (format-on-save), lint, fidget
   - Navigation: fzf-lua, yazi
   - Git: gitsigns, lazygit
   - Utils: direnv, trouble
5. **Language Support**: Table listing each language with its LSP server, formatter, and linter:
   - Nix: nixd / nixfmt / statix + deadnix
   - C/C++: clangd / clang-format / --
   - Zig: zls / zig fmt / --
   - Haskell: hls / ormolu / --
   - Python: basedpyright / ruff / ruff
   - Shell: bashls / shfmt / shellcheck
   - Lua, JSON, YAML: lua_ls, jsonls, yamlls (common config)
6. **Installation**: Three methods:
   - Standalone: `nix run` and `nix profile install`
   - As flake input into NixOS/Home-Manager module
   - Template: `nix flake init -t github:qwe854896/nixvim`
7. **Customization**: Brief explanation of the imperative Lua override system at `~/.config/nixvim/lua/` with the three override files (user-init.lua, user-keymaps.lua, user-theme.lua)
8. **Acknowledgments**: Credits to nix-community/nixvim upstream and notable configs that inspired the structure

## .editorconfig

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

## CI Workflows

All workflows use:
- Runner: `ubuntu-latest`
- Nix installation: `DeterminateSystems/nix-installer-action`
- Build caching: `DeterminateSystems/magic-nix-cache-action`

### check.yml -- Flake Validation

- **Triggers**: push to `main`, pull requests to `main`
- **Steps**: install Nix, enable cache, run `nix flake check`

### build.yml -- Package Build

- **Triggers**: push to `main`, pull requests to `main`
- **Steps**: install Nix, enable cache, run `nix build .`

### fmt.yml -- Formatting Check

- **Triggers**: push to `main`, pull requests to `main`
- **Steps**: install Nix, enable cache, run `nix fmt -- --ci`
- Uses `nixfmt-tree` (the flake's configured formatter)

### lint.yml -- Static Analysis

- **Triggers**: push to `main`, pull requests to `main`
- **Steps**: install Nix, enable cache, run `nix develop . -c statix check .`
- Enters devShell to access statix

### deadnix.yml -- Dead Code Detection

- **Triggers**: push to `main`, pull requests to `main`
- **Steps**: install Nix, enable cache, run `nix develop . -c deadnix --fail .`
- Enters devShell to access deadnix
- `--fail` flag causes non-zero exit on findings

### update-flakes.yml -- Automated Flake Updates

- **Triggers**: weekly cron (Monday 00:00 UTC), manual `workflow_dispatch`
- **Steps**:
  1. Checkout repo
  2. Install Nix
  3. Run `nix flake update`
  4. Create PR via `peter-evans/create-pull-request`
- **PR details**:
  - Title: `chore: update flake inputs`
  - Branch: `chore/update-flake-inputs`
  - Commit message: `chore: update flake inputs`
  - Auto-assigns to repo owner
- PR creation uses `secrets.REPO_TOKEN`, which must be configured as a repository secret so the resulting PR triggers the normal `pull_request` workflows
- The created PR automatically triggers check/build/fmt/lint/deadnix workflows, verifying the update doesn't break anything before merge

## .gitignore Additions

Add to existing `.gitignore`:

```
session-*.md
```

## Out of Scope

- Screenshots (can be added later)
- CONTRIBUTING.md (personal config, not a community project)
- Issue templates (not needed for personal use)
- CODEOWNERS / FUNDING.yml / labeler (over-engineering for solo project)
- Multi-platform support in CI (repo currently targets x86_64-linux only)
- dependabot.yml for GitHub Actions versions (can be added later if desired)
