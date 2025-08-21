-- Unescape Unicode
vim.api.nvim_create_user_command('UnescapeUnicode', function()
  -- Match \\uXXXX, \\u{XXXX}, and \\uXX formats
  vim.cmd "%s/\\\\u\\({[0-9a-fA-F]\\+}\\|\\([0-9a-fA-F]\\{4\\}\\|[0-9a-fA-F]\\{2\\}\\)\\)/\\=nr2char('0x' . substitute(submatch(1), '{\\|}', '', 'g'))/g"
end, {})

-- Shared helper: spawn a WezTerm pane and send text, newline at end
local function wezterm_spawn_and_send(cmd_text, existing_pane_id)
  -- Always append an exit to ensure the spawned pane closes after execution
  local to_send = cmd_text
  if not to_send:match(";exit%s*$") then
    to_send = to_send .. ";exit"
  end
  if existing_pane_id and existing_pane_id ~= '' then
    vim.system({
      'wezterm', 'cli', 'send-text',
      '--pane-id', existing_pane_id,
      to_send .. "\n",
    }, { text = true })
  else
    vim.system({
      'wezterm', 'cli', 'spawn',
      '--new-window',
      '--cwd', '.',
    }, { text = true }, function(spawn_res)
      local pane_id = vim.trim(spawn_res.stdout)
      if pane_id ~= '' then
        vim.system({
          'wezterm', 'cli', 'send-text',
          '--pane-id', pane_id,
          to_send .. "\n",
        }, { text = true })
      end
    end)
  end
end

-- Spawn Crush in new WezTerm window
vim.api.nvim_create_user_command('SpawnCrush', function()
  wezterm_spawn_and_send('crush')
end, {})

-- Spawn Lazygit in new WezTerm window
vim.api.nvim_create_user_command('SpawnLazygit', function()
  wezterm_spawn_and_send('lazygit')
end, {})

-- Spawn `bat` for a file in new Wezterm window
-- Usage:
--   :SpawnBat             -> Runs 'bat' on current file
--   :SpawnBat ~/file.txt  -> Runs 'bat' on ~/file.txt
vim.api.nvim_create_user_command('SpawnBat', function(opts)
  local filepath = opts.args ~= '' and opts.args or vim.fn.expand '%:p'
  if filepath == '' then
    vim.notify('No file specified or in buffer', vim.log.levels.WARN)
    return
  end

  wezterm_spawn_and_send('bat --paging=always ' .. vim.fn.shellescape(filepath))
end, { nargs = '?' })

-- Spawn Superfile (spf) in new Wezterm window
-- Usage:
--   :SpawnSpf             -> Runs 'spf' in current directory
--   :SpawnSpf ~/projects  -> Runs 'spf ~/projects'
vim.api.nvim_create_user_command('SpawnSpf', function(opts)
  local target = opts.args ~= '' and 'spf ' .. opts.args or 'spf'
  wezterm_spawn_and_send(target .. ';exit')
end, { nargs = '?' })

-- Spawn `glow` for a file in new WezTerm window
-- Usage:
--   :SpawnGlow             -> Runs 'glow --line-numbers --tui' in root Git directory
--   :SpawnGlow ~/file.md   -> Runs 'glow --line-numbers --tui' on ~/file.md
local glow_pane_id = nil
local glow_has_window = false

local function _lua_shellescape(s)
  if s == nil or s == '' then return "''" end
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- Helper to check if a given WezTerm pane_id is alive
local function check_pane_alive(pane_id, cb)
  if not pane_id or pane_id == '' then cb(false) return end
  vim.system({'wezterm','cli','list'}, { text = true }, function(res)
    if res.code == 0 and res.stdout and res.stdout:find('%f[%d]' .. pane_id .. '%f[%D]') then
      cb(true)
    else
      cb(false)
    end
  end)
end

vim.api.nvim_create_user_command('SpawnGlow', function(opts)
  local filepath = opts.args ~= '' and opts.args or ''
  local git_root = vim.trim(vim.fn.system { 'git', 'rev-parse', '--show-toplevel' })
  local cwd = vim.v.shell_error == 0 and git_root or '.'

  local function spawn_new()
    vim.system({'wezterm','cli','spawn','--new-window','--cwd', cwd}, {text=true}, function(spawn_res)
      local pane_id = vim.trim(spawn_res.stdout)
      if pane_id ~= '' then
        glow_pane_id = pane_id
        glow_has_window = true
        local cmd = filepath ~= '' and ('glow --line-numbers --tui ' .. _lua_shellescape(filepath)) or 'glow --line-numbers --tui'
        wezterm_spawn_and_send(cmd, pane_id)
      else
        glow_pane_id = nil
        glow_has_window = false
        vim.notify("Failed to spawn new Glow window", vim.log.levels.ERROR)
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
        vim.notify("Glow pane was closed. Re-spawning.", vim.log.levels.INFO)
        spawn_new()
      end
    end)
  else
    spawn_new()
  end
end, { nargs = '?' })

-- Spawn a new Wezterm window with no command
vim.api.nvim_create_user_command('SpawnTerm', function()
  vim.system({
    'wezterm', 'cli', 'spawn',
    '--new-window',
    '--cwd', '.',
  }, { text = true })
end, {})

-- set local nowrap
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'csv', 'log' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- set tab settings for SQL files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sql',
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
    if vim.api.nvim_buf_get_option(buf, 'filetype') == 'terminal' then
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
