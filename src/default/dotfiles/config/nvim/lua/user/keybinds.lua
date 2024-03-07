vim.keymap.set("n", "<leader>e", ":Ex <CR>", {})
vim.keymap.set("n", "<C-g>", ":LazyGit<CR>", {})
vim.keymap.set("x", "gr", ":Gitsigns reset_hunk<CR>", {})

vim.keymap.set("n", "Q", ":q<CR>", {})

vim.keymap.set("n", "<leader>ff", ":Files <CR>", {})
vim.keymap.set("n", "<leader>fw", ":RG <CR>", {})
vim.keymap.set("n", "<leader>fo", ":History <CR>", {})
