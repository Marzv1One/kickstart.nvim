local M = {}

M.open = function()
  require('fzf-lua').fzf_exec('fd --type d', {
    prompt = 'Oil> ',
    winopts = {
      height = 0.5,
      width = 0.6,
    },
    actions = {
      ['enter'] = function(selected)
        vim.cmd(string.format('Oil %s', selected[1]))
      end,
      ['ctrl-y'] = function(selected)
        vim.cmd(string.format('Oil %s', selected[1]))
      end,
    },
  })
end

return M
