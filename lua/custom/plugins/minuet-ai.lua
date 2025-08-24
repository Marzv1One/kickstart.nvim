return {
  {
    'milanglacier/minuet-ai.nvim',
    enabled = false,
    config = function()
      require('minuet').setup {
        provider = 'openai_compatible',
        request_timeout = 2.5,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits
        provider_options = {
          openai_compatible = {
            api_key = 'OPENROUTER_API_KEY',
            end_point = 'https://openrouter.ai/api/v1/chat/completions',
            -- model = 'qwen/qwen3-30b-a3b-instruct-2507',
            model = 'mistralai/codestral-2508',
            -- model = 'qwen/qwen3-coder',
            name = 'Openrouter',
            optional = {
              max_tokens = 56,
              top_p = 0.9,
              provider = {
                -- Prioritize throughput for faster completion
                sort = 'throughput',
              },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = {
            'lua',
            'python',
            'cs',
          },
          keymap = {
            -- accept whole completion
            accept = '<C-g>',
            -- accept one line
            accept_line = '<C-x>',
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = '<C-k>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<M-c>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<M-n>',
            dismiss = '<C-c>',
          },
        },
      }
    end,
  },
}
