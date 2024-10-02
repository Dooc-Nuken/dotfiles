vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", {desc = "Exit insert mode with jk"})
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear search highlight"})

-- [[ Basic Keymaps ]]
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Window management ]]
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Split equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "split close" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Buffer to Tab" })
