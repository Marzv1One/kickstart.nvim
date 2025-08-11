-- Spelling
vim.o.spelllang = 'en_us'
-- vim.o.spelllang = { 'en_us', 'es' }
vim.o.spell = true

vim.diagnostic.config {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅘',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}

vim.g.vsnip_snippet_dirs = { 'C:\\Users\\eduar\\AppData\\Local\\nvim\\snippets' }
