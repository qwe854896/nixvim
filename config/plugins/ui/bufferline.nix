{ ... }:
{
  plugins = {
    web-devicons.enable = true;

    bufferline = {
      enable = true;

      settings = {
        options = {
          always_show_bufferline = false;
          separator_style = "thin";
          show_close_icon = false;
          show_buffer_close_icons = false;
        };

        highlights.__raw = ''require("catppuccin.special.bufferline").get_theme()'';
      };
    };
  };
}
