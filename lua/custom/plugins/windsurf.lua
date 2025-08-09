return {
  {
    'Exafunction/windsurf.vim',
    version = '1.12.8',
    -- version = '1.12.0',
    -- version = '1.10.0',
    event = 'BufEnter',
    config = function()
      vim.g.codeium_disable_bindings = 1

      vim.keymap.set('i', '<C-g>', function()
        return vim.fn['codeium#Accept']()
      end, { desc = 'Codeium Accept', expr = true, silent = true })

      vim.keymap.set('i', '<C-k>', function()
        return vim.fn['codeium#AcceptNextWord']()
      end, { desc = 'Codeium Accept Next Word', expr = true, silent = true })

      vim.keymap.set('i', '<C-x>', function()
        return vim.fn['codeium#AcceptNextLine']()
      end, { desc = 'Codeium Accept Next Line', expr = true, silent = true })

      vim.keymap.set('i', '<M-r>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { desc = 'Codeium Cycle Completions', expr = true, silent = true })

      vim.keymap.set('i', '<M-c>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { desc = 'Codeium Cycle Completions', expr = true, silent = true })

      vim.keymap.set('i', '<C-c>', function()
        return vim.fn['codeium#Clear']()
      end, { desc = 'Codeium Clear', expr = true, silent = true })

      vim.keymap.set('i', '<C-a>', function()
        return vim.fn['codeium#Complete']()
      end, { desc = 'Codeium Complete', expr = true, silent = true })

      vim.keymap.set('n', '<leader>cc', function()
        return vim.fn['codeium#Chat']()
      end, { desc = 'Codeium Chat', expr = true, silent = true })
    end,
  },
}
