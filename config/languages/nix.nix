{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    deadnix
    nixfmt
    statix
  ];

  plugins.lsp.servers.nixd.enable = true;
}
