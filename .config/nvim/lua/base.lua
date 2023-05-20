-- utf-8
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- keep the lines when moving with `j,k`
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- use relative line number, example usage `5j`
vim.opt.number = true
vim.opt.relativenumber = true

 -- search with input and highlight the search result
vim.opt.hlsearch = false 
vim.opt.incsearch = true

-- search ignore cases unless capital letter is contained
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- allow mouse use
vim.opt.mouse = "a"

-- copy and paste with system clipboard
vim.opt.clipboard:append ("unnamedplus")
vim.api.nvim_set_option("clipboard","unnamed")

-- about tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- tab size
vim.opt.shiftround = true
vim.opt.expandtab = true -- force convert tab to spaces (so that every time escape the first work for the head of line we won't get back)


-- new line indent
vim.opt.autoindent = true
vim.opt.smartindent = true


-- auto reload if file is changed
vim.opt.autoread = true
--- NEVER create backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.wo.signcolumn = "no"

-- save with automatic formatting with lsp
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

