-- ~/.config/nvim/lua/your_module/substitute.lua

local M = {}

function M.substitute_visual_selection()
  -- Get the visual marks
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  local start_row = start_pos[2] - 1
  local start_col = start_pos[3]
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Only allow single-line selection
  if start_row ~= end_row then
    vim.notify('Visual selection must be on a single line', vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
  local text = line:sub(start_col, end_col)

  -- Escape for search
  text = text:gsub('\\', '\\\\'):gsub('/', '\\/')

  -- Build and insert command
  local cmd = ':%s/\\v' .. text .. '//g'
  vim.cmd 'normal! :'
  vim.api.nvim_feedkeys(cmd, 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end

-- New: operator to substitute yanked text over a motion range
-- local function esc(s)
--   return vim.fn.escape(s or '', [[/\.^$*~[]\]])
-- end

local function esc(s)
  return vim.fn.escape(s or '', [[/\.^$*~[]\]])
end
function M.run_yank(_)
  local pat = esc(vim.fn.getreg '"')
  if pat == '' then
    return
  end
  local range = string.format([['[,']s/%s//g]], pat)
  vim.api.nvim_feedkeys(':', 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(range, true, false, true), 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
end
--
-- function M.run_yank(_type)
--   local s = vim.fn.getpos "'["
--   local e = vim.fn.getpos "']"
--   if not s or not e then
--     return
--   end
--   local pat = esc(vim.fn.getreg '"')
--   if pat == '' then
--     return
--   end
--   local range = string.format([['[,']s/%s//g]], pat)
--   print('Range: ' .. vim.inspect(range))
--   vim.cmd 'normal! :'
--   vim.api.nvim_feedkeys(range, 'n', false)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false)
-- end
--
function M.start_yank()
  vim.go.operatorfunc = "v:lua.require'custom.substitute'.run_yank"
  vim.api.nvim_feedkeys('g@', 'n', false)
end

return M
