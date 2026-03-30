# Nixvim Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete, pragmatic Nixvim standalone flake with modular plugin configuration, LSP support for 6 languages, and an imperative Lua override mechanism.

**Architecture:** Standalone flake using flake-parts + makeNixvimWithModule. Config split into per-plugin `.nix` files under categorized directories. A `lua/` directory provides mutable runtime overrides sourced via `extraConfigLuaPost`.

**Tech Stack:** Nix (flake-parts, nixvim), Lua (user overrides), Neovim

---

### Task 1: Flake Scaffold

**Files:**
- Create: `flake.nix`
- Create: `.gitignore`
- Create: `.envrc`
- Create: `config/default.nix`

- [ ] **Step 1: Create `flake.nix`** — flake-parts based, inputs nixpkgs+nixvim+flake-parts, outputs packages.default + checks.default
- [ ] **Step 2: Create `.gitignore`** — result, .direnv
- [ ] **Step 3: Create `.envrc`** — `use flake`
- [ ] **Step 4: Create minimal `config/default.nix`** — empty imports list
- [ ] **Step 5: Lock flake and verify** — `nix flake lock && nix flake check && nix run . -- --version`
- [ ] **Step 6: Commit** — `git add -A && git commit -m "feat: scaffold flake with minimal nixvim config"`

---

### Task 2: Core Settings

**Files:**
- Create: `config/options.nix`
- Create: `config/keymaps.nix`
- Create: `config/autocmds.nix`
- Modify: `config/default.nix`

- [ ] **Step 1: Create `config/options.nix`** — leader, numbers, indent, search, UI, splits, performance, persistence, clipboard
- [ ] **Step 2: Create `config/keymaps.nix`** — clear search, window nav, buffer cycling, save, quit, close buffer, visual line movement, indent keep selection, line moving
- [ ] **Step 3: Create `config/autocmds.nix`** — yank highlight, trailing whitespace, cursor restore, auto-resize, per-filetype indent
- [ ] **Step 4: Update `config/default.nix`** — import all three
- [ ] **Step 5: Verify** — `nix flake check`
- [ ] **Step 6: Commit** — `git add -A && git commit -m "feat: add core settings, keymaps, and autocommands"`

---

### Task 3: UI Plugins

**Files:**
- Create: `config/plugins/default.nix`
- Create: `config/plugins/ui/default.nix`
- Create: `config/plugins/ui/catppuccin.nix`
- Create: `config/plugins/ui/lualine.nix`
- Create: `config/plugins/ui/bufferline.nix`
- Create: `config/plugins/ui/which-key.nix`
- Create: `config/plugins/ui/snacks.nix`
- Modify: `config/default.nix`

- [ ] **Step 1:** Create directory structure and default.nix files that import siblings
- [ ] **Step 2:** Implement catppuccin.nix (mocha, integrations for all plugins)
- [ ] **Step 3:** Implement lualine.nix (sections: mode, branch+diff, filename+diagnostics, filetype, progress, location)
- [ ] **Step 4:** Implement bufferline.nix (minimal, catppuccin integration)
- [ ] **Step 5:** Implement which-key.nix (leader group labels: f/g/l/t/x/e/u)
- [ ] **Step 6:** Implement snacks.nix (dashboard, notifier, terminal, indent)
- [ ] **Step 7:** Verify — `nix flake check`
- [ ] **Step 8:** Commit — `git add -A && git commit -m "feat: add UI plugins"`

---

### Task 4: Editor Plugins

**Files:**
- Create: `config/plugins/editor/default.nix`
- Create: `config/plugins/editor/treesitter.nix`
- Create: `config/plugins/editor/mini.nix`
- Create: `config/plugins/editor/todo-comments.nix`
- Create: `config/plugins/editor/undotree.nix`
- Create: `config/plugins/editor/flash.nix`

- [ ] **Step 1:** Create default.nix importing all editor plugins
- [ ] **Step 2:** Implement treesitter.nix (grammars, textobjects, context, incremental selection)
- [ ] **Step 3:** Implement mini.nix (pairs, surround, ai, comment, icons, trailspace)
- [ ] **Step 4:** Implement todo-comments.nix, undotree.nix, flash.nix
- [ ] **Step 5:** Verify and commit

---

### Task 5: LSP + Formatting + Linting

**Files:**
- Create: `config/plugins/lsp/default.nix`
- Create: `config/plugins/lsp/lspconfig.nix`
- Create: `config/plugins/lsp/conform.nix`
- Create: `config/plugins/lsp/lint.nix`
- Create: `config/plugins/lsp/fidget.nix`

- [ ] **Step 1:** Create default.nix
- [ ] **Step 2:** Implement lspconfig.nix (diagnostic settings, on_attach keymaps, no servers — those in languages/)
- [ ] **Step 3:** Implement conform.nix (format-on-save 500ms timeout, formatter table)
- [ ] **Step 4:** Implement lint.nix (linters per filetype, BufWritePost+BufReadPost triggers)
- [ ] **Step 5:** Implement fidget.nix
- [ ] **Step 6:** Verify and commit

---

### Task 6: Completion

**Files:**
- Create: `config/plugins/completion/default.nix`
- Create: `config/plugins/completion/blink-cmp.nix`
- Create: `config/plugins/completion/copilot.nix`
- Create: `config/plugins/completion/luasnip.nix`

- [ ] **Step 1:** Implement blink-cmp.nix (sources: lsp, copilot, snippets, buffer, path; keymaps)
- [ ] **Step 2:** Implement copilot.nix (copilot.lua as blink source)
- [ ] **Step 3:** Implement luasnip.nix (friendly-snippets, jump keymaps)
- [ ] **Step 4:** Verify and commit

---

### Task 7: Navigation

**Files:**
- Create: `config/plugins/navigation/default.nix`
- Create: `config/plugins/navigation/fzf-lua.nix`
- Create: `config/plugins/navigation/yazi.nix`

- [ ] **Step 1:** Implement fzf-lua.nix (all leader-f keymaps, fd+rg as extraPackages)
- [ ] **Step 2:** Implement yazi.nix (floating window, leader-e keymaps, yazi as extraPackage)
- [ ] **Step 3:** Verify and commit

---

### Task 8: Git

**Files:**
- Create: `config/plugins/git/default.nix`
- Create: `config/plugins/git/gitsigns.nix`
- Create: `config/plugins/git/lazygit.nix`

- [ ] **Step 1:** Implement gitsigns.nix (signs, hunk keymaps, inline blame)
- [ ] **Step 2:** Implement lazygit.nix (leader-gg, lazygit as extraPackage)
- [ ] **Step 3:** Verify and commit

---

### Task 9: Utils

**Files:**
- Create: `config/plugins/utils/default.nix`
- Create: `config/plugins/utils/direnv.nix`
- Create: `config/plugins/utils/trouble.nix`

- [ ] **Step 1:** Implement direnv.nix (auto-load .envrc, silent)
- [ ] **Step 2:** Implement trouble.nix (leader-x keymaps)
- [ ] **Step 3:** Verify and commit

---

### Task 10: Language Configurations

**Files:**
- Create: `config/languages/default.nix`
- Create: `config/languages/nix.nix`
- Create: `config/languages/c-cpp.nix`
- Create: `config/languages/zig.nix`
- Create: `config/languages/haskell.nix`
- Create: `config/languages/python.nix`
- Create: `config/languages/shell.nix`
- Create: `config/languages/common.nix`

- [ ] **Step 1:** Create default.nix importing all language files
- [ ] **Step 2:** Implement each language file (LSP server config + extraPackages)
- [ ] **Step 3:** Implement common.nix (lua-ls, jsonls, yamlls)
- [ ] **Step 4:** Verify and commit

---

### Task 11: Imperative Lua Overrides

**Files:**
- Create: `lua/user-init.lua`
- Create: `lua/user-keymaps.lua`
- Create: `lua/user-theme.lua`
- Modify: `config/default.nix`

- [ ] **Step 1:** Add extraConfigLuaPost to config/default.nix — glob+dofile from ~/.config/nixvim/lua/
- [ ] **Step 2:** Create lua/ files with commented-out examples
- [ ] **Step 3:** Verify and commit

---

### Task 12: Final Verification & Polish

- [ ] **Step 1:** Full build: `nix build .`
- [ ] **Step 2:** Check: `nix flake check`
- [ ] **Step 3:** Launch and smoke test
- [ ] **Step 4:** Test imperative override mechanism
- [ ] **Step 5:** Final commit if needed
