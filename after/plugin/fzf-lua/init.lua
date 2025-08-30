local fzf = require 'fzf-lua'
-- local utils = require 'fzf-lua.utils'

_G.fzf_dirs = function(opts)
  opts = opts or {}
  opts.prompt = 'Directories> '
  opts.winopts = {
    height = 0.5,
    width = 0.6,
  }
  opts.actions = {
    ['enter'] = function(selected)
      vim.cmd(string.format('cd %s', selected[1]))
    end,
    ['ctrl-y'] = function(selected)
      vim.cmd(string.format('cd %s', selected[1]))
    end,
  }
  fzf.fzf_exec('fd --type d', opts)
end

vim.keymap.set('n', '<leader>f;', fzf_dirs, { noremap = true, desc = 'Directories' })

_G.live_grep = function(opts)
  opts = opts or {}
  opts.prompt = 'rg> '
  opts.file_icons = true
  opts.color_icons = true
  opts.actions = fzf.defaults.actions.files
  opts.previewer = 'builtin'
  opts.fn_transform = function(x)
    return fzf.make_entry.file(x, opts)
  end
  return fzf.fzf_live(function(args)
    return 'rg --column --color=always -- ' .. vim.fn.shellescape(args[1] or '')
  end, opts)
end

vim.keymap.set('n', '<leader>f,', live_grep, { noremap = true, desc = 'Live Grep' })

return {}
