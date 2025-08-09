local map = vim.keymap.set

map({ 'n', 'i', 'v' }, '<leader>w', '<Esc>:w<CR>', { desc = 'Save file', silent = true })

map('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open Oil file explorer' })
map('n', '<leader>e', '<CMD>Oil .<CR>', { desc = 'Open Oil file explorer root' })

map('n', '<leader>x', '<CMD>quit<CR>', { desc = 'Exit Neovim' })

map('n', '<leader>b', '<CMD>lua MiniBufremove.delete()<CR>', { desc = 'Delete buffer' })
