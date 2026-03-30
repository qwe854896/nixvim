{ lib, ... }:
{
  plugins.lint = {
    enable = true;

    autoCmd = {
      event = [ "BufReadPost" "BufWritePost" ];
      callback = lib.nixvim.mkRaw ''
        function()
          require("lint").try_lint()
        end
      '';
    };

    lintersByFt = {
      nix = [ "deadnix" "statix" ];
      python = [ "ruff" ];
      bash = [ "bash" "shellcheck" ];
      zsh = [ "shellcheck" ];
    };
  };
}
