return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      winopts = {
        preview = {
          default = 'bat',
        },
      },
      keymap = {
        builtin = {
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',
        },
      },
      lsp = {
        code_actions = {
          previewer = 'codeaction_native',
        },
      },
    },
    config = function(_, opts)
      local fzf = require 'fzf-lua'
      fzf.setup(opts)

      fzf.register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)

      local map = vim.keymap.set

      map('n', '<leader>fh', require('fzf-lua').helptags, { desc = 'Help Tags' })
      map('n', '<leader>fk', require('fzf-lua').keymaps, { desc = 'Keymaps' })
      map('n', '<leader>ff', require('fzf-lua').files, { desc = 'Files' })
      map('n', '<leader>fs', require('fzf-lua').builtin, { desc = 'Builtin' })
      map('n', '<leader>fw', require('fzf-lua').grep_cword, { desc = 'Grep Word' })
      map('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fd', require('fzf-lua').diagnostics_document, { desc = 'Diagnostics' })
      map('n', '<leader>fr', require('fzf-lua').resume, { desc = 'Resume' })
      map('n', '<leader>f.', require('fzf-lua').oldfiles, { desc = 'Old Files' })
      map('n', '<leader><leader>', require('fzf-lua').buffers, { desc = 'Buffers' })
      map('n', '<leader>/', require('fzf-lua').lines, { desc = 'Lines' })
      map('n', '<leader>fn', function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'NeoVim Files' })
    end,
  },
}
