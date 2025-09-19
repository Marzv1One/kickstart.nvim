# Plan: nvim-ufo H/M/L markers and folding UX

## Summary
- Highlight H/M/L target rows in statuscolumn with minimal overhead.
- Robust redraw: avoid duplicate autocommands on reload.
- Reduce recomputation and expensive calls for better perf.
- Harden requires and mappings to align with Neovim APIs.

## Tasks
1) Autocmd hygiene
- Create augroup for redrawstatus on WinScrolled/BufWinEnter/BufEnter/CursorMoved/CursorMovedI.

2) Statuscolumn H/M/L logic
- Hoist require('statuscol.builtin') with pcall; soft-fail if missing.
- Swap vim.fn.strdisplaywidth -> vim.api.nvim_strwidth.
- Precompute window metrics and H/M/L rows once per eval; pass to predicate.
- Fast-path for non-cursor lines (relnum ~= 0) to emit bar cell quickly.
- Remove or gate debug helpers.

3) Fold UI and integration
- Keep fold_virt_text_handler, minor cleanup only.
- Enable/disable helpers via ufo.main.inspectBuf; concise boolean.
- Origami actions temporarily disable UFO; re-enable when at line start.
- Use vim.cmd.normal({...}) API form.

4) Keymaps
- Use zl/zh/zo/zO for origami; zR/zM/zr/zm/[Z/]Z for ufo with "UFO:" desc.

5) Style & tooling
- Localize helpers; no globals. Follow Stylua. Run stylua . after changes.
