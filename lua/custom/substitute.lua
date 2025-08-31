-- ~/.config/nvim/lua/custom/substitute.lua

local M = {}

function M.substitute_visual_selection()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  local start_row = start_pos[2] - 1
  local start_col = start_pos[3]
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  if start_row ~= end_row then
    vim.notify('Visual selection must be on a single line', vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
  local text = line:sub(start_col, end_col)

  text = text:gsub('\\', '\\\\'):gsub('/', '\\/'):gsub('%(', '\\('):gsub('%)', '\\)')

  local cmd = ':%s/\\v' .. text .. '//g'
  vim.cmd 'normal! :'
  vim.api.nvim_feedkeys(cmd, 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end

-- local function esc(s)
--   return vim.fn.escape(s or '', [[/\.^$*~[]\]])
-- end
local function esc(s)
  return (s or ''):gsub('\\', '\\\\'):gsub('/', '\\/'):gsub('%(', '\\('):gsub('%)', '\\)')
end

local function yank_pat()
  local raw = vim.fn.getreg('"', 1, 1)
  if type(raw) == 'table' and #raw > 1 then
    vim.notify('" register is multiline', vim.log.levels.WARN)
    return nil
  end
  local pat = esc(vim.fn.getreg '"')
  if pat == '' then
    vim.notify('Empty " register', vim.log.levels.WARN)
    return nil
  end
  return pat
end

function M.run_yank(_)
  local pat = yank_pat()
  if not pat then
    return
  end
  local range = string.format([['[,']s/\v%s//g]], pat)
  vim.api.nvim_feedkeys(':', 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(range, true, false, true), 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end

function M.start_yank()
  vim.go.operatorfunc = "v:lua.require'custom.substitute'.run_yank"
  vim.api.nvim_feedkeys('g@', 'n', false)
end

function M.line_yank()
  local pat = yank_pat()
  if not pat then
    return
  end
  local cmd = string.format([[:s/\v%s//g]], pat)
  vim.api.nvim_feedkeys(':', 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end

function M.eol_yank()
  local pat = yank_pat()
  if not pat then
    return
  end
  vim.go.operatorfunc = "v:lua.require'custom.substitute'.run_yank"
  vim.api.nvim_feedkeys('g@$', 'n', false)
end

function M.visual_yank()
  local pat = yank_pat()
  if not pat then
    return
  end
  local range = [[s/\v]] .. pat .. [[//g]]
  -- local range = [['<,'>s/]] .. pat .. [[//g]]
  vim.api.nvim_feedkeys(':', 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(range, true, false, true), 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end

return M
