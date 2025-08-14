local actions = require 'fzf-lua.actions'
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
      helptags = {
        actions = {
          ['ctrl-y'] = actions.help,
          ['enter'] = actions.help,
        },
      },
      builtin = {
        actions = {
          ['ctrl-y'] = actions.run_builtin,
          ['enter'] = actions.run_builtin,
        },
      },
      marks = {
        actions = {
          ['ctrl-y'] = actions.goto_mark,
          ['enter'] = actions.goto_mark,
        },
      },
      jumps = {
        actions = {
          ['ctrl-y'] = actions.goto_jump,
          ['enter'] = actions.goto_jump,
        },
      },
      registers = {
        actions = {
          ['ctrl-y'] = actions.paste_register,
          ['enter'] = actions.paste_register,
        },
      },
      keymaps = {
        actions = {
          ['ctrl-y'] = actions.keymap_apply,
          ['enter'] = actions.keymap_apply,
        },
      },
      spell_suggest = {
        actions = {
          ['ctrl-y'] = actions.spell_apply,
          ['enter'] = actions.spell_apply,
        },
      },
      filetypes = {
        actions = {
          ['ctrl-y'] = actions.set_filetype,
          ['enter'] = actions.set_filetype,
        },
      },
      search_history = {
        actions = {
          ['ctrl-y'] = actions.search_cr,
          ['enter'] = actions.search_cr,
        },
      },
      commands = {
        actions = {
          ['ctrl-y'] = actions.ex_run_cr,
          ['enter'] = actions.ex_run_cr,

          ['ctrl-e'] = actions.ex_run,
        },
      },
      command_history = {
        actions = {
          ['ctrl-y'] = actions.ex_run_cr,
          ['enter'] = actions.ex_run_cr,
        },
      },
      actions = {
        files = {
          ['ctrl-y'] = actions.file_edit_or_qf,
          ['enter'] = actions.file_edit_or_qf,
          ['ctrl-v'] = actions.file_vsplit,
          ['alt-q'] = actions.file_sel_to_qf,
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
      map('n', '<leader>fb', require('fzf-lua').builtin, { desc = 'Builtin' })
      map('n', '<leader>fw', require('fzf-lua').grep_cword, { desc = 'Grep Word' })
      map('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fd', require('fzf-lua').diagnostics_document, { desc = 'Diagnostics' })
      map('n', '<leader>fr', require('fzf-lua').resume, { desc = 'Resume' })
      map('n', '<leader>f.', require('fzf-lua').oldfiles, { desc = 'Old Files' })
      map('n', '<leader><leader>', require('fzf-lua').buffers, { desc = 'Buffers' })
      map('n', '<leader>/', require('fzf-lua').blines, { desc = 'Buffer Lines' })
      map('n', '<leader>f/', require('fzf-lua').lines, { desc = 'Lines' })
      map('n', '<leader>fn', function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'NeoVim Files' })
      map('n', '<leader>fc', require('fzf-lua').commands, { desc = 'Commands' })
      map('n', '<leader>fq', require('fzf-lua').quickfix, { desc = 'Quickfix' })
      map('n', '<leader>fl', require('fzf-lua').loclist, { desc = 'Loclist' })
      map('n', '<leader>fm', require('fzf-lua').marks, { desc = 'Marks' })
      map('n', '<leader>fs', require('fzf-lua').search_history, { desc = 'Search History' })
      map('n', '<leader>fx', require('fzf-lua').command_history, { desc = 'Command History' })
      map('n', '<leader>fj', require('fzf-lua').jumps, { desc = 'Jumps' })
      map('n', '<leader>fy', require('fzf-lua').registers, { desc = 'Registers' })
      map('n', '<leader>fz', require('fzf-lua').spell_suggest, { desc = 'Spell Suggest' })

      -- FzfLua Git keymaps
      map('n', '<leader>gf', require('fzf-lua').git_files, { desc = 'Git Files' })
      map('n', '<leader>gc', require('fzf-lua').git_commits, { desc = 'Git Commits' })
      map('n', '<leader>gb', require('fzf-lua').git_bcommits, { desc = 'Git Buffer Commits' })
      map('n', '<leader>gs', require('fzf-lua').git_status, { desc = 'Git Status' })
      map('n', '<leader>gd', require('fzf-lua').git_diff, { desc = 'Git Diff' })
      map('n', '<leader>gh', require('fzf-lua').git_hunks, { desc = 'Git Hunks' })
      map('n', '<leader>gl', require('fzf-lua').git_branches, { desc = 'Git Branches' })
      map('n', '<leader>gt', require('fzf-lua').git_stash, { desc = 'Git Stash' })
      map('n', '<leader>gn', require('fzf-lua').git_blame, { desc = 'Git Blame' })

      -- local function get_named_buffers()
      --   local buffers = vim.api.nvim_list_bufs()
      --   local listed_buffers = {}
      --   for _, buf in ipairs(buffers) do
      --     local ok, buflisted = pcall(vim.api.nvim_get_option_value, 'buflisted', { buf = buf })
      --     if vim.api.nvim_buf_get_option(buf, 'buflisted') then
      --       table.insert(listed_buffers, buf)
      --     end
      --   end
      --   return listed_buffers
      -- end
      --
      -- map('n', '<leader>f/', function(opts_local)
      --   -- local fzf = require 'fzf-lua'
      --   opts_local = opts_local or {}
      --   opts_local.cwd = '.'
      --   opts_local.prompt = 'Rg> '
      --   opts_local.get_icons = true
      --   opts_local.file_icons = true
      --   opts_local.color_icons = true
      --
      --   -- opts.actions = fzf_lua.defaults.actions.files
      --   opts_local.actions = {
      --     ['enter'] = fzf.actions.file_edit,
      --     ['ctrl-y'] = fzf.actions.file_edit,
      --     ['ctrl-v'] = fzf.actions.file_vsplit,
      --   }
      --   opts_local.previewer = 'builtin'
      --   -- opts_local.fn_transform = function(x)
      --   --   return fzf.make_entry.file(x, opts_local)
      --   -- end
      --
      --   local open_buffers = get_named_buffers()
      --   local glob_array = {}
      --   for _, buf in ipairs(open_buffers) do
      --     local buf_name = vim.api.nvim_buf_get_name(buf)
      --     local relative_path = vim.fn.fnamemodify(buf_name, ':.')
      --     relative_path = vim.fn.tr(relative_path, '\\', '/')
      --     table.insert(glob_array, '--glob=' .. relative_path)
      --   end
      --
      --   -- print(vim.inspect(glob_array))
      --
      --   opts_local.rg_opts = '--column --line-number --no-heading --color=always --smart-case ' .. table.concat(glob_array, ' ')
      --   fzf.live_grep(opts_local)
      -- end)
    end,
  },
}
