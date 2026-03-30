{ lib, ... }:
{
  diagnostic.settings = {
    severity_sort = true;
    update_in_insert = false;
    underline = true;

    virtual_text = {
      spacing = 2;
      source = "if_many";
    };

    float = {
      border = "rounded";
      source = "if_many";
    };

    signs = {
      text = {
        "vim.diagnostic.severity.ERROR" = lib.nixvim.mkRaw ''"E"'';
        "vim.diagnostic.severity.WARN" = lib.nixvim.mkRaw ''"W"'';
        "vim.diagnostic.severity.INFO" = lib.nixvim.mkRaw ''"I"'';
        "vim.diagnostic.severity.HINT" = lib.nixvim.mkRaw ''"H"'';
      };
    };
  };

  plugins.lsp = {
    enable = true;

    keymaps = {
      silent = true;

      diagnostic = {
        "<leader>xx" = {
          action = "open_float";
          desc = "Line diagnostics";
        };
        "<leader>xq" = {
          action = "setloclist";
          desc = "Diagnostics list";
        };
      };

      lspBuf = {
        "gd" = {
          action = "definition";
          desc = "Goto definition";
        };
        "gD" = {
          action = "declaration";
          desc = "Goto declaration";
        };
        "gr" = {
          action = "references";
          desc = "Goto references";
        };
        "gI" = {
          action = "implementation";
          desc = "Goto implementation";
        };
        "gy" = {
          action = "type_definition";
          desc = "Goto type definition";
        };
        "K" = {
          action = "hover";
          desc = "Hover documentation";
        };
        "<leader>la" = {
          action = "code_action";
          desc = "Code action";
        };
        "<leader>lr" = {
          action = "rename";
          desc = "Rename symbol";
        };
      };

      extra = [
        {
          key = "[d";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1, float = true }) end";
          options.desc = "Previous diagnostic";
        }
        {
          key = "]d";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1, float = true }) end";
          options.desc = "Next diagnostic";
        }
        {
          key = "<leader>lf";
          action = lib.nixvim.mkRaw "function() require(\"conform\").format({ async = true, lsp_format = \"fallback\" }) end";
          options.desc = "Format buffer";
        }
      ];
    };

    onAttach = ''
      if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    '';

    inlayHints = true;
  };
}
