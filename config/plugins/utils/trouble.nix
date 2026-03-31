_: {
  plugins.trouble.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = {
        desc = "Diagnostics list";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options = {
        desc = "Buffer diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options = {
        desc = "Location list";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<CR>";
      options = {
        desc = "Quickfix list";
        silent = true;
      };
    }
  ];
}
