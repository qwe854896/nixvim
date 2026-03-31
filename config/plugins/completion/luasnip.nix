_: {
  plugins = {
    friendly-snippets.enable = true;

    luasnip = {
      enable = true;

      settings = {
        history = true;
        update_events = [
          "TextChanged"
          "TextChangedI"
        ];
      };
    };
  };
}
