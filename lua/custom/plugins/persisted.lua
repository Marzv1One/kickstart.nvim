return {
  -- Lua
  {
    'olimorris/persisted.nvim',
    lazy = false,
    -- event = 'BufReadPre', -- Ensure the plugin loads only when a buffer has been loaded
    opts = {
      -- Your config goes here ...
      autoload = true,
    },
  },
}
