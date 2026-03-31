_: {
  plugins.fidget = {
    enable = true;

    settings = {
      progress = {
        ignore_empty_message = true;

        display = {
          done_ttl = 2;
          progress_icon = [ "dots" ];
          skip_history = true;
        };
      };

      notification.window.winblend = 0;
    };
  };
}
