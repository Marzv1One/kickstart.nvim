local fzf = require 'fzf-lua'
local utils = require 'fzf-lua.utils'
local timeago = require('custom.undotree.timeago').timeago

local get_lines = vim.api.nvim_buf_get_lines

local M = {}

local function get_undotree_entries(ut_entries, level)
  level = level or 0
  local undolist = {}
  for i = #ut_entries, 1, -1 do
    if ut_entries[i].save == nil then
      goto continue
    end
    local undoitem = {
      seq = ut_entries[i].seq,
      alt = level,
      first = i == #ut_entries,
      time = ut_entries[i].time,
    }
    table.insert(undolist, undoitem)

    if ut_entries[i].alt ~= nil then
      local alt_undolist = get_undotree_entries(ut_entries[i].alt, level + 1)
      for _, elem in pairs(alt_undolist) do
        table.insert(undolist, elem)
      end
    end
    ::continue::
  end

  return undolist
end

function M.open()
  local bufnr = vim.api.nvim_get_current_buf()
  local ut = vim.fn.undotree()
  local base_entries = ut.entries
  local seq_cur = ut.seq_cur
  ut = get_undotree_entries(base_entries)
  local lines = {}
  for _, elem in ipairs(ut) do
    local formatted_time = timeago(elem.time)
    local prefix = ''
    if elem.alt > 0 then
      prefix = string.rep('│', elem.alt - 1)
      if elem.first then
        local corner = '┌'
        prefix = prefix .. corner .. '─'
      else
        prefix = prefix .. '├'
      end
    end
    local seq = utils.ansi_codes.cyan('' .. elem.seq)
    formatted_time = utils.ansi_codes.yellow('(' .. formatted_time .. ')')
    local is_cur = elem.seq == seq_cur
    if is_cur then
      prefix = utils.ansi_codes.red '*' .. prefix
    end
    table.insert(lines, prefix .. 'state #' .. seq .. ' ' .. formatted_time)
  end
  table.insert(lines, 'state #0 (no track)')
  local function create_temp_file(path, content)
    local file = io.open(path, 'w')
    if file then
      file:write(content)
      file:close()
      return path
    else
      error('Could not create temp file: ' .. path)
    end
  end
  local temp_dir = vim.fn.stdpath 'cache' .. '/fzf-undotree/'
  -- check if the directory exists
  if vim.fn.isdirectory(temp_dir) == 0 then
    vim.fn.mkdir(temp_dir, 'p')
  end
  local function delete_temp_files()
    local split_glob = vim.fn.glob(temp_dir .. 'fzf-undotree-*.txt')
    local files = vim.fn.split(split_glob, '\n')
    for _, file in ipairs(files) do
      os.remove(file)
    end
  end
  delete_temp_files()
  local win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(win)
  fzf.fzf_exec(lines, {
    prompt = 'Undotree> ',
    preview = {
      type = 'cmd',
      fn = function(entry)
        local seq = entry[1]:match 'state #(%d+)%s'
        local cmd = vim.api.nvim_buf_call(bufnr, function()
          local current_lines = get_lines(bufnr, 0, -1, false)
          vim.cmd('silent undo ' .. seq)
          local undo_lines = get_lines(bufnr, 0, -1, false)
          vim.cmd('silent undo ' .. seq_cur)
          vim.api.nvim_win_set_cursor(win, cursor_pos)
          local current_lines_str = table.concat(current_lines, '\n')
          local undo_lines_str = table.concat(undo_lines, '\n')
          local diff = vim.text.diff(undo_lines_str, current_lines_str, {
            algorithm = 'histogram',
          })
          local temp_file_path = temp_dir .. 'fzf-undotree-' .. seq .. '.txt'
          create_temp_file(temp_file_path, diff)
          local cmd = 'bat ' .. temp_file_path .. ' --style=plain | delta --width=170 --side-by-side'
          return cmd
        end)
        if cmd then
          return cmd
        end
        return 'echo hola :)'
      end,
    },
    actions = {
      ['ctrl-y'] = function(selected)
        local index, _ = selected[1]:match 'state #(%d+)%s'
        vim.cmd('undo ' .. index)
      end,
      ['ctrl-a'] = function(selected)
        local index, _ = selected[1]:match 'state #(%d+)%s'
        local temp_file_path = temp_dir .. 'fzf-undotree-' .. index .. '.txt'
        local cmd = 'cat ' .. temp_file_path .. ' --style=plain | delta --width=100 --side-by-side'
        require('toggleterm').exec(cmd, 6)
      end,
    },
    winopts = {
      fullscreen = true,
      ---@diagnostic disable-next-line: missing-fields
      preview = {
        layout = 'vertical',
        vertical = 'up:70%',
      },
      -- on_close = function()
      --   -- delete_temp_files()
      -- end,
    },
  })
end

vim.api.nvim_create_user_command('Undotree', M.open, { nargs = 0 })
vim.keymap.set('n', '<leader>pu', '<cmd>Undotree<CR>', { noremap = true, silent = true })
