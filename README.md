# nixvim

A standalone Neovim flake built with [Nixvim](https://github.com/nix-community/nixvim) for a reproducible, Nix-native editor setup.

## Quick Start

This flake currently targets `x86_64-linux` only.

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
<summary>Plugin inventory</summary>

| Category | Plugins |
| --- | --- |
| UI | catppuccin, lualine, bufferline, which-key, snacks |
| Editor | treesitter, mini.nvim, todo-comments, undotree, flash |
| Completion | blink-cmp, copilot, luasnip, friendly-snippets |
| LSP | lspconfig, conform, lint, fidget |
| Navigation | fzf-lua, yazi |
| Git | gitsigns, lazygit |
| Utils | direnv, trouble |

</details>

## Language Support

| Language | LSP | Formatter | Linter |
| --- | --- | --- | --- |
| Nix | nixd | nixfmt | statix, deadnix |
| C/C++ | clangd | clang-format | -- |
| Zig | zls | zig fmt | -- |
| Haskell | hls | ormolu | -- |
| Python | basedpyright | ruff | ruff |
| Shell | bashls | shfmt | shellcheck |
| Lua | lua_ls | stylua | -- |
| JSON | jsonls | -- | -- |
| YAML | yamlls | -- | -- |

## Installation

### Standalone

```bash
nix run github:qwe854896/nixvim
```

### Profile install

```bash
nix profile install github:qwe854896/nixvim
```

### Flake input

```nix
{
  inputs.nixvim.url = "github:qwe854896/nixvim";

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.symlinkJoin {
        name = "nvim";
        paths = [ inputs.nixvim.packages.${system}.default ];
      };
    };
}
```

### Template

```bash
nix flake init -t github:qwe854896/nixvim
```

The exported template is intentionally minimal and does not include this repo's `~/.config/nixvim/lua/*.lua` runtime override loader by default.

## Customization

Runtime overrides are loaded from `~/.config/nixvim/lua/*.lua` at startup. The tracked `lua/user-init.lua`, `lua/user-keymaps.lua`, and `lua/user-theme.lua` files in this repo are starter examples to copy into that directory; they are not loaded automatically from the repository checkout.

## Acknowledgments

- [nix-community/nixvim](https://github.com/nix-community/nixvim)
- [elythh/nixvim](https://github.com/elythh/nixvim)
- [khaneliman/khanelivim](https://github.com/khaneliman/khanelivim)
- [dc-tec/nixvim](https://github.com/dc-tec/nixvim)

## License

Licensed under the [MIT License](LICENSE).
