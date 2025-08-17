local neoscroll = require 'neoscroll'
local keymap = {
  ['<C-u>'] = function()
    neoscroll.ctrl_u { duration = 200, easing = 'sine' }
    vim.cmd [[normal! zz]]
  end,
  ['<C-d>'] = function()
    neoscroll.ctrl_d { duration = 200, easing = 'sine' }
    vim.cmd [[normal! zz]]
  end,
  ['<C-b>'] = function()
    neoscroll.ctrl_b { duration = 250, easing = 'circular' }
    vim.cmd [[normal! zz]]
  end,
  ['<C-f>'] = function()
    neoscroll.ctrl_f { duration = 250, easing = 'circular' }
    vim.cmd [[normal! zz]]
  end,
}

local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func, { silent = true })
end
