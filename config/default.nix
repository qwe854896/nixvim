{ ... }:
{
  imports = [
    ./languages
    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  extraConfigLuaPost = ''
    local user_lua_dir = vim.fn.stdpath("config") .. "/lua"
    local user_lua_files = vim.fn.globpath(user_lua_dir, "*.lua", false, true)

    table.sort(user_lua_files)

    for _, file in ipairs(user_lua_files) do
      local ok, err = pcall(dofile, file)

      if not ok then
        vim.notify(("Failed loading %s: %s"):format(file, err), vim.log.levels.ERROR)
      end
    end
  '';
}
