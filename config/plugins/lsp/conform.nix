{ lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;

    settings = {
      formatters_by_ft = {
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
        haskell = [ "ormolu" ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        python = [ "ruff_format" ];
        sh = [ "shfmt" ];
        bash = [ "shfmt" ];
        zsh = [ "shfmt" ];
        zig = [ "zigfmt" ];
      };

      format_on_save = {
        lsp_format = "fallback";
        timeout_ms = 500;
      };

      notify_on_error = true;
      notify_no_formatters = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lf";
      action = lib.nixvim.mkRaw "function() require(\"conform\").format({ async = true, lsp_format = \"fallback\" }) end";
      options = {
        desc = "Format buffer";
        silent = true;
      };
    }
  ];
}
