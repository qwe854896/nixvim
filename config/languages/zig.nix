{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    zig
  ];

  plugins.lsp.servers.zls.enable = true;
}
