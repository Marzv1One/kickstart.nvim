local persisted = require 'persisted'
local config = persisted.config

local M = {}

---Fire an event
---@param event string
local function fire(event)
  vim.api.nvim_exec_autocmds('User', { pattern = 'Persisted' .. event })
end

---Load the selected session
---@param session table
function M.load_session(session)
  fire 'FzfLuaLoadPre'
  vim.schedule(function()
    persisted.load { session = session.file_path }
  end)
  fire 'FzfLuaLoadPost'
end

---Delete selected session
---@param session table
function M.delete_session(session)
  if vim.fn.confirm('Delete [' .. session.name .. ']?', '&Yes\n&No') == 1 then
    vim.fn.delete(vim.fn.expand(session.file_path))
  end
end

---Change the branch of an existing session
---@param session table
function M.change_branch(session)
  local path = session.file_path

  local branch = vim.fn.input 'Branch: '
  print('branch', branch)

  if vim.fn.confirm('Add/update branch to [' .. branch .. ']?', '&Yes\n&No') == 1 then
    local ext = path:match '^.+(%..+)$'

    -- Check for existing branch in the filename
    local pattern = '(.*)@@.+' .. ext .. '$'
    local base = path:match(pattern) or path:sub(1, #path - #ext)

    -- Replace or add the new branch name
    local new_path = ''
    if branch == '' then
      new_path = base .. ext
    else
      new_path = base .. '@@' .. branch .. ext
    end

    os.rename(path, new_path)
  end
end

return M
