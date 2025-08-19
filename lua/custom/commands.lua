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
--   :SpawnGlow             -> Runs 'glow --line-numbers --tui' in root Git directory
--   :SpawnGlow ~/file.md   -> Runs 'glow --line-numbers --tui' on ~/file.md
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
      local cmd = filepath ~= '' and 'glow --line-numbers --tui ' .. filepath or 'glow --line-numbers --tui'
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

-- vim.api.nvim_create_autocmd('CursorMoved', {
--   group = vim.api.nvim_create_augroup('ScrolloffInfo', { clear = true }),
--   callback = function()
--     local scrolloff = vim.o.scrolloff
--     local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
--     local buf_line_count = vim.api.nvim_buf_line_count(0)
--
--     local topline = vim.fn.line 'w0'
--     local bottomline = vim.fn.line 'w$'
--
--     -- H (High): top of screen + scrolloff (unless at top of file)
--     local H_line
--     if topline == 1 then
--       H_line = 1
--     else
--       H_line = math.min(bottomline, topline + scrolloff)
--     end
--
--     -- M (Middle): actual screen middle (no edge case needed)
--     local M_line = math.floor((topline + bottomline) / 2)
--
--     -- L (Low): bottom of screen - scrolloff (unless at bottom of file)
--     local L_line
--     if bottomline == buf_line_count then
--       L_line = buf_line_count
--     else
--       L_line = math.max(topline, bottomline - scrolloff)
--     end
--
--     -- Compute relative numbers
--     local rel_H = H_line - cursor_line
--     local rel_M = M_line - cursor_line
--     local rel_L = L_line - cursor_line
--
--     -- Echo nicely
--     vim.api.nvim_echo({
--       { string.format('%d', bottomline), 'Normal' },
--       { ' | ', 'Normal' },
--       { string.format('%d', cursor_line), 'Normal' },
--       { ' | ', 'Normal' },
--       { string.format('H: %d (%+d)', H_line, rel_H), 'Normal' },
--       { ' | ', 'Normal' },
--       { string.format('M: %d (%+d)', M_line, rel_M), 'Normal' },
--       { ' | ', 'Normal' },
--       { string.format('L: %d (%+d)', L_line, rel_L), 'Normal' },
--     }, false, {})
--   end,
-- })
