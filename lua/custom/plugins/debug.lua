local function rebuild_project(co, path)
  local spinner = require('easy-dotnet.ui-modules.spinner').new()
  spinner:start_spinner 'Building'
  print(vim.inspect(path))
  vim.fn.jobstart(string.format('dotnet build %s', path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner 'Built successfully'
      else
        spinner:stop_spinner('Build failed with exit code ' .. return_code, vim.log.levels.ERROR)
        error 'Build failed'
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

--lazy.nvim
return {
  {
    'mfussenegger/nvim-dap',
    ft = { 'cs' },
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      {
        'igorlfs/nvim-dap-view',
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
      },
    },
    config = function()
      -- vim.opt.shellslash = false
      vim.defer_fn(function()
        vim.opt.shellslash = false
      end, 5000)

      local dap = require 'dap'
      dap.set_log_level 'DEBUG'

      -- Keymaps for controlling the debugger
      vim.keymap.set('n', 'q', function()
        dap.terminate()
        dap.clear_breakpoints()
      end, { desc = 'Terminate and clear breakpoints' })

      local widgets = require 'dap.ui.widgets'

      local map = vim.keymap.set

      map('n', '<leader>dc', dap.continue, { desc = 'Start/continue debugging' })
      map('n', '<leader>do', dap.step_over, { desc = 'Step over' })
      map('n', '<leader>di', dap.step_into, { desc = 'Step into' })
      map('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
      map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      map('n', '<leader>dC', dap.run_to_cursor, { desc = 'Run to cursor' })
      map('n', '<leader>dr', dap.repl.toggle, { desc = 'Toggle DAP REPL' })
      map('n', '<leader>dj', dap.down, { desc = 'Go down stack frame' })
      map('n', '<leader>dk', dap.up, { desc = 'Go up stack frame' })
      map('n', '<leader>dh', widgets.hover, { desc = 'Hover' })
      map('n', '<leader>dp', widgets.preview, { desc = 'Preview' })
      map('n', '<leader>ds', function()
        widgets.centered_float(widgets.scopes)
      end, { desc = 'Scopes' })
      map('n', '<leader>dt', '<cmd>DapViewToggle', { desc = 'Toggle DAP View' })

      -- .NET specific setup using `easy-dotnet`
      require('easy-dotnet.netcoredbg').register_dap_variables_viewer() -- special variables viewer specific for .NET
      local dotnet = require 'easy-dotnet'
      local debug_dll = nil

      local function ensure_dll()
        if debug_dll ~= nil then
          return debug_dll
        end
        local dll = dotnet.get_debug_dll(true)
        debug_dll = dll
        return dll
      end

      for _, value in ipairs { 'cs', 'fsharp' } do
        dap.configurations[value] = {
          {
            type = 'coreclr',
            name = 'Program',
            request = 'launch',
            env = function()
              local dll = ensure_dll()
              local dll_path = dll.relative_dll_path--[[ :gsub('/', '\\') ]]
              local vars = dotnet.get_environment_variables(dll.project_name, dll_path)
              return vars or nil
            end,
            program = function()
              local dll = ensure_dll()
              -- print(vim.inspect(dll))
              local co = coroutine.running()
              rebuild_project(co, dll.project_path)
              return dll.relative_dll_path
            end,
            cwd = function()
              local dll = ensure_dll()
              local dll_path = dll.relative_dll_path--[[ :gsub('/', '\\') ]]
              print(vim.inspect(dll_path))
              return dll_path
            end,
          },
          {
            type = 'coreclr',
            name = 'Test',
            request = 'attach',
            processId = function()
              local res = require('easy-dotnet').experimental.start_debugging_test_project()
              return res.process_id
            end,
          },
        }
      end

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      -- Reset debug_dll after each terminated session
      dap.listeners.before['event_terminated']['easy-dotnet'] = function()
        debug_dll = nil
      end

      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }
    end,
  },
}
