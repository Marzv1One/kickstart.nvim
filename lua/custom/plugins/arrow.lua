return {
  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      -- or if using `mini.icons`
      --     -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
      leader_key = ';', -- Recommended to be a single key
      buffer_leader_key = 'gm', -- Per Buffer Mappings
      window = {
        width = 95,
        height = 25,
        row = 5,
        col = 15,
        border = 'rounded',
      },
      per_buffer_config = {
        lines = 5,
        satellite = { enable = true },
      },
    },
  },
}
