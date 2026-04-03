return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "User FilePost",
    cmd = { "TSLog", "TSUpdate", "TSInstall" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
            "c",
            "cpp",
            "zig",
            "rust",
            "lua",
            "python",
            "julia",
        },
        sync_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      })
    end,
  },
}