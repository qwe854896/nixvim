{ lib, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;

    settings = {
      keymap = {
        preset = "default";

        "<C-space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<C-e>" = [ "hide" ];
        "<CR>" = [ "select_and_accept" ];

        "<Tab>" = [
          "snippet_forward"
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "snippet_backward"
          "select_prev"
          "fallback"
        ];

        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];
        "<C-p>" = [
          "select_prev"
          "fallback"
        ];
        "<C-n>" = [
          "select_next"
          "fallback"
        ];

        "<C-b>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];
      };

      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "mono";
      };

      completion = {
        documentation.auto_show = true;
        ghost_text.enabled = false;
        list.selection = {
          preselect = true;
          auto_insert = false;
        };
      };

      signature.enabled = true;

      snippets = {
        expand = lib.nixvim.mkRaw ''function(snippet) require("luasnip").lsp_expand(snippet) end'';
        active = lib.nixvim.mkRaw ''function(filter) return require("luasnip").in_snippet() end'';
        jump = lib.nixvim.mkRaw ''function(direction) require("luasnip").jump(direction) end'';
      };

      sources = {
        default = [
          "lsp"
          "copilot"
          "snippets"
          "buffer"
          "path"
        ];

        providers = {
          lsp.fallbacks = [ "buffer" ];
          path.score_offset = 3;
          snippets.score_offset = -1;
          buffer.score_offset = -3;
          copilot = {
            name = "copilot";
            module = "blink-cmp-copilot";
            async = true;
            score_offset = 100;
          };
        };
      };
    };
  };
}
