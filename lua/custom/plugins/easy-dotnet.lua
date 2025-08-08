return {
  -- lazy.nvim
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
    config = function()
      require('easy-dotnet').setup()
    end,
  },
  -- roslyn.nvim
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
    config = function()
      vim.lsp.config('roslyn', {
        cmd = {
          'dotnet',
          'C:/Users/eduar/AppData/Local/nvim-data/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--stdio',
        },
        on_attach = function()
          print 'This will run when the server attaches!'
        end,

        settings = {

          ['csharp|inlay_hints'] = {

            csharp_enable_inlay_hints_for_implicit_object_creation = true,

            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },

          ['csharp|code_lens'] = {

            dotnet_enable_references_code_lens = true,
          },
        },
      })
      vim.lsp.enable 'roslyn'
    end,
  },
}
