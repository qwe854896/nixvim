# Nixvim Configuration — Design Spec

## Overview

A standalone Nix flake that produces a fully configured Neovim binary via Nixvim. Prioritizes smoothness and pragmatism over visual flair. Targets a developer working primarily in Nix, C/C++, Zig, Haskell, Python, and Shell within flake-managed projects.

## Architecture

**Approach:** Flat category structure. One `.nix` file per plugin/concern, organized into category directories.

**Flake structure:** `flake-parts` based, outputs `packages.default` (Neovim binary) and `checks.default` (config validation). Uses `makeNixvimWithModule`.

**Inputs:** `nixpkgs` (unstable), `nixvim` (follows nixpkgs), `flake-parts`.

## Imperative Override Mechanism

A `lua/` directory in the repo contains mutable Lua files sourced at runtime outside the Nix store. The Nix config uses `extraConfigLuaPost` to glob and `dofile()` all `*.lua` files from `~/.config/nixvim/lua/`. The user symlinks `<repo>/lua/` to that path. Edits take effect on next nvim restart without Nix rebuild.

Files: `user-init.lua` (general overrides), `user-keymaps.lua` (keymap tweaks), `user-theme.lua` (colorscheme variant, custom highlights).

## Core Settings

- Leader: `<Space>`, Local leader: `,`
- 2-space indent default (4 for Python, C, Zig via autocmds)
- Relative line numbers, system clipboard, persistent undo, no swapfile
- Splits open right/below
- `updatetime=250`, `timeoutlen=300`
- Autocommands: yank highlight, trailing whitespace trim, cursor restore, auto-resize splits, per-filetype indent

## Plugin Inventory

### UI
| Plugin | Purpose |
|--------|---------|
| catppuccin (mocha) | Colorscheme with integrations for all plugins |
| lualine | Status bar — mode, branch, diff, filename, diagnostics, filetype, location |
| bufferline | Buffer tabs with modified indicators |
| which-key | Keymap discovery popup |
| snacks.nvim | Dashboard, notifier, terminal, indent guides |

### Editor
| Plugin | Purpose |
|--------|---------|
| treesitter + textobjects + context | Syntax highlighting, smart selection, scope display |
| mini.pairs | Auto-close brackets/quotes |
| mini.surround | Add/change/delete surrounds |
| mini.ai | Enhanced text objects |
| mini.comment | Toggle comments (`gc`) |
| mini.icons | File/directory icons |
| mini.trailspace | Trailing whitespace |
| todo-comments | Highlight/search TODOs |
| undotree | Visual undo history |
| flash.nvim | Quick jump navigation |

### Completion
| Plugin | Purpose |
|--------|---------|
| blink.cmp | Completion engine (LSP, copilot, snippets, buffer, path) |
| copilot.lua | GitHub Copilot as blink source |
| luasnip + friendly-snippets | Snippet engine + common snippets |

### LSP
| Plugin | Purpose |
|--------|---------|
| lspconfig | Built-in LSP client configuration |
| conform.nvim | Format on save (per-language formatters) |
| nvim-lint | Async linting (shellcheck, ruff, statix, deadnix) |
| fidget.nvim | LSP progress indicator |

### Navigation
| Plugin | Purpose |
|--------|---------|
| fzf-lua | Fuzzy finder for files, grep, buffers, symbols, diagnostics |
| yazi | Terminal file manager in floating window |
| flash.nvim | 2-char jump with labels |

### Git
| Plugin | Purpose |
|--------|---------|
| gitsigns | Inline git signs, hunk staging/preview, blame |
| lazygit | Full Git TUI in floating terminal |

### Utils
| Plugin | Purpose |
|--------|---------|
| direnv.nvim | Auto-load devShell environments from .envrc |
| trouble.nvim | Pretty diagnostics/quickfix list |

## Language Support

All LSPs bundled in Nixvim derivation. direnv supplements with project-local tools.

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Nix | nixd | nixfmt | statix, deadnix |
| C/C++ | clangd | clang-format | — |
| Zig | zls | zig fmt | — |
| Haskell | haskell-language-server | ormolu | — |
| Python | basedpyright | ruff | ruff |
| Shell | bashls | shfmt | shellcheck |
| Lua | lua-ls | stylua | — |
| JSON | jsonls | — | — |
| YAML | yamlls | — | — |

## Keymap Overview

Leader groups: `f` (find), `g` (git), `l` (LSP), `t` (terminal/toggle), `x` (diagnostics), `e` (explorer), `u` (undotree).

## Intentionally Excluded

noice.nvim (too fancy), nvim-cmp (replaced by blink), telescope (replaced by fzf-lua), neo-tree (replaced by yazi), multicursor (native vim suffices), indent-blankline (replaced by snacks.indent).

## File Structure

```
nixvim/
├── flake.nix
├── config/
│   ├── default.nix
│   ├── options.nix
│   ├── keymaps.nix
│   ├── autocmds.nix
│   ├── plugins/{ui,editor,lsp,completion,navigation,git,utils}/
│   └── languages/{nix,c-cpp,zig,haskell,python,shell,common}.nix
└── lua/{user-init,user-keymaps,user-theme}.lua
```
