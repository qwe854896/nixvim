{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    ormolu
  ];

  plugins.lsp.servers.hls = {
    enable = true;
    installGhc = false;
  };
}
