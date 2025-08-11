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
                condition = { true, builtin.not_empty },
                click = 'v:lua.ScLa',
              },
            },
          }
        end,
      },
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
        fold_virt_text_handler = handler,
      }

      local map = function(keys, fun, desc)
        vim.keymap.set('n', keys, fun, { desc = 'UFO: ' .. desc })
      end

      map('l', function()
        require('custom.nvim-ufo').l()
      end, 'Toggle fold')
      map('h', function()
        require('origami').h()
        -- require('custom.nvim-ufo').h()
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
