return {
  {
    -- 'Piotr1215/beam.nvim',
    dir = 'D:\\external-repos\\beam.nvim',
    name = 'beam.nvim',
    config = function()
      local beam = require 'beam'
      beam.setup {
        prefix = 'gz', -- Your prefix key (mini-leader)
        visual_feedback_duration = 150, -- ms to show selection
        clear_highlight = true, -- Clear search highlight after operation
        clear_highlight_delay = 500, -- ms before clearing
        cross_buffer = false, -- Enable cross-buffer operations
        auto_discover_text_objects = true, -- Auto-discover all available text objects
        show_discovery_notification = true, -- Show notification about discovered objects
        excluded_text_objects = {}, -- Exclude specific text objects (e.g., {'q', 'z'})
        excluded_motions = {}, -- Exclude specific motions (e.g., {'Q', 'R'})
        custom_text_objects = {
          ['q'] = 'quotes',
          -- ['q'] = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
        },
      }
    end,
  },
}
