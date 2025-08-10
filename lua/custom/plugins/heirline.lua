return {
  {
    'rebelot/heirline.nvim',
    event = 'BufEnter',
    config = function()
      vim.o.cmdheight = 0
      require 'custom.heirline'
    end,
  },
}
