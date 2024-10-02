return {
  -- La bar de status situé en bas de l'écran
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = { 
        theme = "wombat",
      }
    }
  end,
}
