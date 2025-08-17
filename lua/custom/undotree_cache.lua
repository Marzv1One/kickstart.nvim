-- File: lua/undotree_cache.lua

local M = {}

local debounce_timer = nil
local temp_dir = vim.fn.stdpath 'cache' .. '/fzf-undotree/'

--- Ensure the temp directory exists
local function ensure_temp_dir()
  if vim.fn.isdirectory(temp_dir) == 0 then
    vim.fn.mkdir(temp_dir, 'p')
  end
end

--- Get the current snapshot path for a given buffer
--- @param bufnr number
function M.get_current_file_path(bufnr)
  return temp_dir .. string.format('current-%d.txt', bufnr)
end

--- Get the undo snapshot path for a given buffer and undo sequence
--- @param seq number
function M.get_undo_file_path(seq)
  return temp_dir .. string.format('undo-%d.txt', seq)
end

--- Write the buffer's current content to its snapshot file
--- @param bufnr number
function M.write_current_snapshot(bufnr)
  local path = M.get_current_file_path(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd('silent noautocmd write! ' .. path)
  end)
end

--- Write an undo state to a file using headless Neovim
--- @param bufnr number
--- @param seq number
--- @return string|nil, string|nil: path or nil, error or nil
function M.write_undo_snapshot(bufnr, seq)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == '' then
    return nil, 'Buffer has no associated file'
  end
  local out_path = M.get_undo_file_path(seq):gsub('/', '\\')
  local cmd = string.format([[nvim --headless "%s" +"silent undo %d" +"w! %s" +"qa!"]], filepath, seq, out_path)

  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, 'Headless undo failed: ' .. result
  end

  return out_path
end

--- Schedule a snapshot write on buffer change (debounced)
--- @param bufnr number
function M.schedule_snapshot(bufnr)
  if debounce_timer and not debounce_timer:is_closing() then
    debounce_timer:stop()
    debounce_timer:close()
  end

  debounce_timer = vim.loop.new_timer()
  debounce_timer:start(300, 0, function()
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      if filepath == '' then
        return
      end
      M.write_current_snapshot(bufnr)
    end)
  end)
end

--- Clean up all undo/current temp files
function M.cleanup()
  local files = vim.fn.globpath(temp_dir, 'undo-*.txt', false, true)
  vim.list_extend(files, vim.fn.globpath(temp_dir, 'current-*.txt', false, true))
  for _, file in ipairs(files) do
    os.remove(file)
  end
end

--- Initialize autocommands for live caching
function M.setup_autocmds()
  ensure_temp_dir()

  vim.api.nvim_create_autocmd({
    'BufEnter',
    'TextChanged',
    'TextChangedI',
  }, {
    callback = function(args)
      M.schedule_snapshot(args.buf)
    end,
  })

  -- Optional: Cleanup on exit
  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      -- M.cleanup()
    end,
  })
end

return M
