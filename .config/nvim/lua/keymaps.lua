vim.g.mapleader = " " -- Spacebar to initialize the key mappings

local keymap = vim.keymap -- local variable

keymap.set("n", "<C-a>", "gg<S-v>G") -- select all


-- word walk in BOTH normal and insert mode
keymap.set("i", "<C-h>", "<ESC>bi") -- move by left word
keymap.set("n", "<C-h>", "b")
keymap.set("i", "<C-l>", "<ESC>ei") -- move by right word
keymap.set("n", "<C-l>", "e")


-- split window and walk to the openning window
-- keymap.set("n", "<leader>vv", "<C-w>v<C-w>w", {silent = true}) -- split window vertically
-- keymap.set("n", "<leader>hh", "<C-w>S<C-w>w", {silent = true}) -- split window horizontally

keymap.set("n", "f", "<C-w>w") -- walk forwards/backwards between windows
-- resize windwos
keymap.set("n", "<leader>..", "<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><")
keymap.set("n", "<leader>,,", "<C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>>")
keymap.set("n", "<leader>==", "<C-w>+<C-w>+<C-w>+<C-w>+<C-w>+")
keymap.set("n", "<leader>--", "<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-")

