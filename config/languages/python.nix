{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    ruff
  ];

  plugins.lsp.servers.ty.enable = true;
  plugins.lsp.servers.ruff.enable = true;
}
