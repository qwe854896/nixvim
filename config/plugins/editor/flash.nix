{ ... }:
{
  plugins.flash = {
    enable = true;

    settings.modes.char.enabled = false;
  };

  keymaps = [
    {
      mode = [ "n" "x" "o" ];
      key = "<leader>fj";
      action = "<cmd>lua require('flash').jump()<CR>";
      options = {
        desc = "Flash jump";
        silent = true;
      };
    }
    {
      mode = [ "n" "x" "o" ];
      key = "<leader>ft";
      action = "<cmd>lua require('flash').treesitter()<CR>";
      options = {
        desc = "Flash treesitter";
        silent = true;
      };
    }
  ];
}
