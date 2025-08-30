-- Unescape Unicode
vim.api.nvim_create_user_command('UnescapeUnicode', function()
  -- Match \\uXXXX, \\u{XXXX}, and \\uXX formats
  vim.cmd "%s/\\\\u\\({[0-9a-fA-F]\\+}\\|\\([0-9a-fA-F]\\{4\\}\\|[0-9a-fA-F]\\{2\\}\\)\\)/\\=nr2char('0x' . substitute(submatch(1), '{\\|}', '', 'g'))/g"
end, {})

-- Shared helper: spawn a WezTerm pane and send text, newline at end
local function wezterm_spawn_and_send(cmd_text, existing_pane_id, opts)
  opts = opts or {}
  local tab = opts.tab or false -- false (default) for window, true for tab
  local cwd = opts.cwd or '.' -- use provided cwd or default to current directory
  local exit_on_close = opts.exit_on_close or false
  local to_send = cmd_text
  if exit_on_close then
    to_send = to_send .. ';exit'
  end
  if existing_pane_id and existing_pane_id ~= '' then
    vim.system({
      'wezterm',
      'cli',
      'send-text',
      '--pane-id',
      existing_pane_id,
      to_send .. '\n',
    }, { text = true })
  else
    local spawn_args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd }
    if not tab then
      table.insert(spawn_args, 4, '--new-window')
    end
    vim.system(spawn_args, { text = true }, function(spawn_res)
      local pane_id = vim.trim(spawn_res.stdout)
      if pane_id ~= '' then
        vim.system({
          'wezterm',
          'cli',
          'send-text',
          '--pane-id',
          pane_id,
          to_send .. '\n',
        }, { text = true })
      end
    end)
  end
end

-- Spawn Crush in new WezTerm window
vim.api.nvim_create_user_command('SpawnCrush', function(opts)
  local args_str = opts.args or ''
  local cmd = 'SpawnWezterm cmd=crush exit'

  -- Add tab if specified
  if args_str == 'tab' then
    cmd = cmd .. ' tab'
  end

  vim.cmd(cmd)
end, { nargs = '?' })

-- Spawn Lazygit in new WezTerm window
vim.api.nvim_create_user_command('SpawnLazygit', function(opts)
  local args_str = opts.args or ''
  local cmd = 'SpawnWezterm cmd=lazygit exit'

  -- Add tab if specified
  if args_str == 'tab' then
    cmd = cmd .. ' tab'
  end

  vim.cmd(cmd)
end, { nargs = '?' })

-- Spawn `bat` for a file in new Wezterm window
-- Usage:
--   :SpawnBat             -> Runs 'bat' on current file
--   :SpawnBat ~/file.txt  -> Runs 'bat' on ~/file.txt
vim.api.nvim_create_user_command('SpawnBat', function(opts)
  local args_str = opts.args or ''
  local filepath = vim.fn.expand '%:p'

  -- If args provided and not just 'tab', use them as filepath
  if args_str ~= '' and not args_str:match '^%s*tab%s*$' then
    -- Remove tab from args if present
    local clean_args = args_str:gsub('%s+tab%s*$', ''):gsub('^tab%s+', ''):gsub('%s+tab%s+', ' ')
    if clean_args ~= '' and clean_args ~= args_str then
      -- tab was removed, so we need to add it back as a parameter
      filepath = clean_args
      args_str = 'target=' .. vim.fn.shellescape(filepath) .. ' tab'
    else
      filepath = args_str
      args_str = 'target=' .. vim.fn.shellescape(filepath)
    end
  else
    args_str = 'target=' .. vim.fn.shellescape(filepath)
    -- Add tab if specified
    if opts.args and opts.args:match 'tab' then
      args_str = args_str .. ' tab'
    end
  end
  args_str = args_str .. ' exit'

  local cmd = 'SpawnWezterm cmd=bat ' .. args_str
  vim.cmd(cmd)
end, { nargs = '*' })

-- Spawn Superfile (spf) in new Wezterm window
-- Usage:
--   :SpawnSpf             -> Runs 'spf' in current directory
--   :SpawnSpf ~/projects  -> Runs 'spf ~/projects'
vim.api.nvim_create_user_command('SpawnSpf', function(opts)
  local args_str = opts.args or ''
  local cmd = 'SpawnWezterm cmd=spf exit'

  -- If args provided, add them
  if args_str ~= '' then
    cmd = cmd .. ' ' .. args_str
  end

  vim.cmd(cmd)
end, { nargs = '*' })

-- Spawn `glow` for a file in new WezTerm window
-- Usage:
--   :SpawnGlow             -> Runs 'glow --line-numbers --tui' in root Git directory
--   :SpawnGlow ~/file.md   -> Runs 'glow --line-numbers --tui' on ~/file.md
local glow_pane_id = nil
local glow_has_window = false

local function _lua_shellescape(s)
  if s == nil or s == '' then
    return "''"
  end
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- Helper to check if a given WezTerm pane_id is alive
local function check_pane_alive(pane_id, cb)
  if not pane_id or pane_id == '' then
    cb(false)
    return
  end
  vim.system({ 'wezterm', 'cli', 'list' }, { text = true }, function(res)
    if res.code == 0 and res.stdout and res.stdout:find('%f[%d]' .. pane_id .. '%f[%D]') then
      cb(true)
    else
      cb(false)
    end
  end)
end

vim.api.nvim_create_user_command('SpawnGlow', function(opts)
  local args = vim.split(opts.args or '', ' +')
  local mode = #args > 0 and args[#args] == 'tab' and 'tab' or 'window'
  if mode == 'tab' then
    table.remove(args, #args)
  end
  local filepath = #args > 0 and table.concat(args, ' ') or ''
  local git_root = vim.trim(vim.fn.system { 'git', 'rev-parse', '--show-toplevel' })
  local cwd = vim.v.shell_error == 0 and git_root or '.'

  local function spawn_new()
    local spawn_args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd }
    if mode == 'window' then
      table.insert(spawn_args, 4, '--new-window')
    end
    vim.system(spawn_args, { text = true }, function(spawn_res)
      local pane_id = vim.trim(spawn_res.stdout)
      if pane_id ~= '' then
        glow_pane_id = pane_id
        glow_has_window = true
        local cmd = filepath ~= '' and ('glow --line-numbers --tui ' .. _lua_shellescape(filepath)) or 'glow --line-numbers --tui'
        wezterm_spawn_and_send(cmd, pane_id)
      else
        glow_pane_id = nil
        glow_has_window = false
        vim.notify('Failed to spawn new Glow pane', vim.log.levels.ERROR)
      end
    end)
  end

  if glow_has_window and glow_pane_id and glow_pane_id ~= '' then
    check_pane_alive(glow_pane_id, function(alive)
      if alive then
        local cmd = filepath ~= '' and ('glow --line-numbers --tui ' .. _lua_shellescape(filepath)) or 'glow --line-numbers --tui'
        wezterm_spawn_and_send(cmd, glow_pane_id)
      else
        glow_pane_id = nil
        glow_has_window = false
        vim.notify('Glow pane was closed. Spawning new one.', vim.log.levels.INFO)
        spawn_new()
      end
    end)
  else
    glow_pane_id = nil
    glow_has_window = false
    spawn_new()
  end
end, { nargs = '?' })

-- Spawn a new Wezterm window or tab with optional command
-- Usage:
--   :SpawnWezterm                        -> Opens new terminal in current directory in new window
--   :SpawnWezterm cwd=~/projects         -> Opens new terminal in ~/projects directory in new window
--   :SpawnWezterm cwd=~/projects tab     -> Opens new terminal in ~/projects directory in new tab
--   :SpawnWezterm cwd=~/projects cmd=nvim -> Opens new terminal in ~/projects directory and runs nvim
--   :SpawnWezterm cwd=~/projects cmd=bat target=myfile.json -> Opens new terminal in ~/projects directory and runs bat myfile.json
--   :SpawnWezterm cwd=~/projects cmd=bat target=myfile.json tab -> Opens new terminal in ~/projects directory in new tab and runs bat myfile.json
vim.api.nvim_create_user_command('SpawnWezterm', function(opts)
  local args = vim.split(opts.args or '', ' +')
  local tab = false
  local cwd = '.'
  local cmd = nil
  local target = nil
  local exit_on_close = false

  -- Parse named arguments
  for _, arg in ipairs(args) do
    if arg == 'tab' then
      tab = true
    elseif arg == 'exit' then
      exit_on_close = true
    elseif arg:match '^cwd=' then
      cwd = arg:sub(5) -- Remove 'cwd=' prefix
    elseif arg:match '^cmd=' then
      cmd = arg:sub(5) -- Remove 'cmd=' prefix
    elseif arg:match '^target=' then
      target = arg:sub(8) -- Remove 'target=' prefix
    end
  end

  if cmd then
    -- If cmd is specified, build the full command
    local full_cmd = cmd
    if target then
      full_cmd = cmd .. ' ' .. target
    end
    -- Use wezterm_spawn_and_send
    wezterm_spawn_and_send(full_cmd, nil, { tab = tab, cwd = cwd, exit_on_close = exit_on_close })
  else
    -- Otherwise, spawn a plain terminal
    wezterm_spawn_and_send('', nil, { tab = tab, cwd = cwd, exit_on_close = exit_on_close })
  end
end, { nargs = '*' })

-- Spawn a new Neovim instance in Wezterm window or tab
-- Usage:
--   :SpawnNvim             -> Opens nvim in current directory in new window
--   :SpawnNvim tab         -> Opens nvim in current directory in new tab
--   :SpawnNvim ~/projects  -> Opens nvim in ~/projects directory in new window
--   :SpawnNvim ~/projects tab -> Opens nvim in ~/projects directory in new tab
vim.api.nvim_create_user_command('SpawnNvim', function(opts)
  local args_str = opts.args or ''
  local cmd = 'SpawnWezterm cmd=nvim'

  -- If args provided, add them
  if args_str ~= '' then
    cmd = cmd .. ' ' .. args_str
  end

  vim.cmd(cmd)
end, { nargs = '*' })

-- set local nowrap
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'csv', 'log' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- set tab settings for SQL files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'lua', 'cs' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local data = { file = 0, workspace = 0 }
    vim.api.nvim_exec_autocmds('User', {
      pattern = 'RefsCounted',
      data = data,
    })
    vim.api.nvim_exec_autocmds('User', {
      pattern = 'DefsCounted',
      data = data,
    })
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'dap-view', 'dap-view-term', 'dap-repl', 'dap-float' }, -- dap-repl is set by `nvim-dap`
  callback = function(args)
    vim.keymap.set('n', 'q', '<C-w>q', { buffer = args.buf })
  end,
})

-- Filetype-specific keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dashboard',
  callback = function()
    vim.keymap.set('n', '.', '<cmd>SessionLoad<CR>', { buffer = true, silent = true })
    vim.keymap.set('n', 'e', '<cmd>Oil .<CR>', { buffer = true, silent = true })
  end,
})

-- Define function to wipe out all terminal buffers
local function wipe_terminal_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value('filetype', { buf = buf }) == 'terminal' then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

-- Set autocmd to run before Neovim exits
vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Wipe out all terminal buffers before exit',
  callback = wipe_terminal_buffers,
})

vim.api.nvim_create_user_command('UndotreeCleanCache', function()
  require('undotree_cache').cleanup()
end, {})

-- Stop PowerToys process
vim.api.nvim_create_user_command('StopPowerToys', function()
  vim.fn.system { 'powershell', '-Command', 'Stop-Process -Name PowerToys -Force' }
end, {})

-- Helper: Check if node is rendered (has valid mark)
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

-- vim.keymap.set({ 'i', 's' }, '<C-g>', function()
--   local prog = get_snippet_progress()
--   if prog then
--     print(('🎯 Snippet: %d/%d (%.0f%%)'):format(prog.current, prog.total, prog.percentage * 100))
--   else
--     print '❌ Not in a valid snippet or no rendered nodes'
--   end
-- end, { desc = 'Show snippet progress' })

vim.api.nvim_create_user_command('LtexLang', function(opts)
  vim.lsp.buf_notify(0, 'workspace/didChangeConfiguration', {
    settings = {
      ltex = { language = opts.args },
    },
  })
end, {
  nargs = 1,
  complete = function()
    return { 'en-US', 'es' }
  end,
})

vim.filetype.add {
  extension = {
    ['http'] = 'http',
  },
}
