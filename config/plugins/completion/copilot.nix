_: {
  plugins = {
    blink-cmp-copilot.enable = true;

    copilot-lua = {
      enable = true;

      settings = {
        panel.enabled = false;

        suggestion = {
          enabled = false;
          auto_trigger = false;
        };
      };
    };
  };
}
