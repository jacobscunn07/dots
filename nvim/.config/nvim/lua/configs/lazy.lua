-- lazy.nvim's own settings. Passed as the second argument to require("lazy").setup()
-- in init.lua.

return {
  -- Everything lazy-loads unless a spec opts out, which is why the specs in
  -- lua/plugins/init.lua each carry an event.
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      -- Vim ships these as runtime plugins and loads them at startup. NvChad replaces
      -- what they cover (nvim-tree for netrw, telescope for the rest), so the only
      -- thing they add is startup cost. Disabling netrw here is also why no
      -- .netrwhist ever gets written into this config dir.
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
