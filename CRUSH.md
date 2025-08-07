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
