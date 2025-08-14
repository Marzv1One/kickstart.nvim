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

-- Spawn commands in Wezterm
map('n', '<leader>Tc', '<cmd>SpawnCrush<CR>', { desc = 'Spawn Crush in new Wezterm window' })
map('n', '<leader>Tg', '<cmd>SpawnLazygit<CR>', { desc = 'Spawn Lazygit in new Wezterm window' })
map('n', '<leader>Tb', '<cmd>SpawnBat<CR>', { desc = 'Spawn Bat in new Wezterm window' })
map('n', '<leader>Ts', '<cmd>SpawnSpf<CR>', { desc = 'Spawn Superfile in new Wezterm window' })
map('n', '<leader>Tm', '<cmd>SpawnGlow<CR>', { desc = 'Spawn Glow in new Wezterm window' })
map('n', '<leader>Tt', '<cmd>SpawnTerm<CR>', { desc = 'Spawn new Wezterm window' })

-- Gopass integration
map('n', '<leader>gp', '<cmd>luafile ~/.config/nvim/after/plugin/fzf-lua/gopass.lua<CR>', { desc = 'Gopass menu', silent = true })

-- Optional: Add visual mode mappings for commands that might work with selections
-- map('v', '<leader>u', ':UnescapeUnicode<CR>', { desc = 'Unescape Unicode in selection' })

-- Incremental Rename
vim.keymap.set('n', '<leader>rr', ':IncRename ')
vim.keymap.set('n', '<leader>rn', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { expr = true })
