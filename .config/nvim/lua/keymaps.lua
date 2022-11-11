vim.g.mapleader = " " -- Spacebar to initialize the key mappings

local keymap = vim.keymap -- local variable

keymap.set("n", "<C-a>", "gg<S-v>G") -- select all


--- open subwindows below
keymap.set("n", "<leader>ss", ":vsplit<Return><C-w>w", {silent = true}) -- split window vertically
keymap.set("n", "f", "<C-w>w") -- walk forwards/backwards between windows

