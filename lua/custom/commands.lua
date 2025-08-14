-- Unescape Unicode
vim.api.nvim_create_user_command('UnescapeUnicode', function()
  -- Match \uXXXX, \u{XXXX}, and \uXX formats
  vim.cmd "%s/\\\\u\\({[0-9a-fA-F]\\+}\\|\\([0-9a-fA-F]\\{4\\}\\|[0-9a-fA-F]\\{2\\}\\)\\)/\\=nr2char('0x' . substitute(submatch(1), '{\\|}', '', 'g'))/g"
end, {})

-- Spawn Crush in new Wezterm window
vim.api.nvim_create_user_command('SpawnCrush', function()
  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    '.',
  }, { text = true }, function(spawn_res)
    local pane_id = vim.trim(spawn_res.stdout)
    if pane_id ~= '' then
      vim.system({
        'wezterm',
        'cli',
        'send-text',
        '--pane-id',
        pane_id,
        'crush;exit\n',
      }, { text = true })
    end
  end)
end, {})

-- Spawn Lazygit in new Wezterm window
vim.api.nvim_create_user_command('SpawnLazygit', function()
  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    '.',
  }, { text = true }, function(spawn_res)
    local pane_id = vim.trim(spawn_res.stdout)
    if pane_id ~= '' then
      vim.system({
        'wezterm',
        'cli',
        'send-text',
        '--pane-id',
        pane_id,
        'lazygit;exit\n',
      }, { text = true })
    end
  end)
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

  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    '.',
  }, { text = true }, function(spawn_res)
    local pane_id = vim.trim(spawn_res.stdout)
    if pane_id ~= '' then
      vim.system({
        'wezterm',
        'cli',
        'send-text',
        '--pane-id',
        pane_id,
        'bat --paging=always ' .. filepath .. ';exit\n',
      }, { text = true })
    end
  end)
end, { nargs = '?' })

-- Spawn Superfile (spf) in new Wezterm window
-- Usage:
--   :SpawnSpf             -> Runs 'spf' in current directory
--   :SpawnSpf ~/projects  -> Runs 'spf ~/projects'
vim.api.nvim_create_user_command('SpawnSpf', function(opts)
  local target = opts.args ~= '' and 'spf ' .. opts.args or 'spf'

  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    '.',
  }, { text = true }, function(spawn_res)
    local pane_id = vim.trim(spawn_res.stdout)
    if pane_id ~= '' then
      vim.system({
        'wezterm',
        'cli',
        'send-text',
        '--pane-id',
        pane_id,
        target .. ';exit\n',
      }, { text = true })
    end
  end)
end, { nargs = '?' })

-- Spawn `glow` for a file in new Wezterm window
-- Usage:
--   :SpawnGlow             -> Runs 'glow --line-numbers tui' in root Git directory
--   :SpawnGlow ~/file.md   -> Runs 'glow --line-numbers tui' on ~/file.md
vim.api.nvim_create_user_command('SpawnGlow', function(opts)
  local filepath = opts.args ~= '' and opts.args or ''
  local git_root = vim.trim(vim.fn.system { 'git', 'rev-parse', '--show-toplevel' })
  local cwd = vim.v.shell_error == 0 and git_root or '.'

  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    cwd,
  }, { text = true }, function(spawn_res)
    local pane_id = vim.trim(spawn_res.stdout)
    if pane_id ~= '' then
      local cmd = filepath ~= '' and 'glow --line-numbers tui ' .. filepath or 'glow --line-numbers tui'
      vim.system({
        'wezterm',
        'cli',
        'send-text',
        '--pane-id',
        pane_id,
        cmd .. ';exit\n',
      }, { text = true })
    end
  end)
end, { nargs = '?' })

-- Spawn a new Wezterm window with no command
vim.api.nvim_create_user_command('SpawnTerm', function()
  vim.system({
    'wezterm',
    'cli',
    'spawn',
    '--new-window',
    '--cwd',
    '.',
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
