local map = vim.keymap.set

map({ 'n', 'i', 'v' }, '<leader>w', '<Esc>:w<CR>', { desc = 'Save file', silent = true })
map('n', '<leader>fo', '<cmd>Oil<CR>', { desc = 'Open Oil file explorer' })
map('n', '<leader>fe', '<cmd>Oil .<CR>', { desc = 'Open Oil file explorer' })
map('n', '<leader>x', ':quit<CR>', { desc = 'Exit Neovim' })
