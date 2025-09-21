return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = false,
    lazy = false,
    init = function()
      vim.cmd 'colorscheme rose-pine'
      vim.cmd 'highlight MatchParen guibg=NONE ctermbg=NONE gui=underline cterm=underline'
      vim.cmd 'highlight Search guibg=#f6c177 guifg=#21202e'
    end,
    config = function()
      local palette = require 'rose-pine.palette'
      require('rose-pine').setup {
        highlight_groups = {
          MatchParen = { fg = palette.love, bold = true, bg = 'none' },
          NoiceCmdlinePopupBorderCmdline = { fg = palette.love },
          NoiceCmdlineIconCmdline = { link = 'NoiceCmdlinePopupBorderCmdline' },
          NoiceCmdlinePopupBorderLua = { fg = palette.foam },
          NoiceCmdlineIconLua = { link = 'NoiceCmdlinePopupBorderLua' },
          NoiceCmdlinePopupBorderHelp = { fg = palette.pine },
          NoiceCmdlineIconHelp = { link = 'NoiceCmdlinePopupBorderHelp' },
          DashboardHeader = { fg = palette.love },
          Number = { fg = palette.rose },
          CursorLineNr = { link = 'Number' },
          -- Search = { fg = palette.highlight_low, bg = palette.gold },
        },
      }
      -- vim.api.nvim_set_hl(0, 'MatchParen', { bg = 'none', fg = '#ea9a97' })
    end,
  },
}
