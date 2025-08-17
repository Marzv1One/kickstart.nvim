return {
  'glepnir/dashboard-nvim',
  enabled = true,
  event = 'VimEnter',
  opts = function()
    local version = vim.version()
    local metatable = require 'custom.tables.headers'
    local banner_name
    local img_name
    -- local banner_name = 'def_leppard'
    -- banner_name = 'bloody'
    -- local banner_name = 'slant_relief'
    -- banner_name = 'sharp'
    -- banner_name = 'ansi_shadow'
    -- banner_name = 'dos_rebel'
    -- banner_name = 'lean'
    -- local banner_name = 'morse'
    img_name = 'cacodemon'
    -- local banner_name

    --- @return { header_table: table, padding: { top: number, bottom: number } }
    local get_header_padding = function()
      if type(banner_name) == 'string' then
        local header_table = metatable.banners[banner_name]
        local get_padding = function()
          if banner_name == 'def_leppard' then
            return { top = 6, bottom = 13 }
          end
          if banner_name == 'bloody' then
            return { top = 9, bottom = 15 }
          end
          if banner_name == 'morse' then
            return { top = 13, bottom = 20 }
          end
          if banner_name == 'lean' then
            return { top = 16, bottom = 13 }
          end
          if banner_name == 'slant_relief' then
            return { top = 7, bottom = 18 }
          end
          if banner_name == 'ansi_shadow' then
            return { top = 5, bottom = 23 }
          end
          if banner_name == 'sharp' then
            return { top = 12, bottom = 14 }
          end
          if banner_name == 'dos_rebel' then
            return { top = 12, bottom = 14 }
          end
        end
        local padding = get_padding()
        return { header_table = header_table, padding = padding }
      elseif type(img_name) == 'string' then
        local header_table = metatable.imgs[img_name]
        local get_padding = function()
          if img_name == 'cacodemon' then
            return { top = 1, bottom = 1 }
          end
        end
        local padding = get_padding()
        return { header_table = header_table, padding = padding }
      end
      return { top = 0, bottom = 0 }
    end

    local header_padding = get_header_padding()
    local logo, padding = header_padding.header_table, header_padding.padding
    local top, bottom = padding.top, padding.bottom
    for i = 1, top do
      table.insert(logo, 1, '')
    end
    for i = 1, bottom do
      table.insert(logo, '')
    end

    local nvim_version = '' .. 'N E O V I M - v ' .. version.major .. '.' .. version.minor
    table.insert(logo, nvim_version)
    table.insert(logo, '')

    local center = {
      {
        desc = 'Config',
        keymap = '',
        key = 'h',
        icon = '  ',
        action = 'LoadConfigSession',
      },
      {
        desc = 'Load Session',
        keymap = '',
        key = 'c',
        icon = '  ',
        action = 'Persisted',
      },
      {
        desc = 'Explore',
        keymap = '',
        key = 'r',
        icon = '  ',
        action = 'FzfDirs',
      },
      {
        desc = 'Recents',
        keymap = '',
        key = 's',
        icon = '  ',
        action = 'FzfLua oldfiles',
      },
      {
        desc = 'Exit',
        keymap = '',
        key = 'q',
        icon = '  ',
        action = 'exit',
      },
    }
    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        -- header = vim.split(logo, '\n'),
        header = logo,
          -- stylua: ignore
        center = center,
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    return opts
  end,
}
