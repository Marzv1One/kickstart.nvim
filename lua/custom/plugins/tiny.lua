return {
  {
    'rachartier/tiny-devicons-auto-colors.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'VeryLazy',
    opts = {},
    -- config = function()
    --     require('tiny-devicons-auto-colors').setup()
    -- end
  },
  {
    'rachartier/tiny-glimmer.nvim',
    event = 'VeryLazy',
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
      -- your configuration
    },
  },
}
