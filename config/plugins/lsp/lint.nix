{ pkgs, lib, ... }:
{
  extraPackages = with pkgs; [
    deadnix
    statix
    ruff
    shellcheck
  ];

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
      sh = [ "shellcheck" ];
      bash = [ "shellcheck" ];
      zsh = [ "shellcheck" ];
    };
  };
}
