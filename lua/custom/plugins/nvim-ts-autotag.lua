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
