-- Plugin specs beyond the set NvChad imports. lazy.nvim resolves these; each one
-- points at its setup in lua/configs/.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Nothing to highlight until a buffer exists, so don't pay for it at startup.
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require "configs.treesitter"
    end,
  },

  {
    "stevearc/conform.nvim",
    -- configs.conform sets format_on_save, so BufWritePre is the first moment the
    -- plugin is actually needed.
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
}
