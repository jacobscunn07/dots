-- LSP servers. NvChad's defaults wire up the keymaps, capabilities and on_attach;
-- this file only picks which servers run.

require("nvchad.configs.lspconfig").defaults()

-- Terraform is the main use of this config; html/cssls cover the occasional web file.
-- Binaries come from mason (:Mason), not the Brewfile.
local servers = { "html", "cssls", "terraformls" }
vim.lsp.enable(servers)

-- See :h vim.lsp.config to change per-server options.
