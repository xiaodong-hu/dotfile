vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  --
  use 'wbthomason/packer.nvim'
  use 'Th3Whit3Wolf/space-nvim'
  use 'neovim/nvim-lspconfig'
  use 'JuliaEditorSupport/julia-vim'
  -- Vim Tex
  use { 'lervag/vimtex',
    vim.cmd([[
      let g:vimtex_view_method = 'skim'
      let g:vimtex_view_automatic = 0
      let g:vimtex_compiler_latexmk = {'continuous': 0}
      let g:vimtex_quickfix_open_on_warning = 0
      set conceallevel=1
      let g:tex_conceal='abdmg'
            ]])
   }
  
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
