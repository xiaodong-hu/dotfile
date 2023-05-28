local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end



local lspkind = require('lspkind')
local cmp = require'cmp'

cmp.setup {
  -- set snippet engine as vsnip (also support many other engines)
  snippet = {
    -- REQUIRED: specify the snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- source of cmp
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, 
    { name = 'vsnip' },
    { name = 'buffer' },
  },
  {
  	{ name = 'buffer' },
  	{ name = 'path' }
  }),
  -- hotkey, set in `keybindings.lua`
  mapping = {
    -- here we use <Tab> to pop out the cmp-completion
    ['<Tab>'] = cmp.mapping(
        function(rise_completion)
        	if cmp.visible() then
                cmp.mapping.select_next_item()
                -- modified from the vnisp keymap settings: https://github.com/hrsh7th/vim-vsnip
                if vim.fn['vsnip#available'](1) then
                    feedkey('<Plug>(vsnip-expand-or-jump)', '<Tab>') -- for consistency, we also use <Tab> to jump among placeholders within snippets for vsnip
                end
        	elseif has_words_before() then
        		cmp.complete() -- pop out completion
        	else
        		rise_completion() -- recursive call
        	end
        end,
        { 'i' }
    ),

    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}), -- pick next completion (in both insert and command mode)
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}), -- pick prev completion (in both insert and command mode)
    ['<CR>'] = cmp.mapping.confirm({select = false}), -- accept currently selected item; if none is select, return nothing
  },

  -- show hint kinds with `lspkind-nvim`
  formatting = {
    format = lspkind.cmp_format({
      with_text = true, -- do not show text alongside icons
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      before = function (entry, vim_item)
        -- show source
        vim_item.menu = "["..string.upper(entry.source.name).."]"
        return vim_item
      end
    })
  },
}

-- use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    }),
})
