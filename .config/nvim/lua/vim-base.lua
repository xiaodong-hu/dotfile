-------------------------------------------------------------------
--------------------- All VIM Compatible Settings -----------------
-------------------------------------------------------------------
-- utf-8
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- the number of lines kept when moving away from current page with `j,k`
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

vim.opt.number = true
vim.opt.relativenumber = true   -- use relative line number


vim.opt.cursorline = true       -- highlight current line
vim.opt.linebreak = true        -- allow linebreak when warp a long line

vim.opt.showmatch = true        -- show search match
vim.opt.hlsearch = true         -- highlight search result
vim.opt.incsearch = true        -- search when typing

-- search ignore cases unless capital letter is contained
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.mouse = 'a'             -- allow mouse use
vim.opt.clipboard = 'unnamedplus' -- copy to system clipboard (with `xclip` or `wl-clipboard`)


-- about tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- tab size
vim.opt.expandtab = true -- force convert tab to spaces (so that every time escape the first work for the head of line we won't get back)



-- new line indent
vim.opt.autoindent = true
-- vim.opt.smartindent = true


vim.opt.autoread = true         -- auto reload if file is changed
--- NEVER create backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.wo.signcolumn = 'no'

---- save with automatic formatting with lsp (this is a sync procedure)
vim.cmd [[
    autocmd BufWritePre * lua vim.lsp.buf.format()
]]

-- show space as dots
vim.cmd [[
    set list
    set lcs+=space:·
]]

