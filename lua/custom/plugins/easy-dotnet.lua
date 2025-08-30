return {
  -- lazy.nvim
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
    config = function()
      require('easy-dotnet').setup {
        get_sdk_path = function()
          return 'C:/Program Files/dotnet/'
        end,
      }
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
        on_attach = function(client, bufnr)
          -- print 'This will run when the server attaches!'
          if client.server_capabilities.foldingRangeProvider then
            vim.api.nvim_set_option_value('foldmethod', 'expr', { scope = 'global' })
            vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.lsp.foldexpr()', { scope = 'global' })
            vim.api.nvim_set_option_value('foldtext', 'v:lua.vim.lsp.foldtext()', { scope = 'global' })
          end
        end,

        settings = {
          ['csharp|background_analysis'] = {
            dotnet_analyzer_diagnostics_scope = 'fullSolution',
            dotnet_compiler_diagnostics_scope = 'fullSolution',
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
          ['csharp|completion'] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
          },
        },
      })
      vim.lsp.enable 'roslyn'
    end,
  },
}
