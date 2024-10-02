return {
  -- Permet de coller un texte en remplacant un mot ou une ligne
  "gbprod/substitute.nvim",
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    local substitute = require("substitute")
    substitute.setup()
    
    -- keymaps
    local keymap = vim.keymap

    keymap.set("n", "s",  substitute.operator, {desc = "substitute with motion" })
    keymap.set("n", "ss", substitute.line, {desc = "substitute line " })
    keymap.set("n", "S",  substitute.eol, {desc = "substitute to end line" })
    keymap.set("x", "s",  substitute.visual, {desc = "substitute in visual mode" })
  end,
}
