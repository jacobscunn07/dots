-- Treesitter parsers and features. Required from the nvim-treesitter spec in
-- lua/plugins/init.lua.

local options = {
  -- Installed on first launch. Mirrors the LSP server list in lspconfig.lua:
  -- terraform/hcl for the main workload, html/css alongside it, and vim/lua/vimdoc
  -- so editing this config itself is highlighted.
  ensure_installed = {
    "vim",
    "lua",
    "vimdoc",
    "html",
    "css",
    "terraform",
    "hcl",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = {
    enable = true,
  },
}

require("nvim-treesitter.configs").setup(options)
