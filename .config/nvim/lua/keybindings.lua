vim.g.mapleader = " " -- Spacebar to initialize the key mappings
local keymap = vim.keymap -- local variable

---------------------------------------------------------------------------------------------
---------------------------------- Vim Cursor/Page Movement ---------------------------------
---------------------------------------------------------------------------------------------
-- Ctrl-y Moves screen up one line
-- Ctrl-e Moves screen down one line
--
-- Ctrl-u Moves cursor & screen up ½ page
-- Ctrl-d Moves cursor & screen down ½ page
--
-- Ctrl-b Moves screen up one page, cursor to last line
-- Ctrl-f Moves screen down one page, cursor to first line

---------------------------------------------------------------------------------------------
-------------------------------------- Basic Edit Setting -----------------------------------
---------------------------------------------------------------------------------------------
keymap.set({"n","v","i"}, "<ESC>", "<ESC>")
-- diable arrow keys in ALL Modes
keymap.set({"n","v","i"}, "<Up>", "<Nop>")
keymap.set({"n","v","i"}, "<Down>", "<Nop>")
keymap.set({"n","v","i"}, "<Left>", "<Nop>")
keymap.set({"n","v","i"}, "<Right>", "<Nop>")


keymap.set({"n","i"}, "<C-]>", "<S-v>>") -- tab forward a line (like vscode)
keymap.set({"n","i"}, "<C-[>", "<S-v><") -- tab backward a line (like vscode)

keymap.set("n", "<C-a>", "gg<S-v>G") -- select all

-- word walk in n,v,i-mode mode
keymap.set("i", "<C-h>", "<ESC>bi") -- move by left word
keymap.set({"n","v"}, "<C-h>", "b")
keymap.set("i", "<C-l>", "<ESC>ea") -- move by right word
keymap.set({"n","v"}, "<C-l>", "e")



---------------------------------------------------------------------------------------------
---------------------------------- tab splitting block --------------------------------------
---------------------------------------------------------------------------------------------
keymap.set("n", "<S-t>", ":tabnew<CR>:terminal<CR>i", {silent = true}) -- create a new buffer and enter to the terminal mode. This also serve as  `:tabnew<CR>`
keymap.set("t", "<S-w>", "<C-\\><C-n>", {noremap = true}) -- exit the terminal mode
keymap.set("n", "<S-q>", ":tabclose<CR>") -- close a new tab (<C-W> will affect walk among windows...)

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

-- walk around
keymap.set("n", "<leader>h", "<C-w>h")
keymap.set("n", "<leader>l", "<C-w>l")
keymap.set("n", "<leader>j", "<C-w>j")
keymap.set("n", "<leader>k", "<C-w>k")


-- resize windwos
keymap.set("n", "<leader>..", "<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><")
keymap.set("n", "<leader>,,", "<C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>>")
keymap.set("n", "<leader>==", "<C-w>+<C-w>+<C-w>+<C-w>+<C-w>+")
keymap.set("n", "<leader>--", "<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-")


---------------------------------------------------------------------------------------------
------------------------------------ work with buffers --------------------------------------
---------------------------------------------------------------------------------------------
-- keymap.set("n", "<leader>t", ":terminal<CR>i") -- move to tab 4
-- keymap.set("t", "<leader>t", "<C-\\><C-n>|:buffers<CR>:buffer 1<CR>") -- move to tab 4
-- 
-- keymap.set("n", "<leader>b", ":buffers<CR>:buffer term<CR>") -- move to tab 4


