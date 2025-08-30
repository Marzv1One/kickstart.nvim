vim.cmd 'let g:sqlite_clib_path = "D:/sqlite-dll-win-x64-3470200/sqlite3.dll"'

return {
  {
    'gbprod/yanky.nvim',
    dependencies = {
      { 'kkharji/sqlite.lua' },
    },
    opts = {
      ring = { storage = 'sqlite' },
      highlight = {
        on_put = false,
        on_yank = false,
      },
    },
    keys = {
      -- { '<leader>p', '<cmd>YankyRingHistory<cr>', mode = { 'n', 'x' }, desc = 'Open Yank History' },
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
      { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
      { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
      { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
      { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
      { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
      { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
      { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
      { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
      { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
    },
  },
  {
    'gbprod/substitute.nvim',
    dependencies = {
      'gbprod/yanky.nvim',
      -- 'rachartier/tiny-glimmer.nvim',
    },
    config = function()
      require('substitute').setup {
        yank_substituted_text = false,
        on_substitute = function(args)
          require('yanky.integration').substitute()
          require('tiny-glimmer.support.substitute').substitute_cb(args)
        end,
        preserve_cursor_position = true,
        highlight_substituted_text = {
          enabled = false,
        },
        range = {
          prompt_current_text = true,
          group_substituted_text = true,
        },
      }

      local map = vim.keymap.set

      map('n', 's', require('substitute').operator, { noremap = true, desc = 'Substitute' })
      map('n', 'ss', require('substitute').line, { noremap = true, desc = 'Substitute Line' })
      map('n', 'S', require('substitute').eol, { noremap = true, desc = 'Substitute EOL' })
      map('x', 's', require('substitute').visual, { noremap = true, desc = 'Substitute Visual' })

      map('n', 'sx', require('substitute.exchange').operator, { noremap = true, desc = 'Substitute Exchange' })
      map('n', 'sX', require('substitute.exchange').line, { noremap = true, desc = 'Substitute Exchange Line' })
      map('x', 'sx', require('substitute.exchange').visual, { noremap = true, desc = 'Substitute Exchange Visual' })
      map('n', 'sxc', require('substitute.exchange').cancel, { noremap = true, desc = 'Substitute Exchange Cancel' })
    end,
  },
  {
    'gbprod/cutlass.nvim',
    keys = {
      { 'c', mode = { 'n', 'x' } },
      { 'C', mode = { 'n', 'x' } },
      { 'd', mode = { 'n', 'x' } },
      { 'D', mode = { 'n', 'x' } },
      { 'x', mode = { 'n', 'x' } },
      { 'X', mode = { 'n', 'x' } },
    },
    opts = {
      cut_key = 'x',
      registers = {
        select = 's',
        delete = 'd',
        change = 'c',
      },
    },
  },
}
