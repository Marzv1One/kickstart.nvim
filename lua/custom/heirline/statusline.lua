local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

local icons = require('custom.heirline.common').icons
local separators = require('custom.heirline.common').separators
local dim = require('custom.heirline.common').dim

local kirby_default = '(>*-*)>'

local axolotl_default = '꒰(˶• ᴗ •˶)꒱'
local axolotl_frown = '꒰(˶• ˕ •˶)꒱' -- gentle frown, concerned
local axolotl_curious = '꒰(˶˃ ᴗ ˂˶)꒱' -- wide-eyed, peering left
local axolotl_sleepy = '꒰(˶• o •˶)꒱' -- half-closed eyes, floating
local axolotl_happy = '꒰(˶• 3 •˶)꒱' -- happy, mouth like a tiny heart

local axolotl_surprised = '꒰(˶• ᗜ •˶)꒱' -- open-mouthed surprise
-- local axolotl_gills = '︵‿︵' -- gill tufts (use in custom expressions)
-- local axolotl_gill_frame = '꒰( ︵‿︵ • ᴗ • ︵‿︵ )꒱' -- full gill burst
local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    -- Your new mode table
    mode_axolotl = {
      n = axolotl_default,
      no = axolotl_frown,
      nov = axolotl_default,
      noV = axolotl_default,
      ['no\22'] = axolotl_default,
      niI = axolotl_frown,
      niR = axolotl_frown,
      niV = axolotl_frown,
      nt = axolotl_frown,
      v = '꒰(˶• ᗜ •˶)꒱',
      vs = '꒰(˶• ᗜ •˶)꒱',
      V = '꒰(˶• ᗜ <˶)꒱',
      Vs = '꒰(˶• ᗜ <˶)꒱',
      ['\22'] = '꒰(˶> ᗜ <˶)꒱',
      ['\22s'] = '꒰(˶> ᗜ <˶)꒱',
      s = axolotl_happy,
      S = axolotl_happy,
      ['\19'] = axolotl_happy,
      i = axolotl_curious,
      ic = axolotl_frown,
      ix = axolotl_frown,
      R = axolotl_curious,
      Rc = axolotl_curious,
      Rx = axolotl_curious,
      Rv = axolotl_curious,
      Rvc = axolotl_curious,
      Rvx = axolotl_curious,
      c = axolotl_sleepy,
      cv = axolotl_sleepy,
      ce = axolotl_sleepy,
      r = axolotl_sleepy,
      rm = axolotl_default,
      ['r?'] = axolotl_curious,
      ['!'] = axolotl_sleepy,
      t = axolotl_sleepy,
    },

    mode_kirby = {
      n = '<(•ᴗ•)>',
      no = '<(•ᴗ•)>',
      nov = '<(•ᴗ•)>',
      noV = '<(•ᴗ•)>',
      ['no\22'] = '<(•ᴗ•)>',
      niI = kirby_default,
      niR = '<(•o•)>',
      niV = '<(•o•)>',
      nt = kirby_default,
      v = '(>•-•)>',
      vs = '(>•-•)>',
      V = '(v•-•)v',
      Vs = '(v•-•)v',
      ['\22'] = '(v•-•)>',
      ['\22s'] = '(v•-•)>',
      s = '(>•-•)>',
      S = '(>•-•)>',
      ['\19'] = '(>•-•)>',
      i = '<(•o•)>',
      ic = kirby_default,
      ix = kirby_default,
      R = '<(•o•)>',
      Rc = '<(•o•)>',
      Rx = '<(•o•)>',
      Rv = '<(•o•)>',
      Rvc = '<(•o•)>',
      Rvx = '<(•o•)>',
      c = kirby_default,
      cv = '<(•ᴗ•)>',
      ce = '<(•ᴗ•)>',
      r = kirby_default,
      rm = kirby_default,
      ['r?'] = kirby_default,
      ['!'] = '<(•ᴗ•)>',
      t = kirby_default,
    },
    mode_names = {
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
  },
  provider = function(self)
    return '%2(' .. ' ' .. self.mode_axolotl[self.mode] .. '%)'
    -- return '%2(' .. self.mode_kirby[self.mode] .. ' ' .. self.mode .. '%)'
    -- return icons.vim .. '%2(' .. self.mode_names[self.mode] .. '%)'
  end,
  hl = function(self)
    local color = self:mode_color()
    return { fg = 'bright_bg', bold = true }
  end,
  -- update = {
  --   'ModeChanged',
  --   'BufEnter',
  --   'CmdlineLeave',
  --   'WinEnter',
  --   -- pattern = '*:*',
  --   -- callback = vim.schedule_wrap(function()
  --   --   -- print(vim.fn.mode())
  --   --   vim.cmd 'redrawstatus'
  --   -- end),
  -- },
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
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
    if self.lfilename == '' then
      self.lfilename = '[No Name]'
    end
    if not conditions.width_percent_below(#self.lfilename, 0.27) then
      self.lfilename = vim.fn.pathshorten(self.lfilename)
    end
  end,
  hl = function()
    if vim.bo.modified then
      return { fg = utils.get_highlight('Directory').fg, bold = true, italic = true }
    end
    return 'Directory'
  end,
  flexible = 2,
  {
    provider = function(self)
      return self.lfilename
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.lfilename)
    end,
  },
}

local FileNameModifier = {
  hl = function()
    if vim.bo.modified then
      return { fg = 'cyan', bold = true, force = true }
    end
  end,
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = ' ' .. icons.modified,
    hl = { fg = 'green' },
    on_click = {
      callback = function(_, minwid)
        local buf = vim.api.nvim_win_get_buf(minwid)
        local bufname = vim.api.nvim_buf_get_name(buf)
        vim.cmd.write(bufname)
      end,
      minwid = function()
        return vim.api.nvim_get_current_win()
      end,
      name = 'heirline_write_buf',
    },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = icons.readonly,
    hl = { fg = 'orange' },
  },
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  FileIcon,
  FileName,
  unpack(FileFlags),
}

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = 'Type',
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end,
}

local FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end,
}

local FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize <= 0 then
      return '0' .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format('%.2g%s', fsize / math.pow(1024, i), suffix[i])
  end,
}

local FileLastModified = {
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date('%c', ftime)
  end,
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
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
  hl = { fg = utils.get_highlight('Special').fg, bg = 'bright_bg' },
}

local LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach', 'WinEnter' },
  provider = icons.lsp .. 'LSP',
  -- provider  = function(self)
  --     local names = {}
  --     for i, server in pairs(vim.lsp.buf_get_active_clients({ bufnr = 0 })) do
  --         table.insert(names, server.name)
  --     end
  --     return " [" .. table.concat(names, " ") .. "]"
  -- end,
  hl = { fg = 'green', bold = true },
  on_click = {
    name = 'heirline_LSP',
    callback = function()
      vim.schedule(function()
        vim.cmd 'LspInfo'
      end)
    end,
  },
}

local Navic = {
  condition = function()
    return require('nvim-navic').is_available()
  end,
  static = {
    type_hl = {
      File = dim(utils.get_highlight('Directory').fg, 0.75),
      Module = dim(utils.get_highlight('@module').fg, 0.75),
      Namespace = dim(utils.get_highlight('@module').fg, 0.75),
      Package = dim(utils.get_highlight('@module').fg, 0.75),
      Class = dim(utils.get_highlight('@type').fg, 0.75),
      Method = dim(utils.get_highlight('@function.method').fg, 0.75),
      Property = dim(utils.get_highlight('@property').fg, 0.75),
      Field = dim(utils.get_highlight('@variable.member').fg, 0.75),
      Constructor = dim(utils.get_highlight('@constructor').fg, 0.75),
      Enum = dim(utils.get_highlight('@type').fg, 0.75),
      Interface = dim(utils.get_highlight('@type').fg, 0.75),
      Function = dim(utils.get_highlight('@function').fg, 0.75),
      Variable = dim(utils.get_highlight('@variable').fg, 0.75),
      Constant = dim(utils.get_highlight('@constant').fg, 0.75),
      String = dim(utils.get_highlight('@string').fg, 0.75),
      Number = dim(utils.get_highlight('@number').fg, 0.75),
      Boolean = dim(utils.get_highlight('@boolean').fg, 0.75),
      Array = dim(utils.get_highlight('@variable.member').fg, 0.75),
      Object = dim(utils.get_highlight('@type').fg, 0.75),
      Key = dim(utils.get_highlight('@keyword').fg, 0.75),
      Null = dim(utils.get_highlight('@comment').fg, 0.75),
      EnumMember = dim(utils.get_highlight('@constant').fg, 0.75),
      Struct = dim(utils.get_highlight('@type').fg, 0.75),
      Event = dim(utils.get_highlight('@type').fg, 0.75),
      Operator = dim(utils.get_highlight('@operator').fg, 0.75),
      TypeParameter = dim(utils.get_highlight('@type').fg, 0.75),
    },
    -- line: 16 bit (65536); col: 10 bit (1024); winnr: 6 bit (64)
    -- local encdec = function(a,b,c) return dec(enc(a,b,c)) end; vim.pretty_print(encdec(2^16 - 1, 2^10 - 1, 2^6 - 1))
    enc = function(line, col, winnr)
      return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
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
    for i, d in ipairs(data) do
      local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
      local child = {
        {
          provider = d.icon,
          hl = { fg = self.type_hl[d.type] },
        },
        {
          provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
          hl = { fg = self.type_hl[d.type] },
          -- hl = self.type_hl[d.type],
          on_click = {
            callback = function(_, minwid)
              local line, col, winnr = self.dec(minwid)
              vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
            end,
            minwid = pos,
            name = 'heirline_navic',
          },
        },
      }
      if i < #data then
        table.insert(child, {
          provider = ' → ',
          hl = { fg = 'bright_fg' },
        })
      end
      table.insert(children, child)
    end
    self[1] = self:new(children, 1)
  end,
  update = 'CursorMoved',
  hl = { fg = 'gray' },
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
    hl = 'diffDeleted',
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

-- local Snippets = {
--   condition = function()
--     return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
--   end,
--   provider = function()
--     local forward = vim.snippet.active { direction = 1 } and ' ' or ''
--     local backward = vim.snippet.active { direction = -1 } and ' ' or ''
--     return backward .. forward
--   end,
--   hl = { fg = 'red', bold = true },
-- }
local function is_valid_node(node)
  local mark = node.mark
  if not mark then
    return false
  end

  local start_pos = mark:pos_begin() -- { line, col, endline, endcol }
  if not start_pos or not start_pos[1] then
    return false
  end

  -- Line and col should be >= 0
  return start_pos[1] >= 0 and start_pos[2] >= 0
end

local function get_snippet_progress()
  local ls = require 'luasnip'
  local bufnr = vim.api.nvim_get_current_buf()
  local current_node = ls.session.current_nodes[bufnr]
  if not current_node then
    return nil
  end

  local snip = current_node.parent and current_node.parent.snippet
  if not snip or not snip.insert_nodes then
    return nil
  end

  local nodes = {}
  for _, node in ipairs(snip.insert_nodes) do
    if is_valid_node(node) then
      table.insert(nodes, node)
    end
  end

  if #nodes == 0 then
    return nil
  end

  -- Find current node index
  local current_idx = nil
  for i, node in ipairs(nodes) do
    if node == current_node then
      current_idx = i
      break
    end
  end

  if not current_idx then
    return nil
  end

  return {
    current = current_idx,
    total = #nodes,
    percentage = current_idx / #nodes,
  }
end

local SnippetBar = {
  condition = function()
    return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
  end,

  provider = function()
    local prog = get_snippet_progress()
    if not prog then
      return ''
    end
    local filled = '●'
    -- local filled = '▰'
    local empty = '○'
    -- local empty = '▱'
    local w = prog.total
    local f = math.max(1, math.floor(prog.percentage * w))
    return ' ' .. string.rep(filled, f) .. string.rep(empty, w - f) .. ' '
  end,

  -- hl = { fg = 'red' },
  hl = { fg = 'purple' },
  -- update = 'LuasnipUpdate', -- 🔥 live updates!
}

local SnippetBarBlocks = {
  condition = function()
    return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
  end,

  provider = function()
    local prog = get_snippet_progress()
    -- print(vim.inspect(prog))
    if not prog or not prog.current then
      return ''
    end

    local full = '▰' -- U+25F0
    local empty = '▱' -- U+25F1
    local count = 10

    local filled = math.floor(prog.percentage * count)
    local empty_count = count - filled

    return ' ' .. string.rep(full, filled) .. string.rep(empty, empty_count) .. ' '
  end,

  hl = { fg = '#ff9900', bg = '#333333' },
}
-- local Snippets = {
--   condition = function()
--     return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
--   end,
--
--   provider = function()
--     local ls = require 'luasnip'
--     local right_arrow = ' ' -- NF: right arrow (e.g., \uf061)
--     local left_arrow = ' ' -- NF: left arrow (e.g., \uf060)
--     local right_left_arrow = ' ' -- NF: double arrow (e.g., \uf0ec)
--
--     local can_jump_forward = ls.expand_or_jumpable()
--     local can_jump_backward = ls.jumpable(-1)
--
--     if can_jump_forward and can_jump_backward then
--       return right_left_arrow
--     elseif can_jump_backward then
--       return left_arrow
--     elseif can_jump_forward then
--       return right_arrow
--     else
--       return ''
--     end
--   end,
--
--   hl = { fg = 'red', bold = true },
-- }
-- local right_arrow = ' '
-- local right_left_arrow = ''
-- -- local right_arrow = ' ~>'
-- local left_arrow = ' '
-- -- local left_arrow = '<~'

local DAPMessages = {
  condition = function()
    local session = require('dap').session()
    return session ~= nil
  end,
  provider = function()
    return icons.debug .. require('dap').status() .. ' '
  end,
  hl = 'Debug',
  {
    provider = ' ',
    on_click = {
      callback = function()
        require('dap').step_into()
      end,
      name = 'heirline_dap_step_into',
    },
  },
  { provider = ' ' },
  {
    provider = ' ',
    on_click = {
      callback = function()
        require('dap').step_out()
      end,
      name = 'heirline_dap_step_out',
    },
  },
  { provider = ' ' },
  {
    provider = ' ',
    on_click = {
      callback = function()
        require('dap').step_over()
      end,
      name = 'heirline_dap_step_over',
    },
  },
  { provider = ' ' },
  {
    provider = ' ',
    hl = { fg = 'green' },
    on_click = {
      callback = function()
        require('dap').run_last()
      end,
      name = 'heirline_dap_run_last',
    },
  },
  { provider = ' ' },
  {
    provider = ' ',
    hl = { fg = 'red' },
    on_click = {
      callback = function()
        require('dap').terminate()
        require('dapui').close {}
      end,
      name = 'heirline_dap_close',
    },
  },
  { provider = ' ' },
  --       ﰇ  
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
      vim.cmd 'Oil .'
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

local CodeiumStatus = {
  condition = function()
    return not conditions.buffer_matches {
      filetype = { 'dashboard' },
    }
  end,
  hl = { fg = 'cyan' },
  provider = function()
    return '󰚩 ' .. vim.fn['codeium#GetStatusString']()
  end,
}

local DRLSPStatus = {
  condition = conditions.lsp_attached(),
  {
    update = {
      'User',
      pattern = 'DefsCounted',
      callback = function(self, args)
        self.state = args.data
        vim.schedule(function()
          vim.cmd 'redrawstatus'
        end)
      end,
    },
    provider = function(self)
      local state = self.state
      if state ~= nil then
        local provider = ''
        if state.file > 0 and state.workspace > 0 then
          provider = string.format('%d(%d)D', state.file, state.workspace)
        elseif state.workspace > 0 then
          provider = string.format('%dD', state.workspace)
        else
          return ''
        end
        return ' ' .. provider
      end
    end,
  },
  {
    update = {
      'User',
      pattern = 'RefsCounted',
      callback = function(self, args)
        self.state = args.data
        vim.schedule(function()
          vim.cmd 'redrawstatus'
        end)
      end,
    },
    provider = function(self)
      local state = self.state
      if state ~= nil then
        local provider = ''
        if state.file > 0 and state.workspace > 0 then
          provider = string.format('%d(%d)R', state.file, state.workspace)
        elseif state.workspace > 0 then
          provider = string.format('%dR', state.workspace)
        else
          return ''
        end
        return ' ' .. provider
      end
    end,
  },
  hl = { fg = 'green', bold = true },
}

local HelpFilename = {
  condition = function()
    return vim.bo.filetype == 'help'
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ':t')
  end,
  hl = 'Directory',
}

local TerminalName = {
  -- icon = ' ', -- 
  {
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
      return ' ' .. tname
    end,
    hl = { fg = 'blue', bold = true },
  },
  { provider = ' - ' },
  {
    provider = function()
      return vim.b.term_title
    end,
  },
  -- {
  --   provider = function()
  --     local id = require('terminal'):current_term_index()
  --     return ' ' .. (id or 'Exited')
  --   end,
  --   hl = { bold = true, fg = 'blue' },
  -- },
}

local Arrow = {
  {
    condition = function()
      return require('arrow.statusline').is_on_arrow_file(vim.api.nvim_buf_get_name(0)) ~= nil
    end,
    provider = ' ',
  },
  {
    -- hl = { fg = '#938056' },
    provider = function()
      return require('arrow.statusline').text_for_statusline_with_icons(vim.api.nvim_buf_get_name(0))
    end,
  },
}

local Spell = {
  condition = function()
    return vim.wo.spell
  end,
  provider = function()
    return '󰓆 ' .. vim.o.spelllang .. ' '
  end,
  hl = { bold = true, fg = 'green' },
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

local MacroComp = {
  provider = function(self)
    local comp = ''
    if string.find(vim.inspect(self.status), 'Delay') then
      comp = '  ' .. comp
    end
    if string.find(vim.inspect(self.status), 'Recording') then
      comp = '  ' .. comp
    end
    if string.find(vim.inspect(self.status), 'Playing') then
      comp = '  ' .. comp
    end
    return comp
  end,
  update = {
    'User',
    pattern = {
      'NeoComposerRecordingSet',
      'NeoComposerPlayingSet',
      'NeoComposerDelaySet',
    },
    callback = function(self)
      self.status = require('NeoComposer.ui').status_recording()
    end,
  },
}

MacroComp = utils.surround({ separators.slant_left, separators.inverted_slant_right }, 'bright_bg', MacroComp)

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
  end,
  provider = icons.rec,
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
  { provider = ' ' },
}

-- WIP
local VisualRange = {
  condition = function()
    return vim.tbl_containsvim({ 'V', 'v' }, vim.fn.mode())
  end,
  provider = function()
    local start = vim.fn.getpos "'<"
    local stop = vim.fn.getpos "'>"
  end,
}

local ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ' %3.5(%S%)',
  hl = function(self)
    return {
      bold = true,
      fg = 'bright_bg',
      --[[ fg = self:mode_color() ]]
    }
  end,
}

local MatchParen = {
  provider = function()
    return vim.fn['MatchupStatusOffscreen']()
  end,
  -- hl = { link = 'MatchParen' },
}

-- local VirtualEnv = {
--     init = function(self)
--         if not self.timer then
--             self.timer = vim.loop.new_timer()
--             self.timer:start(0, 5000, function()
--                 vim.schedule_wrap(function()
--                     local path = vim.fn.split(vim.fn.system("which python"), "/")
--                     vim.notify(path)
--                     self.pythonpath = path[#path - 2]
--                 end)
--             end)
--         end
--     end,
--     provider = function(self)
--         return self.pythonpath
--     end,
-- }

local Align = { provider = '%=' }
local Space = { provider = ' ' }

-- ViMode = utils.surround({ separators.rounded_left, separators.rounded_right }, 'bright_bg', {
ViMode = utils.surround({ separators.block, separators.inverted_slant_right }, function()
  local mode = vim.fn.mode(1)
  mode_colors = {
    n = 'red',
    no = 'red',
    niI = 'red',
    i = 'orange',
    v = 'cyan',
    V = 'cyan',
    ['\22'] = 'cyan', -- this is an actual ^V, type <C-v><C-v> in insert mode
    c = 'green',
    s = 'purple',
    S = 'purple',
    ['\19'] = 'purple', -- this is an actual ^S, type <C-v><C-s> in insert mode
    R = 'orange',
    r = 'orange',
    ['!'] = 'red',
    t = 'green',
    nt = 'green',
  }
  return mode_colors[mode] or 'red'
end, {
  -- MacroRec,
  -- MacroComp,
  ViMode,
  -- Snippets,
  ShowCmd,
  -- MatchParen,
})

ViMode = utils.surround({ '', separators.inverted_slant_right }, 'bright_bg', {
  ViMode,
  SnippetBar,
  MacroComp,
})

local DefaultStatusline = {
  ViMode,
  Space,
  -- WorkDir,
  FileNameBlock,
  Arrow,
  { provider = '%<' },
  Space,
  Git,
  Space,
  Diagnostics,
  Space,
  CodeiumStatus,
  Align,
  -- { flexible = 3,   { Navic, Space }, { provider = "" } },
  -- Align,
  -- DAPMessages,
  LSPActive,
  { flexible = 2, { DRLSPStatus }, { hl = { fg = 'green' }, provider = '..' } },
  -- VirtualEnv,
  Space,
  FileType,
  { flexible = 3, { FileEncoding, Space }, { provider = '' } },
  Space,
  Ruler,
  SearchCount,
  Space,
  ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  { hl = { fg = 'gray', force = true }, WorkDir },
  FileNameBlock,
  { provider = '%<' },
  Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive' },
    }
  end,
  FileType,
  { provider = '%q' },
  Space,
  HelpFilename,
  Align,
}

local GitStatusline = {
  condition = function()
    return conditions.buffer_matches {
      filetype = { '^git.*', 'fugitive' },
    }
  end,
  FileType,
  Space,
  {
    provider = function()
      return vim.fn.FugitiveStatusline()
    end,
  },
  Space,
  Align,
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,
  hl = { bg = 'dark_red' },
  { condition = conditions.is_active, ViMode, Space },
  FileType,
  Space,
  TerminalName,
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
      i = 'orange',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan', -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = 'green',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple', -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'green',
      nt = 'green',
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

local CloseButton = {
  condition = function(self)
    return not vim.bo.modified
  end,
  update = { 'WinNew', 'WinClosed', 'BufEnter' },
  { provider = ' ' },
  {
    provider = icons.close,
    hl = { fg = 'gray' },
    on_click = {
      callback = function(_, minwid)
        vim.api.nvim_win_close(minwid, true)
      end,
      minwid = function()
        return vim.api.nvim_get_current_win()
      end,
      name = 'heirline_winbar_close_button',
    },
  },
}

local WinBar = {
  fallthrough = false,
  -- {
  --     condition = function()
  --         return conditions.buffer_matches({
  --             buftype = { "nofile", "prompt", "help", "quickfix" },
  --             filetype = { "^git.*", "fugitive" },
  --         })
  --     end,
  --     init = function()
  --         vim.opt_local.winbar = nil
  --     end,
  -- },
  {
    condition = function()
      return conditions.buffer_matches { buftype = { 'terminal', 'acwrite' } }
    end,
    utils.surround({ '', separators.rounded_right }, 'dark_red', {
      FileType,
      Space,
      TerminalName,
      CloseButton,
    }),
  },
  utils.surround({ '', separators.rounded_right }, 'bright_bg', {
    fallthrough = false,
    {
      condition = conditions.is_not_active,
      {
        hl = { fg = 'bright_fg', force = true },
        FileNameBlock,
      },
      CloseButton,
    },
    {
      -- provider = "      ",
      WorkDir,
      Align,
      { provider = '%<' },
      Navic,
      -- FileNameBlock,
      CloseButton,
    },
  }),
}

return { statusline = StatusLines, winbar = WinBar }
