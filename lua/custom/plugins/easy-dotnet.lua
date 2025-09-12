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
    ft = { 'cs', 'razor' },
    dependencies = {
      {
        'tris203/rzls.nvim',
        config = true,
      },
    },
    config = function()
      -- Adjust these paths to where you installed Roslyn and rzls.
      -- local roslyn_base_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'roslyn')
      -- local rzls_base_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'rzls')
      local mason_registry = require 'mason-registry'

      local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
      local cmd = {
        'roslyn',
        '--stdio',
        '--logLevel=Information',
        '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
        '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
        '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
        '--extension',
        vim.fs.joinpath(rzls_path, 'RazorExtension', 'Microsoft.VisualStudioCode.RazorExtension.dll'),
      }

      -- local cmd = {
      --   'dotnet',
      --   vim.fs.joinpath(roslyn_base_path, 'Microsoft.CodeAnalysis.LanguageServer.dll'),
      --   '--stdio',
      --   '--logLevel=Information',
      --   '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
      --   '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_base_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
      --   '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_base_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
      -- }
      vim.lsp.config('roslyn', {
        cmd = {
          'dotnet',
          'C:/Users/eduar/AppData/Local/nvim-data/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--stdio',
        },
        -- cmd = cmd,
        handlers = require 'rzls.roslyn_handlers',
        on_attach = function(client, _)
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
    init = function()
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
}
