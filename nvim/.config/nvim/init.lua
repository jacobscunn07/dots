-- ~/.config/nvim/init.lua
--
-- Entry point. Bootstraps lazy.nvim, then loads NvChad as a plugin rather than as a
-- fork, so everything hand-written lives in lua/ and NvChad stays updatable.
--
-- Layout of the rest of the config:
--   lua/chadrc.lua        NvChad's own settings (theme)
--   lua/options.lua       vim options
--   lua/autocmds.lua      autocommands
--   lua/mappings.lua      keymaps
--   lua/plugins/init.lua  the plugin specs lazy.nvim resolves
--   lua/configs/          per-plugin setup, required from the specs above

-- base46 precompiles NvChad's highlight groups into this dir; the dofile calls below
-- read from it. Must be set before lazy.nvim loads NvChad.
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
-- Set before plugins load: any mapping a plugin registers against <leader> at load time
-- resolves against whatever this is at that moment.
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- Read the compiled highlight groups straight off disk instead of waiting for NvChad's
-- ui module to load. Without this the first frame paints in default colors.
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

-- Deferred so mappings land after plugins have registered theirs, letting these win.
vim.schedule(function()
  require "mappings"
end)
