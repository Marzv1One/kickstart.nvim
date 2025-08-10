local map = vim.keymap.set

map({ 'n', 'i', 'v' }, '<leader>w', '<cmd>write<CR>', { desc = 'Save file', silent = true })
map({ 'n', 'i', 'v' }, '<leader>v', '<cmd>noautocmd write<CR>', { desc = 'Save file', silent = true })
map({ 'n', 'i', 'v' }, '<leader>y', '<cmd>noautocmd write<CR>', { desc = 'Save file', silent = true })

map('n', '<leader>o', '<cmd>Oil<CR>', { desc = 'Open Oil file explorer' })
map('n', '<leader>e', '<cmd>Oil .<CR>', { desc = 'Open Oil file explorer root' })

map('n', '<leader>x', '<cmd>quit<CR>', { desc = 'Exit Neovim' })

map('n', '<leader>b', '<cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete buffer' })

-- Vertical scroll and center
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })

-- Find and center
map('n', 'n', 'nzz', { desc = 'Find next' })
map('n', 'N', 'Nzz', { desc = 'Find previous' })

-- Stay in indent mode
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Through empty lines {  }
map('n', '{', '{zz', { desc = 'Through empty lines' })
map('n', '}', '}zz', { desc = 'Through empty lines' })
