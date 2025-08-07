return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  enabled = true,
  init = function()
    vim.cmd 'colorscheme kanagawa-wave'
  end,
  config = function()
    require('kanagawa').setup {
      compile = true,
      colors = {
        theme = {
          dragon = {
            ui = {
              -- fg = '#DCD7BA',
            },
            syn = {
              special3 = '#FF5D62',
              regex = '#C0A36E',
            },
          },
        },
      },
      -- transparent = vim.g.transparent_enabled,
      overrides = function(colors)
        local c = require 'kanagawa.lib.color'
        local theme = colors.theme
        local palette = colors.palette
        return {
          -- Normal = { bg = 'none' },
          Pmenu = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'none', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          NormalFloat = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          FloatBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          FloatTitle = { fg = theme.ui.special, bold = true },
          FloatFooter = { fg = theme.ui.fg_dim, bg = theme.ui.bg },

          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = {
            fg = theme.ui.fg_dim,
            bg = theme.ui.bg_m1,
          },
          TelescopeResultsBorder = {
            fg = theme.ui.bg_m1,
            bg = theme.ui.bg_m1,
          },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = {
            bg = theme.ui.bg_dim,
            fg = theme.ui.bg_dim,
          },

          FzfLuaNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          FzfLuaBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          FzfLuaTitle = {
            fg = theme.ui.special,
            bg = theme.ui.bg_m1,
            bold = true,
          },
          FzfLuaPreviewNormal = { bg = theme.ui.bg_dim },
          FzfLuaPreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          FzfLuaPreviewTitle = { fg = theme.ui.special, bold = true },

          DiagnosticVirtualTextError = {
            fg = theme.diag.error,
            bg = c(theme.diag.error):blend(theme.ui.bg, 0.95):to_hex(),
          },
          DiagnosticVirtualTextWarn = {
            fg = theme.diag.warning,
            bg = c(theme.diag.warning):blend(theme.ui.bg, 0.95):to_hex(),
          },
          DiagnosticVirtualTextHint = {
            fg = theme.diag.hint,
            bg = c(theme.diag.hint):blend(theme.ui.bg, 0.95):to_hex(),
          },
          DiagnosticVirtualTextInfo = {
            fg = theme.diag.info,
            bg = c(theme.diag.info):blend(theme.ui.bg, 0.95):to_hex(),
          },
          DiagnosticVirtualTextOk = {
            fg = theme.diag.ok,
            bg = c(theme.diag.ok):blend(theme.ui.bg, 0.95):to_hex(),
          },

          NoiceCmdlinePopup = { fg = theme.ui.fg_dim },
          NoiceCmdlinePopupTitle = { link = 'NoiceCmdlinePopup' },
          NoiceCmdlinePopupBorder = { link = 'NoiceCmdlinePopup' },
          NoiceCmdlineIcon = { link = 'NoiceCmdlinePopup' },
          NoiceCmdlinePopupBorderCmdline = { fg = theme.syn.special2 },
          NoiceCmdlineIconCmdline = {
            link = 'NoiceCmdlinePopupBorderCmdline',
          },
          NoiceCmdlinePopupBorderSearch = { fg = theme.diag.warning },
          NoiceCmdlineIconSearch = { link = 'NoiceCmdlinePopupBorderSearch' },
          NoiceCmdlinePopupBorderLua = { fg = theme.syn.fun },
          NoiceCmdlineIconLua = { link = 'NoiceCmdlinePopupBorderLua' },
          NoiceCmdlinePopupBorderFilter = { fg = theme.syn.special3 },
          NoiceCmdlineIconFilter = { link = 'NoiceCmdlinePopupBorderFilter' },
          NoiceCmdlinePopupBorderHelp = { fg = theme.diag.hint },
          NoiceCmdlineIconHelp = { link = 'NoiceCmdlinePopupBorderHelp' },
          NoiceMini = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TroubleNormal = { link = 'NormalDark' },
          TroubleNormalNC = { link = 'TroubleNormal' },
          LazyNormal = { bg = theme.ui.bg_m1 },
          LazyButton = { bg = theme.ui.bg_m1 },

          Substitute = { fg = theme.term[1], bg = theme.term[17] },
          Search = { link = 'Substitute' },
          CurSearch = { link = 'IncSearch' },

          MiniJump = { link = 'Search' },
          MiniSurround = { fg = palette.sumiInk3, bg = palette.surimiOrange },
          EyelinerPrimary = {
            fg = theme.syn.special2,
            bold = true,
            underline = true,
          },
          EyelinerSecondary = {
            fg = theme.term[6],
            bold = true,
            underline = true,
          },
          EyelinerDimmed = { link = 'Twilight' },
          MatchParen = { fg = theme.syn.special2, bold = true },
          -- MatchParen = { fg = theme.diag.warning, bold = true },
          CursorLineNr = { fg = theme.syn.number, bold = true },

          LspReferenceWrite = {
            bg = c(theme.ui.special):blend(theme.ui.bg, 0.95):to_hex(),
            underline = true,
          },
          LspReferenceText = {
            bg = c(theme.ui.special):blend(theme.ui.bg, 0.95):to_hex(),
          },
          LspReferenceRead = {
            bg = c(theme.ui.special):blend(theme.ui.bg, 0.95):to_hex(),
          },
          LspInlayHint = {
            bg = 'none',
            fg = c(theme.ui.special):blend(theme.ui.bg, 0.35):to_hex(),
          },
          Boolean = { fg = theme.term[14], bold = true },

          SmoothCursor = { fg = theme.syn.special3 },
          SmoothCursorYellow = { fg = theme.term[4] },
          SmoothCursorPurple = { fg = theme.term[6] },
          SmoothCursorOrange = { fg = theme.syn.constant },
          SmoothCursorGreen = { fg = theme.term[3] },
          SmoothCursorBlue = { fg = theme.term[5] },
          SmoothCursorAqua = { fg = theme.term[7] },
          SmoothCursorRed = { fg = theme.term[2] },

          Folded = { bg = 'none' },
          FoldColumn = {
            bg = 'none',
            fg = theme.ui.special,
            bold = true,
          },

          -- ColorColumn = { bg = theme.ui.bg_m1 },
          ColorColumn = {
            bg = c(theme.ui.bg_m1):blend(theme.ui.bg_p1, 0.35):to_hex(),
          },

          ['@tag.delimiter.tsx'] = {
            link = '@tag.builtin.tsx',
          },
          ['@tag.tsx'] = {
            fg = theme.syn.special2,
            bold = true,
          },
          ['@foo.tsx'] = {
            link = '@tag.tsx',
          },
          ['@baz.tsx'] = {
            link = '@tag.tsx',
          },
          ['@bar.tsx'] = {
            link = '@tag.tsx',
          },

          ['@type'] = { fg = theme.syn.type, bold = true },
          ['@keyword.coroutine'] = { fg = theme.syn.type, bold = true },
          ['@constant.builtin'] = { fg = theme.syn.special3, bold = true },
          ['@lsp.type.interface'] = { fg = theme.syn.punct, bold = true },
          ['@lsp.type.property.typescript'] = { fg = theme.syn.constant },
          -- ['@lsp.mod.declaration.typescript'] = { fg = theme.syn.constant },
          ['@lsp.typemod.property.readonly'] = { fg = theme.syn.keyword },
          ['@lsp.typemod.property.declaration.typescript'] = {
            fg = theme.syn.identifier,
          },
          ['@lsp.typemod.member.readonly'] = {
            link = '@lsp.typemod.property.readonly',
          },
          ['@lsp.typemod.variable.defaultLibrary'] = {
            fg = theme.syn.special2,
            bold = true,
          },
          ['@lsp.typemod.function.defaultLibrary'] = {
            link = '@function.builtin',
          },
          -- ['@lsp.typemod.class.defaultLibrary'] = {
          --   fg = theme.syn.identifier,
          --   bold = true,
          -- },
          ['@lsp.typemod.interface.defaultLibrary'] = {
            fg = theme.term[14],
            bold = true,
          },
        }
      end,
    }

    vim.api.nvim_create_autocmd('ModeChanged', {
      callback = function()
        local colors = require('kanagawa.colors').setup {}
        if not colors then
          return
        end
        -- local colors = require('tokyonight.colors').setup {}
        local theme = colors.theme
        local mode_names = {
          n = 'N',
          c = 'C',
          v = 'V',
          i = 'I',
          V = 'V_',
          R = 'R',
          -- Vs = 'Vs',
          ['\22'] = '^V',
          ['\22s'] = '^V',
        }
        local current_mode = vim.fn.mode()
        local current_mode_name = mode_names[current_mode]
        local set_hl = vim.api.nvim_set_hl
        if current_mode_name == 'N' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special3 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        elseif current_mode_name == 'C' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special3 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        elseif current_mode_name == 'V' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special1 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        elseif current_mode_name == 'V_' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special1 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        elseif current_mode_name == '^V' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special1 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        elseif current_mode_name == 'R' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.string })
          vim.fn.sign_define('smoothcursor', { text = '󰸷' })
        elseif current_mode_name == 'I' then
          set_hl(0, 'SmoothCursor', { fg = theme.syn.special3 })
          vim.fn.sign_define('smoothcursor', { text = '' })
        end
      end,
    })
    -- vim.cmd 'set pumblend=25'
    -- vim.cmd 'set winblend=25'
  end,
}
