# CRUSH.md

Repo: Neovim config (Lua) based on kickstart.nvim. Primary tasks: format, lint/diagnostics, health checks, plugin ops.

Commands
- Format (Stylua): stylua .
- Lint (Lua via Neovim diagnostics): nvim --headless "+lua vim.diagnostic.setqflist()" +q; nvim -q quickfix
- Health (all): nvim --headless "+checkhealth" +q
- Health (single module): nvim --headless "+checkhealth <module>" +q (e.g., telescope)
- Plugin sync: nvim --headless "+Lazy! sync" +qa
- Plugin update: nvim --headless "+Lazy! update" +qa
- Startup profile: nvim --startuptime startuptime.log +q; tail -n 50 startuptime.log
- Minimal session: NVIM_APPNAME=nvim-min nvim -u NONE
- Launch with this config: NVIM_APPNAME=nvim nvim

Code style
- Lua 5.1 (Neovim). Use local for module scope; avoid globals. Return tables from modules; require("<ns>.<mod>") for imports.
- Formatting enforced by .stylua.toml (2 spaces, Unix EOL, 160 cols, single quotes, no call parens). Run stylua . before commits.
- Naming: snake_case for vars/functions; UpperCamelCase for module-like tables; constants ALL_CAPS.
- Types: table-first design; annotate with EmmyLua only if .luarc.json permits; prefer explicit fields over magic keys.
- Errors: user-facing via vim.notify; programmer errors via error(); guard optional deps with pcall(require, ...).
- Structure: custom config in lua/custom/{plugins,autocommands,keybinds}; plugin specs via lazy.nvim; keep opts small; one spec per file where possible.

Assistant notes
- No Cursor/Copilot rules found. If .cursor/rules/** or .github/copilot-instructions.md appear, mirror key rules here.
- Keep this file updated with any new workflows (lint, format, health, profiling).
You can add that information to your CRUSH.md file! Here's how you can specify the Windows environment with PowerShell Core:

## Environment Information
- Operating System: Windows
- Shell: PowerShell Core
- Path separator: Backslash (\) 
- Line endings: CRLF
- Preferred shell commands: PowerShell cmdlets and Windows-compatible commands

## Shell Command Guidelines
When writing shell commands for this environment:
- Use PowerShell syntax and cmdlets
- Use backslash (\) for file paths instead of forward slash (/)  
- Use `;` or `&&` to chain commands
- Use PowerShell's built-in commands rather than Unix utilities when possible
- For cross-platform compatibility, prefer commands that work in PowerShell Core

## Common PowerShell Patterns
- List files: `Get-ChildItem` or `ls`
- Change directory: `Set-Location` or `cd`
- Remove files: `Remove-Item` or `rm`
- Create directory: `New-Item -ItemType Directory` or `mkdir`
- Check if file exists: `Test-Path`

## Notes
- PowerShell Core (pwsh) is the preferred shell
- Some Unix-like commands are available through aliases
- Use backtick (`) for line continuation in PowerShell

This information would help any LLM (including Crush) understand that they should generate PowerShell Core commands rather than bash/Unix commands when helping with shell-related tasks in your environment.
