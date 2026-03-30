{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    yazi
  ];

  plugins.yazi = {
    enable = true;

    settings = {
      floating_window_scaling_factor = 0.85;
      yazi_floating_window_border = "rounded";
      yazi_floating_window_winblend = 0;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ee";
      action = "<cmd>Yazi<CR>";
      options = {
        desc = "Open yazi";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ef";
      action = "<cmd>Yazi cwd<CR>";
      options = {
        desc = "Yazi cwd";
        silent = true;
      };
    }
  ];
}
