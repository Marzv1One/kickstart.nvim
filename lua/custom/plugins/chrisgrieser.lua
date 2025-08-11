return {
  {
    'chrisgrieser/nvim-spider',
    keys = {
      { 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
      { 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
      { 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
      { 'ge', "<cmd>lua require('spider').motion('ge')<CR>", mode = { 'n', 'o', 'x' } },
    },
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {}, -- needed even when using default config
  },
  {
    'chrisgrieser/nvim-scissors',
    cmd = {
      'ScissorsAddNewSnippet',
      'ScissorsEditSnippet',
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      -- 'garymjr/nvim-snippets',
    },
    config = function()
      require('scissors').setup {
        -- snippetDir = 'C:\\Users\\SinerLuis\\AppData\\Local\\nvim\\snippets',
        snippetDir = vim.g.vsnip_snippet_dirs[1],
        editSnippetPopup = {
          keymaps = {
            saveChanges = '<Space>w',
            duplicateSnippet = '<C-b>',
            deleteSnippet = '<C-d>',
          },
        },
      }
    end,
  },
  {
    dir = 'C:\\Users\\eduar\\AppData\\Local\\nvim\\lua\\custom\\nvim-dr-lsp\\',
    name = 'nvim-dr-lsp.nvim',
    event = 'LspAttach',
    config = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LspRequestDR',
        callback = function(args)
          -- require 'notify'(vim.inspect(args))
          local bufClients = vim.lsp.get_clients { bufnr = args.buf }
          local lspProgress = vim.lsp.status()
          local lspLoading = lspProgress:find '[Ll]oad'
          local lspCabable = false

          for _, client in pairs(bufClients) do
            local capable = client.server_capabilities or {}
            if capable.referencesProvider and capable.definitionProvider then
              lspCabable = true
            end
          end
          if vim.api.nvim_get_mode().mode ~= 'n' or lspLoading or not lspCabable then
            return nil
          end

          -- trigger count, abort when done
          -- requestLspRefCount()
          require('dr-lsp.statusline').run()
        end,
      })
    end,
  },
}
