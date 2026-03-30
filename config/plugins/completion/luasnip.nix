{ lib, ... }:
{
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

  keymaps = [
    {
      mode = [
        "i"
        "s"
      ];
      key = "<C-l>";
      action = lib.nixvim.mkRaw ''function() require("luasnip").jump(1) end'';
      options = {
        desc = "Snippet jump forward";
        silent = true;
      };
    }
    {
      mode = [
        "i"
        "s"
      ];
      key = "<C-h>";
      action = lib.nixvim.mkRaw ''function() require("luasnip").jump(-1) end'';
      options = {
        desc = "Snippet jump backward";
        silent = true;
      };
    }
  ];
}
