return {
  'lewis6991/hover.nvim',
  event = 'BufEnter',
  config = function()
    require('hover').setup {
      init = function()
        require 'hover.providers.lsp'
        require 'hover.providers.diagnostic'
        require 'hover.providers.dictionary'
      end,
    }

    local map = vim.keymap.set
    map('n', 'K', require('hover').hover, { desc = 'Hover' })
    map('n', 'gK', require('hover').hover_select, { desc = 'Hover (Select)' })
    map('n', '<M-t>', function()
      require('hover').hover_switch 'previous'
    end, { desc = 'Hover (Previous)' })
    map('n', '<M-n>', function()
      require('hover').hover_switch 'next'
    end, { desc = 'Hover (Next)' })
  end,
}
