return {
  {
    'ecthelionvi/NeoComposer.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = {
      keymaps = {
        toggle_record = 'q',
        cycle_next = '<M-y>',
        cycle_prev = '<M-x>',
      },
    },
  },
}
