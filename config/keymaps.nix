{ ... }:
{
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<CR>";
      options.silent = true;
    }
    {
      mode = [
        "n"
        "i"
        "v"
      ];
      key = "<C-s>";
      action = "<cmd>write<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>quit<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>bdelete<CR>";
      options.silent = true;
    }
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.silent = true;
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.silent = true;
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }
    {
      mode = "n";
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }
  ];
}
