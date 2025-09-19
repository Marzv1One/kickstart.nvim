local function is_hml_line(args)
  local so = vim.o.scrolloff
  local topline = vim.fn.line 'w0'
  local bottomline = vim.fn.line 'w$'
  local height = vim.api.nvim_win_get_height(0)
  local r = args.lnum - topline + 1
  if r <= 0 or r > height then return false end
  local at_top = topline == 1
  local at_bottom = bottomline == vim.api.nvim_buf_line_count(0)
  local H_row = at_top and 1 or math.min(height, 1 + so)
  local L_row = at_bottom and height or math.max(1, height - so - 1)
  local M_row = math.floor((1 + height) / 2)
  return r == H_row or r == M_row or r == L_row
end

local last_win, last_tick, printed = nil, 0, 0
local function debug_once_per_screen(msg)
  local w = vim.api.nvim_get_current_win()
  local tick = vim.b.changedtick or 0
  if w ~= last_win or tick ~= last_tick then
    last_win, last_tick, printed = w, tick, 0
  end
  if printed < 41 then
    printed = printed + 1
    -- vim.notify(vim.inspect(msg), vim.log.levels.INFO)
  end
end

local function bar_cell(args)
  local target = (args.relnum == 0) and 2 or 3
  local s = '┃'
  local pad = math.max(0, target - vim.fn.strdisplaywidth(s))
  return string.rep(' ', pad) .. s
end

local function get_hml_character(args)
  local builtin_statuscol = require 'statuscol.builtin'
  if args.relnum ~= 0 then
    return bar_cell(args)
  end
  return builtin_statuscol.lnumfunc(args) .. ' '
end

return {
  {
    'kevinhwang91/nvim-ufo',
    init = function()
      vim.o.foldcolumn = '1'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.api.nvim_create_autocmd({ 'WinScrolled', 'BufWinEnter', 'BufEnter', 'CursorMoved', 'CursorMovedI' }, {
        callback = function()
          pcall(vim.cmd.redrawstatus)
        end,
      })
    end,
    dependencies = {
      'kevinhwang91/promise-async',
      {
        'luukvbaal/statuscol.nvim',
        name = 'statuscol',
        config = function()
          local builtin = require 'statuscol.builtin'
          require('statuscol').setup {
            relculright = true,
            segments = {
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              {
                text = { builtin.lnumfunc, ' ' },
                condition = { function(a) return not is_hml_line(a) end },
                click = 'v:lua.ScLa',
              },
              {
                text = { get_hml_character, ' ' },
                condition = { is_hml_line },
                hl = 'Number',
              },
            },
          }
        end,
      },
      'chrisgrieser/nvim-origami',
    },
    event = 'LspAttach',
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText, suffix = {}, (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth, curWidth = width - sufWidth, 0
        for _, chunk in ipairs(virtText) do
          local chunkText, hlGroup = chunk[1], chunk[2]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup {
        fold_virt_text_handler = handler,
      }

      local function ufo_is_enabled(bufnr)
        local s = require('ufo.main').inspectBuf(bufnr)
        if not s then
          return false
        end
        return s[1] == true
      end

      local function disable_if_enabled()
        local bufnr = vim.api.nvim_get_current_buf()
        if ufo_is_enabled(bufnr) then
          require('ufo').disableFold(bufnr)
        end
      end

      local function enable_if_disabled()
        local bufnr = vim.api.nvim_get_current_buf()
        if not ufo_is_enabled(bufnr) then
          require('ufo').enableFold(bufnr)
        end
      end

      local function origami_l()
        disable_if_enabled()
        require('origami').l()
      end
      local function origami_zo()
        disable_if_enabled()
        vim.cmd.normal 'zo'
      end
      local function origami_zO()
        disable_if_enabled()
        vim.cmd.normal 'zO'
      end
      local function origami_h()
        local col = vim.fn.col '.'
        local non_blank = vim.api.nvim_get_current_line():match('^%s*'):len() + 1
        if col <= non_blank then
          enable_if_disabled()
        end
        require('origami').h()
      end

      local function map(keys, fun, desc)
        vim.keymap.set('n', keys, fun, { desc = 'UFO: ' .. desc })
      end

      map('zl', origami_l, 'Toggle fold')
      map('zh', origami_h, 'Toggle fold')
      map('zo', origami_zo, 'Open fold')
      map('zO', origami_zO, 'Open folds recursively')

      map('zR', function()
        require('ufo').openAllFolds()
      end, 'Open all folds')
      map('zM', function()
        require('ufo').closeAllFolds()
      end, 'Close all folds')
      map('zr', function()
        require('ufo').openFoldsExceptKinds()
      end, 'Open folds except kinds')
      map('zm', function()
        require('ufo').closeFoldsWith()
      end, 'Close folds with')
      map('[Z', function()
        require('ufo').goPreviousClosedFold()
      end, 'Previous closed fold')
      map(']Z', function()
        require('ufo').goNextClosedFold()
      end, 'Next closed fold')
      map('<leader>zz', function()
        require('ufo').disableFold(vim.api.nvim_get_current_buf())
      end, 'Disable fold')
      map('<leader>zZ', function()
        require('ufo').enableFold(vim.api.nvim_get_current_buf())
      end, 'Enable fold')
    end,
  },
}
