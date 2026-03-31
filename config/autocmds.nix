{ lib, ... }:
{
  autoGroups = {
    yank_highlight = {
      clear = true;
    };
    trim_trailing_whitespace = {
      clear = true;
    };
    restore_cursor_position = {
      clear = true;
    };
    resize_splits = {
      clear = true;
    };
    filetype_indent = {
      clear = true;
    };
  };

  autoCmd = [
    {
      event = "TextYankPost";
      group = "yank_highlight";
      desc = "Highlight when yanking text";
      callback = lib.nixvim.mkRaw ''
        function()
          vim.hl.on_yank()
        end
      '';
    }
    {
      event = "BufWritePre";
      group = "trim_trailing_whitespace";
      desc = "Trim trailing whitespace before saving";
      callback = lib.nixvim.mkRaw ''
        function()
          local view = vim.fn.winsaveview()
          vim.cmd([[keeppatterns %s/\s\+$//e]])
          vim.fn.winrestview(view)
        end
      '';
    }
    {
      event = "BufReadPost";
      group = "restore_cursor_position";
      desc = "Restore cursor to last position";
      callback = lib.nixvim.mkRaw ''
        function(args)
          local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
          local line_count = vim.api.nvim_buf_line_count(args.buf)

          if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
    {
      event = "VimResized";
      group = "resize_splits";
      desc = "Resize splits when terminal is resized";
      command = "wincmd =";
    }
    {
      event = "FileType";
      group = "filetype_indent";
      pattern = [
        "python"
        "c"
        "zig"
      ];
      desc = "Use 4-space indentation for select filetypes";
      callback = lib.nixvim.mkRaw ''
        function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
        end
      '';
    }
  ];
}
