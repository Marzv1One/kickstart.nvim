-- Unescape Unicode
vim.api.nvim_create_user_command('UnescapeUnicode', function()
  vim.cmd "%s/\\\\u\\([0-9a-fA-F]\\{4\\}\\)/\\=nr2char('0x' . submatch(1))/g"
end, {})

-- set local nowrap
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'csv', 'log' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})
