local fzf = require 'fzf-lua'

-- Custom action to copy password to clipboard
local function copy_to_clipboard(selected)
  if not selected or #selected == 0 then
    return
  end

  local password_entry = selected[1]
  local cmd = string.format('gopass --clip %s', vim.fn.shellescape(password_entry))

  -- Execute the command
  local output = vim.fn.system(cmd)

  -- Check if command was successful
  if vim.v.shell_error == 0 then
    vim.notify(output, vim.log.levels.INFO, { title = 'Gopass' })
  else
    vim.notify('Failed to copy password: ' .. password_entry, vim.log.levels.ERROR)
  end
end

-- Configure fzf-lua with gopass entries and custom actions
vim.api.nvim_create_user_command('Gopass', function()
  fzf.fzf_exec('gopass ls --flat', {
    prompt = 'Gopass> ',
    actions = {
      ['enter'] = copy_to_clipboard,
      ['ctrl-y'] = copy_to_clipboard,
    },
    winopts = {
      width = 0.7,
      height = 0.5,
      row = 0.3,
      col = 0.5,
    },
  })
end, {})

-- Add keybinding for gopass command
vim.keymap.set('n', '<leader>pm', '<cmd>Gopass<CR>', { noremap = true, silent = true, desc = 'Gopass' })
