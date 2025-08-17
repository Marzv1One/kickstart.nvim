local fzf = require 'fzf-lua'
local utils = require 'fzf-lua.utils'

local M = {}

function GetYankHistory()
  local history = {}
  for index, value in ipairs(require('yanky.history').all()) do
    value.history_index = index
    history[index] = value
  end
  return history
end

function M.open(is_visual_mode)
  is_visual_mode = is_visual_mode or false
  local history = GetYankHistory()
  local function register_escape_special(reg, nl)
    if not reg then
      return nil
    end

    local gsub_map = {
      ['\3'] = '^C', -- <C-c>
      ['\27'] = '^[', -- <Esc>
      ['\18'] = '^R', -- <C-r>
    }

    for k, v in pairs(gsub_map) do
      reg = reg:gsub(k, utils.ansi_codes.magenta(v))
    end
    return not nl and reg or nl == 2 and reg:gsub('\n$', '') or reg:gsub('\n', utils.ansi_codes.magenta '\\n')
  end

  local entries = {}
  for _, entry in ipairs(history) do
    local contents = entry.regcontents
    contents = register_escape_special(contents, 1)
    if contents and #contents > 0 then
      do
        table.insert(entries, string.format('%s: %s', utils.ansi_codes.cyan('' .. entry.history_index), contents))
      end
    end
  end

  local get_selection = function(selected)
    local index = selected[1]:match '^(%d+)'
    local storage = require 'yanky.storage.sqlite'
    local item = storage.get(index).regcontents
    if item then
      vim.fn.setreg('+', item)
    end
  end

  local get_selection_and_paste = function(selected)
    get_selection(selected)
    if is_visual_mode then
      vim.cmd 'normal! gv"+p'
    else
      vim.cmd 'normal  p'
    end
  end

  return fzf.fzf_exec(entries, {
    prompt = 'Yank History> ',
    preview = function(entry)
      local index, contents = entry[1]:match '^(%d+): (.*)'
      local storage = require 'yanky.storage.sqlite'
      local item = storage.get(index).regcontents or contents
      return register_escape_special(item) or item
    end,
    actions = {
      ['enter'] = get_selection_and_paste,
      ['ctrl-y'] = get_selection_and_paste,
      ['alt-y'] = get_selection,
      ['ctrl-x'] = function(selected)
        local index, _ = selected[1]:match '(%d+):(.*)'
        local storage = require 'yanky.storage.sqlite'
        storage.delete(index)
        M.open()
      end,
    },
  })
end

vim.keymap.set('n', '<leader>fy', M.open, {
  noremap = true,
  desc = 'Yank History',
})
vim.keymap.set('v', '<leader>fy', function()
  M.open(true)
end, { noremap = true, desc = 'Yank History' })
