-- Formatters, keyed by filetype. Consumed as `opts` by the conform.nvim spec in
-- lua/plugins/init.lua.

local options = {
  formatters_by_ft = {
    -- stylua reads .stylua.toml at the root of this config.
    lua = { "stylua" },

    hcl = { "packer_fmt" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },

  format_on_save = {
    -- Passed through to conform.format().
    timeout_ms = 500,
    -- Filetypes with no formatter above still get formatted if their LSP can do it.
    lsp_fallback = true,
  },
}

return options
