vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'liuchengxu/space-vim-dark'
  use 'neovim/nvim-lspconfig'
  use 'JuliaEditorSupport/julia-vim'
  use 'lervag/vimtex'
  
  -- nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp' -- { name = nvim_lsp }
  use 'hrsh7th/cmp-buffer'   -- { name = 'buffer' },
  use 'hrsh7th/cmp-path'     -- { name = 'path' }
  use 'hrsh7th/cmp-cmdline'  -- { name = 'cmdline' }
  use 'hrsh7th/nvim-cmp'	 -- the main completion pkg `cmp`
  
  -- vsnip (a snippet engime that `nvim-cmp` support)
  use 'hrsh7th/cmp-vsnip'    -- { name = 'vsnip' }
  use 'hrsh7th/vim-vsnip'
  -- use 'rafamadriz/friendly-snippets'

  -- lspkind (show lsp hint kinds)
  use 'onsails/lspkind-nvim'
end)
