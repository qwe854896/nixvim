{ lib, ... }:
{
  plugins.gitsigns = {
    enable = true;

    settings = {
      on_attach = lib.nixvim.mkRaw ''
        function(bufnr)
          local gitsigns = require('gitsigns')
          local opts = { buffer = bufnr, silent = true }

          vim.keymap.set('n', ']h', function()
            gitsigns.nav_hunk('next')
          end, vim.tbl_extend('force', opts, { desc = 'Next hunk' }))

          vim.keymap.set('n', '[h', function()
            gitsigns.nav_hunk('prev')
          end, vim.tbl_extend('force', opts, { desc = 'Previous hunk' }))

          vim.keymap.set('n', '<leader>ghs', gitsigns.stage_hunk, vim.tbl_extend('force', opts, { desc = 'Stage hunk' }))
          vim.keymap.set('n', '<leader>ghr', gitsigns.reset_hunk, vim.tbl_extend('force', opts, { desc = 'Reset hunk' }))
          vim.keymap.set('n', '<leader>ghp', gitsigns.preview_hunk, vim.tbl_extend('force', opts, { desc = 'Preview hunk' }))
          vim.keymap.set('n', '<leader>ghb', gitsigns.blame_line, vim.tbl_extend('force', opts, { desc = 'Blame line' }))
        end
      '';

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
