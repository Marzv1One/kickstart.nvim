-- Convert visually selected \uXXXX to Unicode character using vim.fn.nr2char
local function convert_unicode_visual()
  local line_start = vim.fn.line "'<"
  local line_end = vim.fn.line "'>"
  local col_start = vim.fn.col "'<"
  local col_end = vim.fn.col "'>"

  for line_num = line_start, line_end do
    local line = vim.fn.getline(line_num)
    local start_col = line_num == line_start and col_start - 1 or 0
    local end_col = line_num == line_end and col_end or #line

    local prefix = line:sub(1, start_col)
    local target = line:sub(start_col + 1, end_col)
    local suffix = line:sub(end_col + 1)

    -- Replace \uXXXX with actual Unicode char
    local converted = target:gsub('\\u([%x][%x][%x][%x])', function(hex)
      local codepoint = tonumber('0x' .. hex)
      if codepoint and codepoint >= 0 and codepoint <= 0x10FFFF then
        return vim.fn.nr2char(codepoint, true) -- true = UTF-8 mode
      else
        return '\\u' .. hex -- preserve invalid
      end
    end)

    vim.fn.setline(line_num, prefix .. converted .. suffix)
  end

  -- Reselect the visual selection
  vim.cmd 'normal! gv'
end

-- Map to <Leader>u in visual mode
vim.keymap.set('x', '<Leader>u', convert_unicode_visual, { desc = 'Convert \\uXXXX to Unicode char' })
