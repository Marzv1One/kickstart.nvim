return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'ghost',
      }
      vim.diagnostic.config { virtual_text = false } -- Disable default virtual text
    end,
  },
  {
    'rachartier/tiny-devicons-auto-colors.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'VeryLazy',
    opts = {},
    -- config = function()
    --     require('tiny-devicons-auto-colors').setup()
    -- end
  },
  {
    -- 'rachartier/tiny-glimmer.nvim',
    dir = 'D:\\external-repos\\tiny-glimmer.nvim',
    name = 'tiny-glimmer.nvim',
    enabled = true,
    dependencies = {
      'gbprod/yanky.nvim',
    },
    event = 'VeryLazy',
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
      overwrite = {
        paste = {
          default_animation = {
            name = 'reverse_fade',
            settings = {
              from_color = 'Substitute',
              to_color = 'Visual',
            },
          },
        },
        yank = {
          default_animation = {
            name = 'fade',
            settings = {
              from_color = 'Substitute',
              to_color = 'Visual',
            },
          },
        },
        search = {
          enabled = true,
          default_animation = {
            name = 'pulse',
            settings = {
              from_color = 'Substitute',
              to_color = 'Visual',
            },
          },
        },
        undo = {
          enabled = true,
          default_animation = {
            name = 'fade',

            settings = {
              from_color = 'Visual',
              to_color = 'DiffDelete',

              max_duration = 500,
              min_duration = 500,
            },
          },
        },
        redo = {
          enabled = true,
          default_animation = {
            name = 'fade',

            settings = {
              from_color = 'DiffAdd',
              to_color = 'Visual',

              max_duration = 500,
              min_duration = 500,
            },
          },
        },
      },
      support = {
        substitute = {
          enabled = true,
          default_animation = {
            name = 'reverse_fade',
            settings = {
              from_color = 'Substitute',
              to_color = 'Visual',
            },
          },
        },
      },
      presets = {
        pulsar = {
          enabled = true,
        },
      },
      transparency_color = '#1F1F28',
      animations = {
        -- fade = {
        --   max_duration = 400,
        --   min_duration = 300,
        --   easing = 'outQuad',
        --   chars_for_max_duration = 10,
        --   from_color = 'Substitute',
        --   to_color = 'Visual',
        -- },
        -- reverse_fade = {
        --   max_duration = 380,
        --   min_duration = 300,
        --   easing = 'outBack',
        --   chars_for_max_duration = 10,
        --   from_color = 'Substitute',
        --   to_color = 'Visual',
        -- },
        -- flash = {
        --   max_duration = 600,
        --   min_duration = 400,
        --   chars_for_max_duration = 15,
        --   pulse_count = 2,
        --   intensity = 1.2,
        --   from_color = 'Visual',
        --   to_color = 'Substitute',
        -- },
        -- pulse = {
        --   max_duration = 600,
        --   min_duration = 400,
        --   chars_for_max_duration = 15,
        --   pulse_count = 2,
        --   intensity = 1.2,
        --   from_color = '#1F1F28',
        --   to_color = 'Substitute',
        -- },
      },
    },
  },
}
