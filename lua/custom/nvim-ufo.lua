local M = {}

---@param bufnr integer
local is_enable = function(bufnr)
  -- local bufnr = vim.api.nvim_get_current_buf()
  local status = require('ufo.main').inspectBuf(bufnr)
  if not status then
    return
  end
  local is_enable = status[2]
  is_enable = is_enable:gsub('Fold Status: ', '')
  return is_enable == 'start'
end
local disable_if_enable = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enable = is_enable(bufnr)
  if enable then
    require('ufo').disableFold(bufnr)
  end
end
local enable_if_disable = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enable = is_enable(bufnr)
  if not enable then
    require('ufo').enableFold(bufnr)
  end
end
-- local toggle_disable = function()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local is_enable = is_enable(bufnr)
--   if is_enable then
--     require('ufo').disableFold(bufnr)
--   else
--     require('ufo').enableFold(bufnr)
--   end
-- end

function M.l()
  disable_if_enable()
  require('origami').l()
end
function M.zo()
  disable_if_enable()
  vim.cmd 'normal zo'
end
function M.zO()
  disable_if_enable()
  vim.cmd 'normal zO'
end
function M.h()
  local col = vim.fn.col '.'
  local non_blank = vim.api.nvim_get_current_line():match('^%s*'):len() + 1
  if col <= non_blank then
    enable_if_disable()
  end
  require('origami').h()
end
return M
