vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'liuchengxu/space-vim-dark'
  use 'neovim/nvim-lspconfig'
  use 'JuliaEditorSupport/julia-vim'
  use 'lervag/vimtex'
end)
