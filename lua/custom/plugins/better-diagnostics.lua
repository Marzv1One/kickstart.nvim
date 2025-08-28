return {
  'sontungexpt/better-diagnostic-virtual-text',
    enabled = false,
  -- event = 'LspAttach',
  event = 'VeryLazy',
  opts = {
    ui = {
      arrow = ' 󱡓',
    },
  },
  config = function(_, opts)
    require('better-diagnostic-virtual-text').setup(opts)
  end,
}
