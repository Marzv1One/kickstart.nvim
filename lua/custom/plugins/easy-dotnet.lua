return {
  -- lazy.nvim
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
    config = function()
      require('easy-dotnet').setup()
    end,
  },
}
