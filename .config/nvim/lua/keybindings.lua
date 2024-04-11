vim.g.mapleader = " " -- Spacebar to initialize the key mappings
local keymap = vim.keymap -- local variable

---------------------------------------------------------------------------------------------
---------------------------------- Vim Cursor/Page Movement ---------------------------------
---------------------------------------------------------------------------------------------
-- Ctrl-y Moves screen up one line
-- Ctrl-e Moves screen down one line
keymap.set({"n","v","i"}, "<C-j>", "<C-e>")
keymap.set({"n","v","i"}, "<C-k>", "<C-y>")

-- Ctrl-u Moves cursor & screen up ½ page
-- Ctrl-d Moves cursor & screen down ½ page

-- Ctrl-b Moves screen up one page, cursor to last line
-- Ctrl-f Moves screen down one page, cursor to first line

---------------------------------------------------------------------------------------------
-------------------------------------- Basic Edit Setting -----------------------------------
---------------------------------------------------------------------------------------------
keymap.set({"n","v","i"}, "<ESC>", "<ESC>") -- something is conflicting with <ESC> here... so I have to map it for use...
-- keymap.set({"n","v"}, "p", '"0p') -- something is conflicting with <ESC> here... so I have to map it for use...

-- diable arrow keys in ALL Modes
keymap.set({"n","v","i"}, "<Up>", "<Nop>")
keymap.set({"n","v","i"}, "<Down>", "<Nop>")
keymap.set({"n","v","i"}, "<Left>", "<Nop>")
keymap.set({"n","v","i"}, "<Right>", "<Nop>")

keymap.set({"i"}, "<C-v>", "<ESC>lv") -- directly switch from edit mode to view mode

keymap.set({"n"}, "<C-l>", "e") -- word walk like vscode
keymap.set({"i"}, "<C-l>", "<ESC>ea") -- word walk like vscode
keymap.set({"v"}, "<C-l>", "e") -- word walk like vscode

keymap.set({"n"}, "<C-h>", "b") -- word walk like vscode
keymap.set({"i"}, "<C-h>", "<ESC>bi") -- word walk like vscode
keymap.set({"v"}, "<C-h>", "b") -- word walk like vscode


-- automatic brackets closing (with jump)
keymap.set({"i"}, "(", "()<ESC>i")
keymap.set({"i"}, "[", "[]<ESC>i")
keymap.set({"i"}, "{", "{}<ESC>i")
keymap.set({"i"}, "'", "''<ESC>i")
keymap.set({"i"}, '"', '""<ESC>i')
keymap.set({"i"}, "`", "``<ESC>i")
keymap.set({"i"}, "$", "$$<ESC>i")
-- automatic brackets completiond with selected tokens (and cursor at end) 
keymap.set({"v"}, "(", "di()<ESC>hgp")
keymap.set({"v"}, "[", "di[]<ESC>hgp")
keymap.set({"v"}, "{", "di{}<ESC>hgp")
keymap.set({"v"}, "'", "di''<ESC>hgp")
keymap.set({"v"}, '"', 'di""<ESC>hgp')
keymap.set({"v"}, "`", "di``<ESC>hgp")
-- keymap.set({"v"}, "$", 'di$$<ESC>hgp') -- sometimes we need to choose til end of the line, so this should be commented


-- keymap.set({"n"}, "<C-]>", "<S-v>>") -- tab forward the entire line (like vscode)
-- keymap.set({"n"}, "<C-[>", "<S-v><") -- tab backward the entire line (like vscode)
-- keymap.set({"i"}, "<C-]>", "<ESC><S-v>>") -- tab forward the entire line (like vscode)
-- keymap.set({"i"}, "<C-[>", "<ESC><S-v><") -- tab backward the entire line (like vscode)
keymap.set("n", "<C-a>", "gg<S-v>G") -- select all


-- Multi-cursor behavior like ctrl+d in vscode is not good for vim design
------ use :%s/to_be_replaced/replacing_contents/gc. Or cgn in view mode with n (next search) and . (repeating); or with 

---------------------------------------------------------------------------------------------
---------------------------------- tab splitting block --------------------------------------
---------------------------------------------------------------------------------------------
keymap.set("n", "<S-t>", ":tabnew<CR>:terminal<CR>i", {silent = true}) -- create a new buffer and enter to the terminal mode. This also serve as  `:tabnew<CR>`
keymap.set("n", "<S-q>", ":tabclose<CR>") -- close a new tab (<C-W> will affect walk among windows...)

keymap.set("t", "<S-e>", "<C-\\><C-n>", {noremap = true}) -- exit the terminal mode (and go back to normal mode)
keymap.set({"n"}, "<S-l>", ":tabnext<CR>") -- move to next tab
keymap.set({"n"}, "<S-h>", ":tabprev<CR>") -- move to previous tab

keymap.set({"n"}, "<S>1", "1gt") -- move to tab 1
keymap.set({"n"}, "<S>2", "2gt") -- move to tab 2
keymap.set({"n"}, "<S>3", "3gt") -- move to tab 3
keymap.set({"n"}, "<S>4", "4gt") -- move to tab 4
keymap.set({"n"}, "<S>5", "5gt") -- move to tab 4





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


