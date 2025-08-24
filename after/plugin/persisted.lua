local persisted = require 'persisted'
local utils = require 'persisted.utils'
local config = require 'persisted.config'

vim.api.nvim_create_autocmd('VimEnter', {
  nested = true,
  callback = function()
    print(vim.g.started_with_stdin)
    if vim.g.started_with_stdin then
      return
    end

    local forceload = false
    if vim.fn.argc() == 0 then
      forceload = true
    elseif vim.fn.argc() == 1 then
      local dir = vim.fn.expand(vim.fn.argv(0))
      if dir == '.' then
        dir = vim.fn.getcwd()
      end

      if vim.fn.isdirectory(dir) ~= 0 then
        forceload = true
      end
    end
    print(forceload)

    persisted.autoload { force = forceload }
    -- vim.cmd 'SessionLoad'
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = { 'PersistedTelescopeLoadPre', 'PersistedFzfLuaLoadPre' },
  callback = function(_)
    -- Save the currently loaded session using the global variable
    require('persisted').save { session = vim.g.persisted_loaded_session }

    -- Stop lsp clients
    -- vim.api.nvim_input '<ESC>:LspStop<CR>'
    vim.lsp.stop_client(vim.lsp.get_clients())

    -- Delete all of the open buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      -- MiniBufremove.delete(buf, true)
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end,
})

vim.api.nvim_create_user_command('SessionCreate', function(opts)
  local path = opts.args
  local abs_path = vim.fn.fnamemodify(path, ':p')

  -- vim.cmd('cd ' .. abs_path)
  if vim.fn.isdirectory(abs_path) == 0 then
    print('Not a directory: ' .. abs_path)
    -- stop recording current session
    persisted.stop()

    -- delete all open buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    vim.fn.mkdir(abs_path, 'p')
    -- cd into
    vim.fn.chdir(abs_path)

    persisted.start()
    vim.schedule(function()
      vim.cmd 'silent! Oil .'
    end)
  else
    local loaded_session = vim.g.persisted_loaded_session
    local is_loaded_session = loaded_session ~= nil
    -- local persisted = require 'persisted'
    if is_loaded_session then
      -- Save the currently loaded session using the global variable
      persisted.save { session = loaded_session }

      -- Stop lsp clients
      -- vim.api.nvim_input '<ESC>:LspStop<CR>'
      vim.lsp.stop_client(vim.lsp.get_clients())

      -- Delete all of the open buffers
      -- vim.api.nvim_input '<ESC>:%bd!<CR>'
      -- vim.cmd '<cmd>silent! %bd<CR>'
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= vim.api.nvim_get_current_buf() then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.g.persisted_loaded_session = nil
    end
    vim.fn.chdir(abs_path)
    persisted.start()
    vim.schedule(function()
      vim.cmd 'silent! Oil .'
    end)
  end
end, {
  nargs = 1,
  complete = 'dir',
  -- complete = function(ArgLead, CmdLine, CursorPos)
  -- complete = function(ArgLead, _, _)
  --   local paths = vim.fn.glob(ArgLead .. '*', true, 1)
  --   return paths
  -- end,
})

vim.api.nvim_create_user_command('LoadConfigSession', function()
  vim.cmd(string.format('cd %s', vim.fn.stdpath 'config'))
  require('persisted').load()
end, {})

-- Open the Note taking session "Zettelkasten"
vim.api.nvim_create_user_command('ZetteNotes', function()
  -- search if exists
  local note_cwd = 'D:notes'
  local sep = utils.dir_pattern()
  local function escape_pattern(str, pattern, replace, n)
    pattern = string.gsub(pattern, '[%(%)%.%+%-%*%?%[%]%^%$%%]', '%%%1') -- escape pattern
    replace = string.gsub(replace, '[%%]', '%%%%') -- escape replacement

    return string.gsub(str, pattern, replace, n)
  end

  local sessions = persisted.list()
  local function fire(event)
    vim.api.nvim_exec_autocmds('User', { pattern = 'Persisted' .. event })
  end
  for _, session in pairs(sessions) do
    local session_name = escape_pattern(session, config.save_dir, ''):gsub('%%', sep):gsub(vim.fn.expand '~', sep):gsub('//', ''):sub(1, -5)

    if vim.fn.has 'win32' == 1 then
      session_name = escape_pattern(session_name, sep, ':', 1)
      session_name = escape_pattern(session_name, sep, '\\')
    end
    if session_name == note_cwd then
      fire 'FzfLuaLoadPre'
      vim.schedule(function()
        persisted.load { session = session_name }
      end)
      fire 'FzfLuaLoadPost'
    else
      print(session_name)
    end
  end
end, {})
