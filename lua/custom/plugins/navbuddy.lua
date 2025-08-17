return {
  {
    'SmiteshP/nvim-navbuddy',
    event = 'LspAttach',
    dependencies = {
      {
        'SmiteshP/nvim-navic',
        opts = {
          lsp = {
            auto_attach = true,
          },
        },
      },
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        auto_attach = true,
      },
      window = {
        size = {
          height = '69%',
          width = '81%',
        },
        sections = {
          left = { size = '22%' },
          mid = { size = '30%' },
        },
      },
    },
    config = function(_, opts)
      local navbuddy = require 'nvim-navbuddy'
      -- local actions = require 'nvim-navbuddy.actions'
      local new_rename = function(expand)
        expand = expand or false
        local callback = function(display)
          display:close()
          -- vim.lsp.buf.rename()
          if expand then
            vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand '<cword>', 'n', true)
          else
            vim.api.nvim_feedkeys(':IncRename ', 'n', true)
          end
        end

        return {
          callback = callback,
          description = 'Rename',
        }
      end
      navbuddy.setup {
        lsp = opts.lsp,
        window = opts.window,
        mappings = {
          -- ['o'] = new_select(),
          -- ['enter'] = new_select(),
          ['r'] = new_rename(),
          ['R'] = new_rename(true),
          -- ['f'] = require('custom.fzf-lua.nvim-navbuddy').open(),
        },
      }

      vim.keymap.set('n', '<leader>nb', navbuddy.open, { desc = 'Navbuddy' })
    end,
  },
}
