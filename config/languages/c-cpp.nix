{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    clang-tools
  ];

  plugins.lsp.servers.clangd.enable = true;
}
