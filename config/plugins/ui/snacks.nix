_: {
  plugins.snacks = {
    enable = true;

    settings = {
      bigfile.enabled = false;
      quickfile.enabled = false;
      statuscolumn.enabled = false;
      words.enabled = false;

      dashboard = {
        enabled = true;
        sections = [
          { section = "header"; }
          { section = "keys"; }
        ];
      };
      notifier = {
        enabled = true;
        timeout = 3000;
        style = "compact";
      };
      terminal.enabled = true;
      indent.enabled = true;
    };
  };
}
