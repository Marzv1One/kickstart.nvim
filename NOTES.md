# Plan: nvim-ufo H/M/L markers and folding UX

## Summary
- Highlight H/M/L target rows in statuscolumn with minimal overhead.
- Robust redraw: avoid duplicate autocommands on reload.
- Reduce recomputation and expensive calls for better perf.
- Harden requires and mappings to align with Neovim APIs.

## Status
- Done: augroup for redrawstatus autocmd
- Done: pcall(require) guard for statuscol
- Done: spacing/alignment for markers and current line number
- Done: precompute rows per eval; faster conditions/text
- Done: keymaps and ufo/origami integration
- Skipped: window-tick cache (optional)

## Tasks
1) Autocmd hygiene
- [x] Create augroup for redrawstatus on WinScrolled/BufWinEnter/BufEnter/CursorMoved/CursorMovedI.

2) Statuscolumn H/M/L logic
- [x] Hoist require('statuscol.builtin') with pcall; soft-fail if missing.
- [x] Keep strdisplaywidth for consistent spacing.
- [x] Precompute window metrics and H/M/L rows once per eval; pass to predicate.
- [x] Fast-path for non-cursor lines (relnum ~= 0) to emit bar cell quickly.
- [x] Tidy/guard debug helpers.

3) Fold UI and integration
- [x] Keep fold_virt_text_handler; minor cleanup.
- [x] Enable/disable helpers via ufo.main.inspectBuf; concise boolean.
- [x] Origami actions interop with UFO.
- [x] Use vim.cmd.normal API form.

4) Keymaps
- [x] Use zl/zh/zo/zO + zR/zM/zr/zm/[Z/]Z with "UFO:" desc.

5) Style & tooling
- [x] Localize helpers; no globals. Stylua before commit.
