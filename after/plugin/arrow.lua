local arrow_persist = require 'arrow.persist'

local map = vim.keymap.set

map('n', '[a', arrow_persist.previous, { noremap = true, silent = true })
map('n', ']a', arrow_persist.next, { noremap = true, silent = true })
map('n', '<leader>a', arrow_persist.toggle, { noremap = true, silent = true })
