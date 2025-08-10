-- local conditions = require 'heirline.conditions'
-- local utils = require 'heirline.utils'
--
-- local function setup_colors()
--   return {
--     bright_bg = utils.get_highlight('Folded').bg,
--     bright_fg = utils.get_highlight('Folded').fg,
--     red = utils.get_highlight('DiagnosticError').fg,
--     dark_red = utils.get_highlight('DiffDelete').bg,
--     green = utils.get_highlight('String').fg,
--     blue = utils.get_highlight('Function').fg,
--     gray = utils.get_highlight('NonText').fg,
--     orange = utils.get_highlight('Constant').fg,
--     purple = utils.get_highlight('Statement').fg,
--     cyan = utils.get_highlight('Special').fg,
--     diag_warn = utils.get_highlight('DiagnosticWarn').fg,
--     diag_error = utils.get_highlight('DiagnosticError').fg,
--     diag_hint = utils.get_highlight('DiagnosticHint').fg,
--     diag_info = utils.get_highlight('DiagnosticInfo').fg,
--     git_del = utils.get_highlight('diffDeleted').fg,
--     git_add = utils.get_highlight('diffAdded').fg,
--     git_change = utils.get_highlight('diffChanged').fg,
--   }
-- end
--
-- vim.o.laststatus = 3
-- vim.o.showcmdloc = 'statusline'
-- -- vim.o.showtabline = 2
--
-- require('heirline').setup {
--   statusline = require('custom.heirline.statusline').statusline,
--   winbar = require('custom.heirline.statusline').winbar,
--   tabline = require 'custom.heirline.tabline',
--   statuscolumn = require 'custom.heirline.statuscolumn',
--   opts = {
--     disable_winbar_cb = function(args)
--       if vim.bo[args.buf].filetype == 'neo-tree' then
--         return
--       end
--       return conditions.buffer_matches({
--         buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
--         filetype = { '^git.*', 'fugitive', 'Trouble', 'dashboard' },
--       }, args.buf)
--     end,
--     colors = setup_colors,
--   },
-- }
--
-- vim.o.statuscolumn = require('heirline').eval_statuscolumn()
--
-- vim.api.nvim_create_augroup('Heirline', { clear = true })
--
-- vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]
--
-- -- vim.cmd("au BufWinEnter * if &bt != '' | setl stc= | endif")
--
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = function()
--     utils.on_colorscheme(setup_colors)
--   end,
--   group = 'Heirline',
-- })
local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

local icons = require('custom.heirline.common').icons

local function load_colors()
  local colors = {
    bright_bg = utils.get_highlight('Folded').bg,
    bright_fg = utils.get_highlight('Folded').fg or '#ffffff',
    red = utils.get_highlight('DiagnosticError').fg,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = utils.get_highlight('String').fg,
    blue = utils.get_highlight('Function').fg,
    gray = utils.get_highlight('NonText').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('Statement').fg,
    cyan = utils.get_highlight('Special').fg,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
    git_del = utils.get_highlight('diffRemoved').fg,
    -- git_del = utils.get_highlight('diffDeleted').fg,
    git_add = utils.get_highlight('diffAdded').fg,
    git_change = utils.get_highlight('diffChanged').fg,
  }
  return colors
end
require('heirline').load_colors(load_colors())

local Align = { provider = '%=' }
local Space = { provider = ' ' }

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'red',
    },
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return ' %2(' .. self.mode_names[self.mode] .. '%)'
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      vim.cmd 'redrawstatus'
    end),
  },
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end

    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end

    return filename
  end,
  hl = { fg = utils.get_highlight('Directory').fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = '  ',
    hl = { fg = 'green' },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    -- TODO: add nerdfont icon
    provider = ' 󱙱',
  },
}

local FileNameModifier = {
  hl = function()
    if vim.bo.modified then
      return { fg = 'cyan', bold = true, force = true }
    end
  end,
}

FileNameBlock = utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifier, FileName), FileFlags, { provider = '%<' })

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight('Type').fg, bold = true },
}

local FileEncoding = {
  provider = function()
    local enc = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
    return enc ~= 'utf-8' and enc:upper()
  end,
  hl = { fg = utils.get_highlight('Special').fg },
}

local FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end,
  hl = { fg = utils.get_highlight('Special').fg },
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through buffer
  -- provider = '%l:%c %P',
  provider = '%7(%l/%3L%):%2c %P',
  hl = { fg = utils.get_highlight('Special').fg },
}

local ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(curr_line / lines * #self.sbar) + 1
    return self.sbar[i]
  end,
  hl = { fg = utils.get_highlight('Special').fg },
}

local LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_clients()) do
      table.insert(names, server.name)
    end
    return ' ' .. table.concat(names, ', ')
  end,
  hl = { fg = utils.get_highlight('Special').fg },
}

local Navic = {
  condition = function()
    return require('nvim-navic').is_available()
  end,
  static = {
    -- create a type highlight map
    type_hl = {
      File = 'Directory',
      Module = '@include',
      Namespace = '@namespace',
      Package = '@include',
      Class = '@structure',
      Method = '@method',
      Property = '@property',
      Field = '@field',
      Constructor = '@constructor',
      Enum = '@field',
      Interface = '@type',
      Function = '@function',
      Variable = '@variable',
      Constant = '@constant',
      String = '@string',
      Number = '@number',
      Boolean = '@boolean',
      Array = '@field',
      Object = '@type',
      Key = '@keyword',
      Null = '@comment',
      EnumMember = '@field',
      Struct = '@structure',
      Event = '@keyword',
      Operator = '@operator',
      TypeParameter = '@type',
    },
    -- bit operation dark magic, see below...
    enc = function(line, col, winnr)
      return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
    -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
    dec = function(c)
      local line = bit.rshift(c, 16)
      local col = bit.band(bit.rshift(c, 6), 1023)
      local winnr = bit.band(c, 63)
      return line, col, winnr
    end,
  },
  init = function(self)
    local data = require('nvim-navic').get_data() or {}
    local children = {}
    -- create a child for each level
    for i, d in ipairs(data) do
      -- encode line and column numbers into a single integer
      local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
      local child = {
        {
          provider = d.icon,
          hl = self.type_hl[d.type],
        },
        {
          -- escape `%`s (elixir) and buggy default separators
          provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
          -- highlight icon only or location name as well
          -- hl = self.type_hl[d.type],

          on_click = {
            -- pass the encoded position through minwid
            minwid = pos,
            callback = function(_, minwid)
              -- decode
              local line, col, winnr = self.dec(minwid)
              vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
            end,
            name = 'heirline_navic',
          },
        },
      }
      -- add a separator only if needed
      if #data > 1 and i < #data then
        table.insert(child, {
          provider = ' > ',
          hl = { fg = 'bright_fg' },
        })
      end
      table.insert(children, child)
    end
    -- instantiate the new child, overwriting the previous one
    self.child = self:new(children, 1)
  end,
  -- evaluate the children containing navic components
  provider = function(self)
    return self.child:eval()
  end,
  hl = { fg = 'gray' },
  update = 'CursorMoved',
}

local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { 'DiagnosticChanged', 'BufEnter' },
  on_click = {
    callback = function()
      -- require('trouble').toggle { mode = 'document_diagnostics' }
    end,
    name = 'heirline_diagnostics',
  },
  init = function(self)
    self.diagnostics = vim.diagnostic.count()
  end,
  { provider = '![' },
  {
    provider = function(self)
      return self.diagnostics[1] and (icons.err .. self.diagnostics[1] .. ' ')
    end,
    hl = 'DiagnosticError',
  },
  {
    provider = function(self)
      return self.diagnostics[2] and (icons.warn .. self.diagnostics[2] .. ' ')
    end,
    hl = 'DiagnosticWarn',
  },
  {
    provider = function(self)
      return self.diagnostics[3] and (icons.info .. self.diagnostics[3] .. ' ')
    end,
    hl = 'DiagnosticInfo',
  },
  {
    provider = function(self)
      return self.diagnostics[4] and (icons.hint .. self.diagnostics[4] .. ' ')
    end,
    hl = 'DiagnosticHint',
  },
  { provider = ']' },
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  on_click = {
    callback = function(self, minwid, nclicks, button)
      vim.defer_fn(function()
        vim.cmd 'Lazygit %:p:h'
      end, 100)
    end,
    name = 'heirline_git',
    update = false,
  },
  hl = { fg = 'orange' },
  {
    provider = function(self)
      return ' ' .. self.status_dict.head
    end,
    hl = { bold = true },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = '(',
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ('+' .. count)
    end,
    hl = 'diffAdded',
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ('-' .. count)
    end,
    hl = 'diffRemoved',
    -- hl = 'diffDeleted',
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ('~' .. count)
    end,
    hl = 'diffChanged',
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
}

local WorkDir = {
  init = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and 'l' or 'g') .. ' ' .. icons.dir
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ':~')
    if not conditions.width_percent_below(#self.cwd, 0.27) then
      self.cwd = vim.fn.pathshorten(self.cwd)
    end
  end,
  hl = { fg = 'blue', bold = true },
  on_click = {
    callback = function()
      vim.cmd 'Neotree toggle'
    end,
    name = 'heirline_workdir',
  },
  flexible = 1,
  {
    provider = function(self)
      -- local trail = self.cwd:sub(-1) == '/' and '' or '/'
      local trail = self.cwd:sub(-1) == '\\' and '' or '\\'
      return self.icon .. self.cwd .. trail .. ' '
    end,
  },
  {
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      -- local trail = self.cwd:sub(-1) == '/' and '' or '/'
      local trail = self.cwd:sub(-1) == '\\' and '' or '\\'
      return self.icon .. cwd .. trail .. ' '
    end,
  },
  {
    provider = '',
  },
}

local Snippets = {
  condition = function()
    return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
  end,
  provider = function()
    local ls = require 'luasnip'
    -- local forward = (vim.fn['UltiSnips#CanJumpForwards']() == 1) and ' ' or ''
    local right_arrow = ' 󰍟'
    -- local right_arrow = ' ~>'
    local left_arrow = '󰍞'
    -- local left_arrow = '<~'
    local forward = ls.expand_or_jumpable() and right_arrow or ''
    -- local forward = ls.expandable() or ls.jumpable(1) and right_arrow or ''
    -- local backward = (vim.fn['UltiSnips#CanJumpBackwards']() == 1) and ' ' or ''
    local backward = ls.jumpable(-1) and left_arrow or ''
    return backward .. forward
  end,
  hl = { fg = 'red', bold = true },
}

local CodeiumStatus = {
  condition = function()
    return not conditions.buffer_matches {
      filetype = { 'dashboard' },
    }
  end,
  hl = { fg = 'cyan' },
  provider = function()
    return '󱚦 ' .. vim.fn['codeium#GetStatusString']()
  end,
}

-- local Navic = {
--   condition = function()
--     return require('nvim-navic').is_available()
--   end,
--   provider = function()
--     return require('nvim-navic').get_location { highlight = true, separator = ' > ' }
--   end,
-- }
-- local Navic = {
--   condition = function()
--     return require('nvim-navic').is_available()
--   end,
--   static = {
--     type_hl = {
--       File = dim(utils.get_highlight('Directory').fg, 0.75),
--       Module = dim(utils.get_highlight('@module').fg, 0.75),
--       Namespace = dim(utils.get_highlight('@module').fg, 0.75),
--       Package = dim(utils.get_highlight('@module').fg, 0.75),
--       Class = dim(utils.get_highlight('@type').fg, 0.75),
--       Method = dim(utils.get_highlight('@function.method').fg, 0.75),
--       Property = dim(utils.get_highlight('@property').fg, 0.75),
--       Field = dim(utils.get_highlight('@variable.member').fg, 0.75),
--       Constructor = dim(utils.get_highlight('@constructor').fg, 0.75),
--       Enum = dim(utils.get_highlight('@type').fg, 0.75),
--       Interface = dim(utils.get_highlight('@type').fg, 0.75),
--       Function = dim(utils.get_highlight('@function').fg, 0.75),
--       Variable = dim(utils.get_highlight('@variable').fg, 0.75),
--       Constant = dim(utils.get_highlight('@constant').fg, 0.75),
--       String = dim(utils.get_highlight('@string').fg, 0.75),
--       Number = dim(utils.get_highlight('@number').fg, 0.75),
--       Boolean = dim(utils.get_highlight('@boolean').fg, 0.75),
--       Array = dim(utils.get_highlight('@variable.member').fg, 0.75),
--       Object = dim(utils.get_highlight('@type').fg, 0.75),
--       Key = dim(utils.get_highlight('@keyword').fg, 0.75),
--       Null = dim(utils.get_highlight('@comment').fg, 0.75),
--       EnumMember = dim(utils.get_highlight('@constant').fg, 0.75),
--       Struct = dim(utils.get_highlight('@type').fg, 0.75),
--       Event = dim(utils.get_highlight('@type').fg, 0.75),
--       Operator = dim(utils.get_highlight('@operator').fg, 0.75),
--       TypeParameter = dim(utils.get_highlight('@type').fg, 0.75),
--     },
--     -- line: 16 bit (65536); col: 10 bit (1024); winnr: 6 bit (64)
--     -- local encdec = function(a,b,c) return dec(enc(a,b,c)) end; vim.pretty_print(encdec(2^16 - 1, 2^10 - 1, 2^6 - 1))
--     enc = function(line, col, winnr)
--       return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
--     end,
--     dec = function(c)
--       local line = bit.rshift(c, 16)
--       local col = bit.band(bit.rshift(c, 6), 1023)
--       local winnr = bit.band(c, 63)
--       return line, col, winnr
--     end,
--   },
--   init = function(self)
--     local data = require('nvim-navic').get_data() or {}
--     local children = {}
--     for i, d in ipairs(data) do
--       local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
--       local child = {
--         {
--           provider = d.icon,
--           hl = { fg = self.type_hl[d.type] },
--         },
--         {
--           provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
--           hl = { fg = self.type_hl[d.type] },
--           -- hl = self.type_hl[d.type],
--           on_click = {
--             callback = function(_, minwid)
--               local line, col, winnr = self.dec(minwid)
--               vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
--             end,
--             minwid = pos,
--             name = 'heirline_navic',
--           },
--         },
--       }
--       if i < #data then
--         table.insert(child, {
--           provider = ' → ',
--           hl = { fg = 'bright_fg' },
--         })
--       end
--       table.insert(children, child)
--     end
--     self[1] = self:new(children, 1)
--   end,
--   update = 'CursorMoved',
--   hl = { fg = 'gray' },
-- }

local TerminalName = {
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
    return ' ' .. tname
  end,
  hl = { fg = utils.get_highlight('Special').fg },
}

local WinBars = {
  fallthrough = false,
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches { buftype = { 'terminal' } }
    end,
    utils.surround({ '', '' }, 'dark_red', {
      FileType,
      Space,
      TerminalName,
    }),
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({ '', '' }, 'bright_bg', { hl = { fg = 'gray', force = true }, FileNameBlock }),
  },
  -- A winbar for regular files
  utils.surround({ '', '' }, 'bright_bg', {
    Navic,
    { provider = '%<' },
    Align,
    FileNameBlock,
  }),
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
  end,
  provider = ' ',
  hl = { fg = 'orange', bold = true },
  utils.surround({ '[', ']' }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = { fg = 'green', bold = true },
  }),
  update = {
    'RecordingEnter',
    'RecordingLeave',
  },
}

local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    if search then
      return string.format(' %d/%d', search.current, math.min(search.total, search.maxcount))
    else
      return ''
    end
  end,
  hl = { fg = 'purple', bold = true },
}

vim.opt.showcmdloc = 'statusline'
local ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ':%3.5(%S%)',
}

ViMode = utils.surround({ '', '' }, 'bright_bg', {
  ViMode,
  Snippets,
  ShowCmd,
  MacroRec,
})

local DefaultStatusline = {
  ViMode,
  Space,
  FileNameBlock,
  { provider = '%<' },
  Space,
  Git,
  Space,
  Diagnostics,
  Space,
  CodeiumStatus,
  Align,
  LSPActive,
  Space,
  FileType,
  Space,
  FileEncoding,
  Space,
  FileFormat,
  Space,
  Ruler,
  SearchCount,
  Space,
  ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  FileType,
  Space,
  FileName,
  Align,
}

local TerminalStatusline = {

  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,

  hl = { bg = 'dark_red' },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, ViMode, Space },
  FileType,
  Space,
  TerminalName,
  Align,
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == 'help'
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ':t')
  end,
  hl = 'Directory',
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive' },
    }
  end,

  FileType,
  Space,
  HelpFileName,
  Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return 'StatusLine'
    else
      return 'StatusLineNC'
    end
  end,
  static = {
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan', -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple', -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'green',
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or 'n'
      return self.mode_colors[mode]
    end,
  },
  fallthrough = false,
  -- GitStatusline,
  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

require('heirline').setup {
  statusline = StatusLines,
  winbar = WinBars,
  opts = {
    colors = load_colors(),
  },
}

-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = function()
--     utils.on_colorscheme(load_colors)
--   end,
--   group = 'Heirline',
-- })
