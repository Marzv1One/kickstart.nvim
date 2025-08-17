-- Spelling
vim.o.spelllang = 'en_us'
-- vim.o.spelllang = { 'en_us', 'es' }
vim.o.spell = true

-- Set multiple PowerShell-related environment variables
local function setup_pwsh_env()
  local vars = {
    profile = '$profile',
    home = '$env:USERPROFILE',
  }

  for key, var in pairs(vars) do
    local handle = io.popen('pwsh -NonInteractive -NoProfile -Command "& { Write-Output ' .. var .. '}"')
    if handle == nil then
      print('No ' .. key .. ' found')
    else
      local value = handle:read '*a'
      handle:close()
      if value ~= nil then
        value = value:gsub('[\r\n]', '')
        vim.env[key] = value
      end
    end
  end
end

setup_pwsh_env()

package.path = package.path .. ';' .. vim.fn.stdpath 'config' .. '/after/?.lua'
-- print(vim.inspect(home_dir))
