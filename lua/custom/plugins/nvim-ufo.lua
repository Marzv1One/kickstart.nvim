local my_function = function(args)
  local scrolloff = vim.o.scrolloff
  -- local win_height = vim.api.nvim_win_get_height(0)
  -- local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lnum = args.lnum
  local buf_line_count = vim.api.nvim_buf_line_count(0)

  local topline = vim.fn.line 'w0'
  local bottomline = vim.fn.line 'w$'

  -- local H_line = math.min(bottomline, topline + scrolloff)
  -- local M_line = math.floor((topline + bottomline) / 2)
  -- local L_line = math.max(topline, bottomline - scrolloff)

  -- H (High): top of screen + scrolloff (unless at top of file)
  local H_line
  if topline == 1 then
    H_line = 1
  else
    H_line = math.min(bottomline, topline + scrolloff)
  end

  -- M (Middle): actual screen middle (no edge case needed)
  local M_line = math.floor((topline + bottomline) / 2)

  -- L (Low): bottom of screen - scrolloff (unless at bottom of file)
  local L_line
  if bottomline == buf_line_count then
    L_line = buf_line_count
  else
    L_line = math.max(topline, bottomline - scrolloff)
  end

  -- Compute relative numbers
  -- local rel_H = H_line - lnum
  -- local rel_M = M_line - lnum
  -- local rel_L = L_line - lnum

  return L_line == lnum or H_line == lnum or M_line == lnum

  -- return (H_line + math.abs(rel_H) == L_line)

  -- return (H_line + math.abs(rel_H) == L_line) and rel_L ~= 0

  -- return (cursor_line ~= topline and math.abs(rel_H) + math.abs(rel_M) == 3 * scrolloff)

  -- return (rel_H == 0 and math.abs(rel_H) + math.abs(rel_M) == 20) or (rel_L == 0 and math.abs(rel_M) + math.abs(rel_L) == 20)
end

local function get_character(args)
  -- vim.notify(vim.inspect(args), vim.log.levels.INFO)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  if args.lnum ~= cursor_line then
    return '  ┃'
  else
    return require('statuscol.builtin').lnumfunc(args)
  end
  -- return '  ┃'
end

return {
  {
    'kevinhwang91/nvim-ufo',
    init = function()
      vim.o.foldcolumn = '1'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      -- vim.o.foldenable = true
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
                condition = {
                  function(args)
                    return not my_function(args)
                  end,
                },
                -- condition = { true, builtin.not_empty },
                click = 'v:lua.ScLa',
              },
              {
                text = { get_character, ' ' },
                -- text = { '  ┃', ' ' },
                condition = {
                  my_function,
                },
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
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
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
      ---@diagnostic disable-next-line: missing-fields
      require('ufo').setup {
        -- fold_virt_text_handler = handler,
      }

      local is_enable = function(bufnr)
        -- local bufnr = vim.api.nvim_get_current_buf()
        local status = require('ufo.main').inspectBuf(bufnr)
        if not status then
          return
        end
        local is_enable = status[2]
        is_enable = is_enable:gsub('Fold Status: ', '')
        return is_enable == 'start'
      end
      local disable_if_enable = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local enable = is_enable(bufnr)
        if enable then
          require('ufo').disableFold(bufnr)
        end
      end
      local enable_if_disable = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local enable = is_enable(bufnr)
        if not enable then
          require('ufo').enableFold(bufnr)
        end
      end
      -- local toggle_disable = function()
      --   local bufnr = vim.api.nvim_get_current_buf()
      --   local is_enable = is_enable(bufnr)
      --   if is_enable then
      --     require('ufo').disableFold(bufnr)
      --   else
      --     require('ufo').enableFold(bufnr)
      --   end
      -- end

      function Origami_l()
        disable_if_enable()
        require('origami').l()
      end
      function Origami_zo()
        disable_if_enable()
        vim.cmd 'normal zo'
      end
      function Origami_zO()
        disable_if_enable()
        vim.cmd 'normal zO'
      end
      function Origami_h()
        local col = vim.fn.col '.'
        local non_blank = vim.api.nvim_get_current_line():match('^%s*'):len() + 1
        if col <= non_blank then
          enable_if_disable()
        end
        require('origami').h()
      end

      local map = function(keys, fun, desc)
        vim.keymap.set('n', keys, fun, { desc = 'UFO: ' .. desc })
      end

      map('l', function()
        Origami_l()
      end, 'Toggle fold')
      map('h', function()
        Origami_h()
      end, 'Toggle fold')
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
