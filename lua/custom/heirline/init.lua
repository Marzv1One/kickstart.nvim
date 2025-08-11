local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

local icons = require('custom.heirline.common').icons

local function setup_colors()
  return {
    bright_bg = utils.get_highlight('Folded').bg,
    bright_fg = utils.get_highlight('Folded').fg,
    red = utils.get_highlight('DiagnosticError').fg,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = utils.get_highlight('String').fg,
    blue = utils.get_highlight('Function').fg,
    gray = utils.get_highlight('NonText').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('Statement').fg,
    cyan = utils.get_highlight('Special').fg,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
    git_del = utils.get_highlight('diffDeleted').fg,
    git_add = utils.get_highlight('diffAdded').fg,
    git_change = utils.get_highlight('diffChanged').fg,
  }
end
require('heirline').load_colors(setup_colors())

vim.o.laststatus = 3
vim.o.showcmdloc = 'statusline'

require('heirline').setup {
  statusline = require('custom.heirline.statusline').statusline,
  winbar = require('custom.heirline.statusline').winbar,
  tabline = require 'custom.heirline.tabline',
  statuscolumn = require 'custom.heirline.statuscolumn',
  opts = {
    disable_winbar_cb = function(args)
      local is_valid = vim.api.nvim_buf_is_valid(args.buf)
      if not is_valid then
        return true
      end
      -- if vim.bo[args.buf].filetype == 'neo-tree' then
      --   return
      -- end
      return conditions.buffer_matches({
        buftype = { 'nofile', 'prompt', 'help', 'quickfix', 'acwrite' },
        filetype = { '^git.*', 'fugitive', 'Trouble', 'dashboard', 'fzf', 'neocomposer-menu' },
      }, args.buf)
    end,
    colors = setup_colors,
  },
}

vim.o.statuscolumn = require('heirline').eval_statuscolumn()

vim.api.nvim_create_augroup('Heirline', { clear = true })

vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

-- vim.cmd("au BufWinEnter * if &bt != '' | setl stc= | endif")

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = 'Heirline',
})
