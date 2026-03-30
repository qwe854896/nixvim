{ ... }:
{
  plugins.which-key = {
    enable = true;

    settings = {
      preset = "classic";

      spec = [
        {
          __unkeyed-1 = "<leader>e";
          group = "Explorer";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Terminal";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "Diagnostics";
        }
      ];
    };
  };
}
