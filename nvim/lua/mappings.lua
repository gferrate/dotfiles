require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Copy to clipboard in visual mode
map("v", "<C-c>", '"+y', { desc = "Copy selection to clipboard" })

-- Clear search highlighting with ,<space>
map({ "n", "v" }, ",<space>", "<cmd>noh<CR>", { desc = "Clear search highlight" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
