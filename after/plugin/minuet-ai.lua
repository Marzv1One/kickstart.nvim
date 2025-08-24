local minuet_group = vim.api.nvim_create_augroup('MinuetRequest', { clear = true })

vim.api.nvim_create_autocmd('User', {
  pattern = 'MinuetRequestStartedPre',
  group = minuet_group,
  callback = function(args)
    -- print(vim.inspect(args))
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MinuetRequestFinished',
  group = minuet_group,
  callback = function()
    -- print(vim.inspect(args))
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MinuetRequestStarted',
  group = minuet_group,
  callback = function(args)
    -- print(vim.inspect(args))
  end,
})
