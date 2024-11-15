-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.format_on_save = true
local formatters = require "lvim.lsp.null-ls.formatters"
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
  }

}
