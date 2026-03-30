{ pkgs, ... }:
{
  plugins = {
    treesitter = {
      enable = true;

      highlight.enable = true;
      indent.enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        haskell
        json
        lua
        markdown
        markdown_inline
        nix
        python
        query
        regex
        toml
        vim
        vimdoc
        yaml
        zig
      ];

      settings = {
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };
      };
    };

    treesitter-context = {
      enable = true;

      settings = {
        max_lines = 3;
        multiline_threshold = 1;
        trim_scope = "inner";
      };
    };

    treesitter-textobjects = {
      enable = true;

      settings = {
        select = {
          enable = true;
          lookahead = true;

          keymaps = {
            "aA" = "@parameter.outer";
            "iA" = "@parameter.inner";
            "aF" = "@function.outer";
            "iF" = "@function.inner";
            "aC" = "@class.outer";
            "iC" = "@class.inner";
          };
        };

        move = {
          enable = true;
          set_jumps = true;

          goto_next_start = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
          };

          goto_previous_start = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
          };
        };
      };
    };
  };
}
