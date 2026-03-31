_: {
  plugins.todo-comments = {
    enable = true;

    keymaps = {
      todoQuickFix = {
        key = "<leader>xt";
        options = {
          desc = "Todo quickfix";
          silent = true;
        };
      };

      todoLocList = {
        key = "<leader>xT";
        options = {
          desc = "Todo location list";
          silent = true;
        };
      };
    };
  };
}
