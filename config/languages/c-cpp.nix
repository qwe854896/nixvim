{ pkgs, ... }:
let
  clang-format = pkgs.symlinkJoin {
    name = "clang-format";
    paths = [ pkgs.clang-tools ];
    pathsToLink = [ "/bin/clang-format" ];
  };
in
{
  extraPackages = [
    clang-format
  ];

  plugins.lsp.servers.clangd.enable = true;
}
