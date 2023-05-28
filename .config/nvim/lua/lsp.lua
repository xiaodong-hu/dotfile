---------------------------------------------------------- 
--------------------- language servers -------------------
---------------------------------------------------------- 
-- require'lspconfig'.julials.setup{}  -- lsp support for julialang (a little bit long time for startup)
require('lspconfig').julials.setup{
    -- autostart = false,   -- manually turn on lsp with :LspStart
    on_new_config = function(new_config, _)
        local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia") -- using the compiled sysimage for fast startup! (see makefile at ~/.julia/environments/nvim-lspconfig/)
        if require("lspconfig").util.path.is_file(julia) then
            new_config.cmd[1] = julia
        end
    end,
    root_dir = function(fname)
        return require"lspconfig/util".find_git_ancestor(fname) or vim.fn.getcwd()
    end
}

-- install pyright fro AUR first
require('lspconfig').pyright.setup{}

require('lspconfig').rust_analyzer.setup{
    -- Server-specific settings
    settings = {
      ["rust-analyzer"] = {}
    }
}

-- below extracted and modified from the official configuration at https://github.com/neovim/nvim-lspconfig
---------------------------------------------------------- 
--------------------- Keymap Settings --------------------
---------------------------------------------------------- 
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- the keymap for <C-j> and <C-k> is set in the sense that help massage is list above (short) or below (long) for choosing tokens. Twice input of j or k will go into the hover window
    vim.keymap.set('n', '<leader>j', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts) -- lsp-based formatting

    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<space>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})
