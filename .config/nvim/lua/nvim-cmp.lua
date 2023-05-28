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
    { name = 'nvim_lsp' }, -- from lsp 
    { name = 'vsnip' },	-- from vsnip
  },
  {
  	{ name = 'buffer' },
  	{ name = 'path' }
  }),
  -- hotkey, set in `keybindings.lua`
  mapping = {
    ['<C-Tab>'] = 
    cmp.mapping(cmp.mapping.complete(), { 'i', 'c', 'n', 'v' }),
    -- cmp.mapping(
	--   function(rise_completion)
	--   	if cmp.visible() then
	--   		cmp.mapping.abort()
	--   		cmp.mapping.close()
	--   	elseif has_words_before() then
	--   		cmp.complete()
	--   	elseif vim.fn["vsnip#available"](1) == 1 then
	--   		feedkey("<Plug>(vsnip-expand-or-jump)", "")
	--   	else
	--   		rise_completion() -- recursive invokation!
	--   	end
	--   end, { 'i', 'c', 'n', 'v' }), -- show completion

    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}), -- next completion (in both insert and command mode)
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}), -- previous completion (in both insert and command mode)
    ['<CR>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false}), -- accept currently selected item; if none is select, return nothing
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
