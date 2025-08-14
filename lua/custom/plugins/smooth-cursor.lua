return {
  {
    'gen740/SmoothCursor.nvim',
    event = 'VeryLazy',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('smoothcursor').setup {
        -- type = 'matrix',
        ---@diagnostic disable-next-line: missing-fields
        fancy = {
          enable = true,
          head = {
            cursor = '',
          },
        },
      }
    end,
  },
}
