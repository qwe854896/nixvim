{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    ruff
  ];

  plugins.lsp.servers.basedpyright.enable = true;
}
