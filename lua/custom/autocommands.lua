vim.api.nvim_create_user_command('UnescapeUnicode', function()
  vim.cmd "%s/\\\\u\\([0-9a-fA-F]\\{4\\}\\)/\\=nr2char('0x' . submatch(1))/g"
end, {})
