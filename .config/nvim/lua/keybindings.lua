vim.g.mapleader = " " -- Spacebar to initialize the key mappings
local keymap = vim.keymap -- local variable

keymap.set("n", "<C-a>", "gg<S-v>G") -- select all


-- word walk in BOTH normal and insert mode
keymap.set("i", "<C-h>", "<ESC>bi") -- move by left word
keymap.set("n", "<C-h>", "b")
keymap.set("i", "<C-l>", "<ESC>ea") -- move by right word
keymap.set("n", "<C-l>", "e")

---------------------------------------------------------------------------------------------
---------------------------------- tab splitting block --------------------------------------
---------------------------------------------------------------------------------------------
keymap.set("n", "<C-n>", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<C-w>", ":tabclose<CR>") -- close a new tab
keymap.set("n", "<S-l>", ":tabnext<CR>") -- move to next tab
keymap.set("n", "<S-h>", ":tabprev<CR>") -- move to previous tab

keymap.set("n", "<leader>1", "1gt") -- move to tab 1
keymap.set("n", "<leader>2", "2gt") -- move to tab 2
keymap.set("n", "<leader>3", "3gt") -- move to tab 3
keymap.set("n", "<leader>4", "4gt") -- move to tab 4
keymap.set("n", "<leader>5", "5gt") -- move to tab 4

---------------------------------------------------------------------------------------------
------------------------------- window splitting block --------------------------------------
---------------------------------------------------------------------------------------------
-- split window and walk to the openning window
keymap.set("n", "<leader>vv", "<C-w>v<C-w>w", {silent = true}) -- split window vertically
keymap.set("n", "<leader>ss", "<C-w>s<C-w>w", {silent = true}) -- split window horizontally

keymap.set("n", "<leader>w", "<C-w>w") -- walk forwards/backwards between windows
-- resize windwos
keymap.set("n", "<leader>..", "<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><")
keymap.set("n", "<leader>,,", "<C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>>")
keymap.set("n", "<leader>==", "<C-w>+<C-w>+<C-w>+<C-w>+<C-w>+")
keymap.set("n", "<leader>--", "<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-")
