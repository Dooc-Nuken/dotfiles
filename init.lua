--Mess version 

-- Basic Vim command
vim.cmd("set autoindent")
vim.cmd("set expandtab")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set shiftwidth=4")
vim.cmd("set smarttab")
vim.cmd("set softtabstop=4")
vim.cmd("set tabstop=4")

-- Activate copy paste with out of neovim windows
vim.o.clipboard = "unnamedplus"

-- Using space as a "command" button
vim.g.mapleader = " "

-- Lazy basic install for automatic plugin management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins configuration using lazypath variable
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", 
            "MunifTanjim/nui.nvim",
        },
    }
}
local opts = {}

require("lazy").setup(plugins, opts)

-- Catppuccin Color scheme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Telescope, Easy research system of file and greping inside file
-- bind to CTRL+p for file & Space+f+g for word
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Treesitter config, used by parser for indent and highlight
local configs = require("nvim-treesitter.configs")
configs.setup({
    ensure_installed = { "c", "lua", "javascript", "html", "python" },
    highlight = { enable = true },
    indent = { enable = true },  
})

-- NeoTree config, used for arborescence listing
-- bind Ctrl+N to open the pannel to the Right
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>',{})
