-- return {
-- }
--

return {
--   {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd("colorscheme tokyonight")
--     end,
--   },
    {
      "Th3Whit3Wolf/space-nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd("colorscheme space-nvim")
      end,
    },
--     {
--         "ellisonleao/gruvbox.nvim", 
--         priority = 1000 , 
--         config = function()
--             require("gruvbox").setup({
--                 contrast = "hard",
--             })
--             vim.cmd("colorscheme gruvbox")
--         end,
--     }
}
