{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    fd
    ripgrep
  ];

  plugins = {
    web-devicons.enable = true;

    fzf-lua = {
      enable = true;

      keymaps = {
        "<leader>ff" = {
          action = "files";
          options = {
            desc = "Find files";
            silent = true;
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "Live grep";
            silent = true;
          };
        };
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Find buffers";
            silent = true;
          };
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options = {
            desc = "Document symbols";
            silent = true;
          };
        };
        "<leader>fS" = {
          action = "lsp_workspace_symbols";
          options = {
            desc = "Workspace symbols";
            silent = true;
          };
        };
        "<leader>fd" = {
          action = "diagnostics_document";
          options = {
            desc = "Buffer diagnostics";
            silent = true;
          };
        };
        "<leader>fD" = {
          action = "diagnostics_workspace";
          options = {
            desc = "Workspace diagnostics";
            silent = true;
          };
        };
      };

      settings = {
        winopts = {
          height = 0.85;
          width = 0.8;
          row = 0.35;
          col = 0.5;
          preview = {
            border = "rounded";
            layout = "vertical";
            vertical = "down:45%";
          };
        };
      };
    };
  };
}
