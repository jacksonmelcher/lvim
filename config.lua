-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny



local formatters = require "lvim.lsp.null-ls.formatters"

lvim.format_on_save = true
vim.opt.relativenumber = true

lvim.builtin.project.manual_mode = true

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.hijack_directories.enable = false
lvim.builtin.nvimtree.setup.update_cwd = false
lvim.builtin.nvimtree.setup.respect_buf_cwd = false
-- vim.builtin.nvimtree.setup.filters.git_ignored = false
lvim.builtin.treesitter.fold = true -- Enable treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with all folds open

formatters.setup {
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    -- args = { "--print-width", "100" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "jsonc", "css" },
  },
}

-- lvim.keys.normal_mode["<C-w>m"] = ":WindowsMaximize<CR>"
-- lvim.keys.normal_mode["<C-w>_"] = ":WindowsMaximizeVertically<CR>"
-- lvim.keys.normal_mode["<C-w>|"] = ":WindowsMaximizeHorizontally<CR>"
-- lvim.keys.normal_mode["<C-w>="] = ":WindowsEqualize<CR>"
lvim.builtin.cmp.formatting = {
  format = function(entry, vim_item)
    vim_item.kind = lvim.icons.kind[vim_item.kind]
    vim_item.menu = ({
      nvim_lsp = "[LSP]",
      luasnip = "[Snip]",
      buffer = "[Buf]",
      path = "[Path]",
    })[entry.source.name]
    return vim_item
  end,
}
-- TMUX NAVIGATOR
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<cr>", { noremap = true, silent = true, desc = "window left" })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<cr>", { noremap = true, silent = true, desc = "window right" })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<cr>", { noremap = true, silent = true, desc = "window down" })
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<cr>", { noremap = true, silent = true, desc = "window up" })


-- Switch buffer
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })


-- BASIC
vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true, desc = "Yank to end of line" })
vim.keymap.set("n", "D", '"_d$', { noremap = true, silent = true, desc = "Delete to end of line" })

-- Deleting does not replace clipboard
vim.keymap.set("n", "dw", '"_dw', { noremap = true, silent = true, desc = "Delete word without overwriting clipboard" })
vim.keymap.set("n", "dd", '"_dd', { noremap = true, silent = true, desc = "Delete line without overwriting clipboard" })
vim.keymap.set("n", "DD", "dd", { noremap = true, silent = true, desc = "Delete line" })
vim.keymap.set(
  "n",
  "diw",
  '"_diw',
  { noremap = true, silent = true, desc = "Delete in word without overwriting clipboard" })


lvim.builtin.which_key.mappings["l"]["o"] = {
  function()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) }
    })
  end,
  "Organize Imports"
}

lvim.plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup({
        callbacks = {
          ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
        },
        -- Default action copies to clipboard
        action_callback = require("gitlinker.actions").copy_to_clipboard,
      })

      -- Set keymaps
      vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
        { silent = true, desc = "Copy git link" })
      vim.api.nvim_set_keymap('v', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
        { silent = true, desc = "Copy git link selection" })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip").config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
        enable_check_bracket_line = true,
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- Make autopairs and completion work together
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
