_: {
  plugins.undotree = {
    enable = true;

    settings = {
      SetFocusWhenToggle = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>uu";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        desc = "Toggle undo tree";
        silent = true;
      };
    }
  ];
}
