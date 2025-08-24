return {
  {
    'mistweaverco/kulala.nvim',
    keys = {
      { '<localleader>rs', desc = 'Send request' },
      { '<localleader>ra', desc = 'Send all requests' },
      { '<localleader>rb', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = '<localleader>r',
      kulala_keymaps_prefix = '',
    },
  },
}
