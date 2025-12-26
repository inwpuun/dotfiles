-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- map("n", "<C-m>", "<C-n>", { desc = "Go to left window", remap = true })
-- map("n", "<C-n>", "", { desc = "Go to left window", noremap = true })

map({ "n", "x", "o" }, "n", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x", "o" }, "N", "J", { noremap = true, silent = true })
map({ "n", "x", "o" }, "j", "n", { noremap = true, silent = true })
map({ "n", "x", "o" }, "J", "N", { noremap = true, silent = true })

-- map({ "n", "x", "o" }, "e", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x", "o" }, "e", "<up>", { noremap = false, silent = true })
map({ "n", "x", "o" }, "k", "e", { noremap = true, silent = true })
map({ "n", "x", "o" }, "K", "E", { noremap = true, silent = true })

map({ "n", "x", "o" }, "h", "m", { noremap = true, silent = true })
map({ "n", "x", "o" }, "H", "M", { noremap = true, silent = true })
map({ "n", "x", "o" }, "m", "<left>", { noremap = true, silent = true })
map({ "n", "x", "o" }, "M", "H", { noremap = true, silent = true })

map({ "n", "x", "o" }, "l", "i", { noremap = true, silent = true })
map({ "n", "x", "o" }, "L", "I", { noremap = true, silent = true })
map({ "n", "x", "o" }, "i", "<right>", { noremap = true, silent = true })
map({ "n", "x", "o" }, "I", "L", { noremap = true, silent = true })

-- map({ "n" }, ";", "<S-:>", { noremap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-m>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-n>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-e>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-i>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-S-Left>", "<C-Left>", { desc = "Go to Left Window", remap = true })
map("n", "<C-S-n>", "<C-j>", { desc = "Go to Lower Window", remap = true })
map("n", "<C-S-e>", "<C-k>", { desc = "Go to Upper Window", remap = true })
map("n", "<C-S-Right>", "<C-Right>", { desc = "Go to Right Window", remap = true })

-- buffers
map({ "n", "x", "o" }, "<A-m>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer", remap = true })
map({ "n", "x", "o" }, "<A-i>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

map({ "n", "x", "o" }, "<S-m>", "0", { noremap = true, silent = true })
map({ "n", "x", "o" }, "<S-i>", "$", { noremap = true, silent = true })

-- dial.nvim true
map({ "n" }, "<Space>o", "<C-a>", { desc = "Increment Number", remap = true })

-- git blame
map({ "n" }, "<Space>go", "<cmd>Gitsigns blame<cr>", { desc = "open git blame" })

--
map({ "n" }, "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map({ "n" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n" }, "E", vim.lsp.buf.hover, { desc = "Hover description" })
