return {
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>k' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    opts = {
      use_default_keymaps = false,
      max_join_lenght = 150,
    },
    init = function()
      vim.keymap.set('n', '<leader>j', require('treesj').join, { desc = 'Join with treesj' })
      vim.keymap.set('n', '<leader>k', require('treesj').split, { desc = 'Split with treesj' })
      vim.keymap.set('n', '<space>m', require('treesj').toggle, { desc = 'Toggle with treesj' })
    end,
  },
}
