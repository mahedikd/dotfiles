require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>ws", ":w<cr>", { desc = "Save" })
map("n", "<leader>wq", ":wq!<cr>", { desc = "Save and Quite" })
map("n", "<leader>qq", ":q!<cr>", { desc = "Quite nvim forced" })
map("n", "<leader>q", ":q<cr>", { desc = "Quite nvim" })
map("n", "<leader>h", ":HopWord<cr>", { desc = "Hop word" })
map("n", "<leader>tt", ":Twilight<cr>", { desc = "Twilight" })


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
