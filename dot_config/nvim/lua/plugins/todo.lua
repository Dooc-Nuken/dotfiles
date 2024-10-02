return {
  "folke/todo-comments.nvim",
  event = {"BufReadPre","BufNewFile"},
  depedencies = {"nvim-lua/plenary.nvim"},
  config = function()
    local todo = require("todo-comments")

    --set keymaps
    local keymap = vim.keymap
    
    keymap.set("n", "]t", function()
      todo.jump_next()
    end,{ desc = "Todo suivant"})

    keymap.set("n", "[t", function()
      todo.jump_prev()
    end,{ desc = "Todo precedent"})
    
    todo.setup()
  end,
}
