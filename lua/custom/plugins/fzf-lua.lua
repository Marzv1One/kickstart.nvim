return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      winopts = {
        preview = {
          default = 'bat',
        },
      },
      keymap = {
        builtin = {
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',
        },
      },
      lsp = {
        code_actions = {
          previewer = 'codeaction_native',
        },
      },
    },
    config = function(_, opts)
      local fzf = require 'fzf-lua'
      fzf.setup(opts)

      fzf.register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)

      local map = vim.keymap.set

      map('n', '<leader>fh', require('fzf-lua').helptags, { desc = 'Help Tags' })
      map('n', '<leader>fk', require('fzf-lua').keymaps, { desc = 'Keymaps' })
      map('n', '<leader>ff', require('fzf-lua').files, { desc = 'Files' })
      map('n', '<leader>fs', require('fzf-lua').builtin, { desc = 'Builtin' })
      map('n', '<leader>fw', require('fzf-lua').grep_cword, { desc = 'Grep Word' })
      map('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fd', require('fzf-lua').diagnostics_document, { desc = 'Diagnostics' })
      map('n', '<leader>fr', require('fzf-lua').resume, { desc = 'Resume' })
      map('n', '<leader>f.', require('fzf-lua').oldfiles, { desc = 'Old Files' })
      map('n', '<leader><leader>', require('fzf-lua').buffers, { desc = 'Buffers' })
      map('n', '<leader>/', require('fzf-lua').lines, { desc = 'Lines' })
      map('n', '<leader>fn', function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'NeoVim Files' })

      local function get_named_buffers()
        local buffers = vim.api.nvim_list_bufs()
        local named_buffers = {}
        for _, buf in ipairs(buffers) do
          local name = vim.api.nvim_buf_get_name(buf)
          -- if name ~= '' then
          if vim.api.nvim_buf_get_option(buf, 'buflisted') then
            table.insert(named_buffers, buf)
          end
        end
        return named_buffers
      end

      map('n', '<leader>f/', function(opts_local)
        -- local fzf = require 'fzf-lua'
        opts_local = opts_local or {}
        opts_local.cwd = '.'
        opts_local.prompt = 'Rg> '
        opts_local.get_icons = true
        opts_local.file_icons = true
        opts_local.color_icons = true

        -- opts.actions = fzf_lua.defaults.actions.files
        opts_local.actions = {
          ['enter'] = fzf.actions.file_edit,
          ['ctrl-y'] = fzf.actions.file_edit,
          ['ctrl-v'] = fzf.actions.file_vsplit,
        }
        opts_local.previewer = 'builtin'
        -- opts_local.fn_transform = function(x)
        --   return fzf.make_entry.file(x, opts_local)
        -- end

        local open_buffers = get_named_buffers()
        local glob_array = {}
        for _, buf in ipairs(open_buffers) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          local relative_path = vim.fn.fnamemodify(buf_name, ':.')
          relative_path = vim.fn.tr(relative_path, '\\', '/')
          table.insert(glob_array, '--glob=' .. relative_path)
        end

        print(vim.inspect(glob_array))

        opts_local.rg_opts = '--column --line-number --no-heading --color=always --smart-case ' .. table.concat(glob_array, ' ')
        fzf.live_grep(opts_local)
      end)
    end,
  },
}
