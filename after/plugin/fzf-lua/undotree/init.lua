local fzf = require 'fzf-lua'
local utils = require 'fzf-lua.utils'
local timeago = require('custom.undotree.timeago').timeago

local undocache = require 'custom.undotree_cache'
undocache.setup_autocmds()

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

  -- local function create_file_content(path, content)
  --   local file = io.open(path, 'w')
  --   if file then
  --     file:write(content)
  --     file:close()
  --     return path
  --   else
  --     error('Could not create temp file: ' .. path)
  --   end
  -- end

  local temp_dir = vim.fn.stdpath 'cache' .. '/fzf-undotree/'
  -- check if the directory exists
  if vim.fn.isdirectory(temp_dir) == 0 then
    vim.fn.mkdir(temp_dir, 'p')
  end

  local function delete_temp_files()
    local split_glob = vim.fn.glob(temp_dir .. 'undo-*.txt')
    local files = vim.fn.split(split_glob, '\n')
    for _, file in ipairs(files) do
      os.remove(file)
    end
  end
  delete_temp_files()
  -- local win = vim.api.nvim_get_current_win()
  -- local cursor_pos = vim.api.nvim_win_get_cursor(win)

  -- local temp_current_file = temp_dir .. 'fzf-undotree-current.txt'
  --
  -- -- Only write current file once
  -- if vim.fn.filereadable(temp_current_file) == 0 then
  --   vim.api.nvim_buf_call(bufnr, function()
  --     vim.cmd('silent write! ' .. temp_current_file)
  --   end)
  -- end
  --
  -- local filepath = vim.api.nvim_buf_get_name(bufnr)
  -- if filepath == '' then
  --   return 'echo "Buffer has no file path."'
  -- end
  local temp_current_file = temp_dir .. string.format('current-%d.txt', bufnr)

  -- Write current file only once
  if vim.fn.filereadable(temp_current_file) == 0 then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd('silent write! ' .. temp_current_file)
    end)
  end

  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == '' then
    return 'echo "This buffer has no file path."'
  end

  --- Generate a delta diff command between an undo state and current buffer
  --- @param seq number: The target undo sequence number
  --- @return string: A shell command to preview the diff
  -- local function make_undo_preview_cmd(seq)
  --   local temp_undo_file = temp_dir .. 'undo-' .. seq .. '.txt'
  --   -- local temp_current_file = temp_dir .. 'current.txt'
  --   --
  --   -- -- Write current file only once
  --   -- if vim.fn.filereadable(temp_current_file) == 0 then
  --   --   vim.api.nvim_buf_call(bufnr, function()
  --   --     vim.cmd('silent write! ' .. temp_current_file)
  --   --   end)
  --   -- end
  --   --
  --   -- Write undo state using headless Neovim
  --   local function write_undo_to_file()
  --     local cmd = string.format([[nvim --headless "%s" +"silent undo %d" +"w! %s" +"qa!"]], filepath, seq, temp_undo_file)
  --     local result = vim.fn.system(cmd)
  --     if vim.v.shell_error ~= 0 then
  --       return nil, 'Failed to run headless undo: ' .. result
  --     end
  --     return temp_undo_file
  --   end
  --
  --   local ok, err = write_undo_to_file()
  --   if not ok then
  --     return 'echo "' .. err .. '"'
  --   end
  --
  --   -- Get terminal width and return final preview command
  --   local width = vim.api.nvim_win_get_width(0)
  --   return string.format('git diff --no-index --diff-algorithm=histogram %s %s | delta --width=%d --side-by-side', temp_undo_file, temp_current_file, width)
  --   -- return string.format('delta --width=%d --side-by-side %s %s', width, temp_undo_file, temp_current_file)
  -- end

  -- return string.format('git diff --no-index --diff-algorithm=histogram %s %s | delta --width=%d --side-by-side', temp_undo_file, temp_current_file, width)
  fzf.fzf_exec(lines, {
    prompt = 'Undotree> ',
    preview = {
      type = 'cmd',
      fn = function(entry)
        local seq = tonumber(entry[1]:match 'state #(%d+)%s') or 0
        -- local bufnr = vim.api.nvim_get_current_buf()
        local cur_path = undocache.get_current_file_path(bufnr)
        local undo_path, err = undocache.write_undo_snapshot(bufnr, seq)
        if not undo_path then
          return 'echo "Error: ' .. err .. '"'
        end

        if vim.fn.filereadable(undo_path) == 0 then
          return 'echo "Undo file not found: ' .. undo_path .. '"'
        end

        local width = vim.api.nvim_win_get_width(0)
        return string.format('delta --width=%d --side-by-side %s %s', width, undo_path, cur_path)
      end,
    },
    actions = {
      ['ctrl-a'] = function(selected)
        local seq = tonumber(selected[1]:match 'state #(%d+)%s') or 0
        -- local bufnr = vim.api.nvim_get_current_buf()
        local undo_path = undocache.get_undo_file_path(seq)
        local cur_path = undocache.get_current_file_path(bufnr)
        local cmd = string.format('delta --side-by-side %s %s', undo_path, cur_path)
        require('toggleterm').exec(cmd, 6)
      end,
      ['ctrl-y'] = function(selected)
        local seq = tonumber(selected[1]:match 'state #(%d+)%s')
        vim.cmd('undo ' .. seq)
      end,
      ['enter'] = function(selected)
        local seq = tonumber(selected[1]:match 'state #(%d+)%s')
        vim.cmd('undo ' .. seq)
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
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<CR>', { noremap = true, silent = true })
