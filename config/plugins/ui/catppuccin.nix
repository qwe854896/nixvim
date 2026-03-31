_: {
  colorschemes.catppuccin = {
    enable = true;

    settings = {
      flavour = "mocha";
      default_integrations = false;

      integrations = {
        bufferline = true;
        lualine = true;
        which_key = true;
        snacks = {
          enabled = true;
          indent_scope_color = "lavender";
        };
      };
    };
  };
}
