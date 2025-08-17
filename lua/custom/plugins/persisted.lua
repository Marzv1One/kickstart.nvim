return {
  -- Lua
  {
    'olimorris/persisted.nvim',
    lazy = false,
    -- event = 'BufReadPre', -- Ensure the plugin loads only when a buffer has been loaded
    opts = {
      autoload = true,
      -- use_git_branch = true,
      --@return bool
      should_save = function()
        if vim.bo.filetype == 'dashboard' then
          return false
        end
        return true
      end,
      ignored_dirs = {
        -- vim.env.HOME,
      },
      -- allowed_dirs = {
      --   vim.fn.stdpath 'config',
      -- },
    },
  },
}
