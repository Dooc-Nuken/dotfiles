return {
  -- Permet d'ajouter plus facilement des choses
  -- autour d'un word
  -- Keubind simple "You surround"
  -- ysiw" => Ajoute " aoutour d'un mot
  -- ds => Delete surround
  -- cs => change surrout.
  -- Plein d'option avancé
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    require("nvim-surround").setup({
    })
      end,
}
