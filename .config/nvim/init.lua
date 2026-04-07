-- Nano-style exit prompt (FIXED)
vim.keymap.set({ "n", "i" }, "<C-x>", function()
  vim.ui.input({ prompt = "Save changes? (y/n): " }, function(answer)
    if answer == "y" then
      vim.cmd("wq!")  -- force write (fixes readonly error)
    elseif answer == "n" then
      vim.cmd("q!")
    end
  end)
end)

-- Clipboard support
vim.opt.clipboard = "unnamedplus"

-- Ctrl+C copy
vim.keymap.set("v", "<C-c>", '"+y')

-- Ctrl+V paste
vim.keymap.set({ "n", "i" }, "<C-v>", '"+p')

-- Ctrl+K delete line
vim.keymap.set({ "n", "i" }, "<C-k>", "<Esc>dd")

-- True colors
vim.opt.termguicolors = true

-- Install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

  -- Theme (FIXED: no transparency, keeps colors)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = false,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

})

-- Autocomplete setup
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }
})

-- Java template for new files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.java",
  callback = function()
    local filename = vim.fn.expand("%:t:r")
    vim.cmd("0r ~/.config/nvim/templates/Main.java")
    vim.cmd("%s/Main/" .. filename .. "/g")
  end
})
