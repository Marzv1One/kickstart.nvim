return {
  -- For `plugins/markview.lua` users.
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    opts = {},
    -- For `nvim-treesitter` users.
    priority = 49,

    -- For blink.cmp's completion
    -- source
    dependencies = {
      'saghen/blink.cmp',
    },
  },
}
