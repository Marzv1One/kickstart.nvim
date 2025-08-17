local fzf = require 'fzf-lua'

local M = {}

M.fzf_dirs = function(opts)
  opts = opts or {}
  opts.prompt = 'Oil> '
  opts.winopts = {
    height = 0.5,
    width = 0.6,
  }
  opts.actions = {
    ['enter'] = function(selected)
      vim.cmd(string.format('Oil %s', selected[1]))
    end,
    ['ctrl-y'] = function(selected)
      vim.cmd(string.format('Oil %s', selected[1]))
    end,
  }
  fzf.fzf_exec('fd --type d', opts)
end

vim.api.nvim_create_user_command('FzfDirs', M.fzf_dirs, { nargs = 0 })

vim.keymap.set('n', '<leader>fo', '<cmd>FzfDirs<CR>', { noremap = true, desc = 'Oil' })
