{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    stylua
  ];

  plugins.lsp.servers = {
    lua_ls.enable = true;
    jsonls.enable = true;
    yamlls.enable = true;
  };
}
