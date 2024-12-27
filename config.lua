-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

local formatters = require "lvim.lsp.null-ls.formatters"

lvim.format_on_save = true
vim.opt.relativenumber = true

lvim.builtin.project.manual_mode = true
lvim.builtin.nvimtree.setup = {
  sync_root_with_cwd = false,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = false,
  },
  update_cwd = false,
  renderer = {
    group_empty = true, -- Example of other renderer options
  },
  view = {              -- Adjust view settings
    side = "left",
    width = 30,         -- Optionally set the width of the tree
  },
}

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

-- Organize imports
vim.keymap.set("n", "<leader>lo", function()
  vim.lsp.buf.execute_command({
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) }
  })
end, { noremap = true, silent = true, desc = "Organize Imports" })

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
}

local lspconfig = require('lspconfig')
lspconfig.emmet_ls.setup({
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
    "tsx"
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  }
})
