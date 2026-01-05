return {
{
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.lsp.enable({ "rust_analyzer", "clangd", "pyright", "julia" })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      enabled = function()
        return not vim.tbl_contains({ "prompt", "lsp:rename", "nofile" }, vim.bo.buftype) and vim.b.completion ~= false
      end,
      keymap = {
        preset = "enter",
        ["<C-j>"] = {
          "select_next",
          "snippet_forward",
          function(cmp)
            local function has_words_before()
              local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
              return col ~= 0
                and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<C-k>"] = {
          "select_prev",
          "snippet_backward",
          function(cmp)
            if vim.api.nvim_get_mode().mode == "c" then
              return cmp.show()
            end
          end,
          "fallback",
        },
      },
      cmdline = {
        keymap = {
          preset = "default",
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
        },
        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
          menu = { auto_show = true },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      signature = { enabled = true },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon" },
            },
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}