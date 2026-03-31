{ pkgs, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  opts = {
    number = true;
    relativenumber = true;

    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;

    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    signcolumn = "yes";
    cursorline = true;
    termguicolors = true;

    splitright = true;
    splitbelow = true;

    updatetime = 250;
    timeoutlen = 300;
    swapfile = false;
    undofile = true;
  };

  clipboard = {
    register = "unnamedplus";
    providers = {
      "wl-copy".enable = pkgs.stdenv.hostPlatform.isLinux;
      xclip.enable = pkgs.stdenv.hostPlatform.isLinux;
      pbcopy.enable = pkgs.stdenv.hostPlatform.isDarwin;
    };
  };
}
