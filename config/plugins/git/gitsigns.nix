{ lib, ... }:
{
  keymaps = [
    {
      mode = "n";
      key = "]h";
      action = lib.nixvim.mkRaw "function() require('gitsigns').nav_hunk('next') end";
      options = {
        desc = "Next hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "[h";
      action = lib.nixvim.mkRaw "function() require('gitsigns').nav_hunk('prev') end";
      options = {
        desc = "Previous hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ghs";
      action = lib.nixvim.mkRaw "function() require('gitsigns').stage_hunk() end";
      options = {
        desc = "Stage hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ghr";
      action = lib.nixvim.mkRaw "function() require('gitsigns').reset_hunk() end";
      options = {
        desc = "Reset hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = lib.nixvim.mkRaw "function() require('gitsigns').preview_hunk() end";
      options = {
        desc = "Preview hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ghb";
      action = lib.nixvim.mkRaw "function() require('gitsigns').blame_line() end";
      options = {
        desc = "Blame line";
        silent = true;
      };
    }
  ];

  plugins.gitsigns = {
    enable = true;

    settings = {
      signs = {
        add.text = "+";
        change.text = "~";
        delete.text = "_";
        topdelete.text = "^";
        changedelete.text = "~";
        untracked.text = "|";
      };

      signcolumn = true;
      watch_gitdir.follow_files = true;
      current_line_blame = true;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 300;
        ignore_whitespace = false;
      };
    };
  };
}
