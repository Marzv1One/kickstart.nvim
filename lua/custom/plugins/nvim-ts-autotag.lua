return {
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        per_filetype = {
          ['razor'] = {
            enable_close = true,
            enable_rename = true,
          },
        },
      }
    end,
  },
}
--
-- 10:38:18 PM msg_show.lua_print {
--   actual_curbuf = 18,
--   actual_curwin = 1000,
--   buf = 18,
--   cul = 1,
--   empty = false,
--   fold = {
--     close = "",
--     open = "",
--     sep = " ",
--     width = 1
--   },
--   lnum = 8,
--   nu = true,
--   nuw = 4,
--   relnum = 0,
--   rnu = true,
--   tick = 350ULL,
--   virtnum = 0,
--   win = 1000,
--   wp = cdata<struct 970 *>: 0x01ca16228ca0
-- }
