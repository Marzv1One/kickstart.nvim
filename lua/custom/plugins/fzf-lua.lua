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
        on_create = function()
          vim.cmd 'silent !glazewm command wm-toggle-pause'
        end,
        on_close = function()
          vim.cmd 'silent !glazewm command wm-toggle-pause'
          vim.api.nvim_exec_autocmds('User', {
            pattern = '*:*',
          })
        end,
      },
      actions = {
        files = {
          ['ctrl-y'] = actions.file_edit_or_qf,
          ['enter'] = actions.file_edit_or_qf,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          ['alt-q'] = actions.file_sel_to_qf,
          ['alt-Q'] = actions.file_sel_to_ll,
          ['alt-i'] = actions.toggle_ignore,
          ['alt-h'] = actions.toggle_hidden,
          ['alt-f'] = actions.toggle_follow,
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
          ['ctrl-f'] = 'half-page-down',
          ['ctrl-b'] = 'half-page-up',
          ['alt-a'] = 'toggle-all',
          ['alt-g'] = 'first',
          ['alt-G'] = 'last',
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
      highlights = {
        actions = {
          ['ctrl-y'] = actions.hi,
          ['enter'] = actions.hi,
        },
      },
      git = {
        status = {
          actions = {
            ['alt-l'] = { fn = actions.git_unstage, reload = true },
            ['alt-h'] = { fn = actions.git_stage, reload = true },
          },
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
      local fzf = require 'fzf-lua'

      local fullscreen_winopts = {
        winopts = {
          fullscreen = true,
          preview = {
            layout = 'vertical',
            vertical = 'up:70%',
          },
        },
      }

      map('n', '<leader>fh', fzf.helptags, { desc = 'Help Tags' })
      map('n', '<leader>fk', fzf.keymaps, { desc = 'Keymaps' })
      map('n', '<leader>ff', fzf.files, { desc = 'Files' })
      map('n', '<leader>fb', fzf.builtin, { desc = 'Builtin' })
      map('n', '<leader>fw', fzf.grep_cword, { desc = 'Grep Word' })
      map('n', '<leader>fg', fzf.live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Diagnostics' })
      map('n', '<leader>fr', fzf.resume, { desc = 'Resume' })
      map('n', '<leader>f.', fzf.oldfiles, { desc = 'Old Files' })
      map('n', '<leader><leader>', fzf.buffers, { desc = 'Buffers' })
      map('n', '<leader>/', fzf.blines, { desc = 'Buffer Lines' })
      map('n', '<leader>f/', fzf.lines, { desc = 'Lines' })
      map('n', '<leader>fn', function()
        fzf.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'NeoVim Files' })
      map('n', '<leader>fc', fzf.commands, { desc = 'Commands' })
      map('n', '<leader>fq', fzf.quickfix, { desc = 'Quickfix' })
      map('n', '<leader>fl', fzf.loclist, { desc = 'Loclist' })
      map('n', '<leader>fm', fzf.marks, { desc = 'Marks' })
      map('n', '<leader>fs', fzf.search_history, { desc = 'Search History' })
      map('n', '<leader>fx', fzf.command_history, { desc = 'Command History' })
      map('n', '<leader>fj', fzf.jumps, { desc = 'Jumps' })
      map('n', '<leader>fp', fzf.registers, { desc = 'Registers' })
      map('n', '<leader>fz', fzf.spell_suggest, { desc = 'Spell Suggest' })
      map('n', '<leader>fW', fzf.grep_cWORD, { desc = 'Grep WORD' })
      map('n', '<leader>fi', fzf.highlights, { desc = 'Highlights' })
      map('n', '<leader>fe', fzf.grep_quickfix, { desc = 'Grep Quickfix' })
      map('v', '<leader>fw', fzf.grep_visual, { desc = 'Grep Visual' })

      -- FzfLua Git keymaps
      map('n', '<leader>gf', fzf.git_files, { desc = 'Git Files' })
      map('n', '<leader>gc', fzf.git_commits, { desc = 'Git Commits' })
      map('n', '<leader>gb', function()
        fzf.git_bcommits(fullscreen_winopts)
      end, { desc = 'Git Buffer Commits' })
      map('n', '<leader>gs', function()
        fzf.git_status(fullscreen_winopts)
      end, { desc = 'Git Status' })
      map('n', '<leader>gd', function()
        fzf.git_diff(fullscreen_winopts)
      end, { desc = 'Git Diff' })
      map('n', '<leader>gh', fzf.git_hunks, { desc = 'Git Hunks' })
      map('n', '<leader>gl', fzf.git_branches, { desc = 'Git Branches' })
      map('n', '<leader>gt', fzf.git_stash, { desc = 'Git Stash' })
      map('n', '<leader>gn', fzf.git_blame, { desc = 'Git Blame' })

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
