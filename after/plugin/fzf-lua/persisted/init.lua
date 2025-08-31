local persisted = require 'persisted'
local config = require 'persisted.config'
local utils = require 'persisted.utils'
local actions = require 'custom.persisted.actions'
local fzf = require 'fzf-lua'

local M = {}

---Escapes special characters before performing string substitution
---@param str string
---@param pattern string
---@param replace string
---@param n? integer
---@return string
---@return integer
local function escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, '[%(%)%.%+%-%*%?%[%]%^%$%%]', '%%%1') -- escape pattern
  replace = string.gsub(replace, '[%%]', '%%%%') -- escape replacement

  return string.gsub(str, pattern, replace, n)
end

local function get_sessions()
  local sep = utils.dir_pattern()

  local sessions = {}
  for _, session in pairs(persisted.list()) do
    local session_name = escape_pattern(session, config.save_dir, ''):gsub('%%', sep):gsub(vim.fn.expand '~', sep):gsub('//', ''):sub(1, -5)

    if vim.fn.has 'win32' == 1 then
      session_name = escape_pattern(session_name, sep, ':', 1)
      session_name = escape_pattern(session_name, sep, '\\')
    end

    local branch, dir_path

    if string.find(session_name, '@@', 1, true) then
      local splits = vim.split(session_name, '@@', { plain = true })
      branch = table.remove(splits, #splits)
      dir_path = vim.fn.join(splits, '@@')
    else
      dir_path = session_name
    end

    table.insert(sessions, {
      ['name'] = session_name,
      ['file_path'] = session,
      ['branch'] = branch,
      ['dir_path'] = dir_path,
    })
  end

  return sessions
end

---@return nil
local function get_session(name, sessions)
  name = name:sub(12, -1)
  for _, session in ipairs(sessions) do
    if session.name == name then
      return session
    end
  end
  return nil
end

local function get_selected_session(selected)
  local sessions = get_sessions()
  local session = get_session(selected[1], sessions)
  if session then
    actions.load_session(session)
  end
end

local function delete_selected_session(selected)
  print(selected)
  local sessions = get_sessions()
  print(sessions)
  local session = get_session(selected[1], sessions)
  if session then
    actions.delete_session(session)
    M.open()
  end
end

local icon_padding = fzf.utils.ansi_codes.blue '󰝰' .. ' 󰇝  '

local function escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, '[%(%)%.%+%-%*%?%[%]%^%$%%]', '%%%1') -- escape pattern
  replace = string.gsub(replace, '[%%]', '%%%%') -- escape replacement

  return string.gsub(str, pattern, replace, n)
end

function M.open()
  local opts = {}
  opts.prompt = 'Persisted Sessions> '
  opts.winopts = {
    height = 0.69,
    width = 0.69,
  }
  opts.actions = {
    ['enter'] = get_selected_session,
    ['ctrl-y'] = get_selected_session,
    ['ctrl-x'] = delete_selected_session,
    ['ctrl-e'] = function(selected)
      local sessions = get_sessions()
      local session = get_session(selected[1], sessions)
      if session then
        local session_name = session.dir_path
        if vim.fn.has 'win32' == 1 then
          local sep = utils.dir_pattern()
          session_name = escape_pattern(session_name, sep, ':', 1)
          session_name = escape_pattern(session_name, sep, '\\')
        end

        local cmd = string.format('SpawnWezterm cmd=nvim cwd=%s tab', session_name)
        -- print(cmd)
        vim.cmd(cmd)
      end
    end,
  }

  local sessions = get_sessions()
  local lines = vim.tbl_map(function(entry)
    return icon_padding .. entry.name
  end, vim.tbl_values(sessions))

  fzf.fzf_exec(lines, opts)
end

vim.api.nvim_create_user_command('Persisted', M.open, {})

vim.keymap.set('n', '<leader>ps', M.open, { noremap = true, desc = 'Persisted Sessions' })
