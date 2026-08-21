-- NvChad's own configuration. Mirrors the structure of NvChad's nvconfig.lua:
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  -- Gruvbox dark is the palette shared by every tool in this repo. The editor pane
  -- sits beside the zellij tab/status bars and the starship prompt, so a mismatch
  -- here is visible in a single glance. The other copies:
  --   alacritty/.config/alacritty/alacritty.toml   [colors.*]
  --   zellij/.config/zellij/themes/gruvbox.kdl
  --   starship/.config/starship/starship.toml      [palettes.gruvbox_dark]
  --   k9s/.config/k9s/skins/gruvbox.yaml
  theme = "gruvbox",

  -- Stop painting a background so the editor pane inherits Alacritty's `opacity`,
  -- the way the shell pane beside it already does. base46 does this by merging
  -- base46/glassy.lua, which is bg = "NONE" on Normal, NormalFloat, CursorLine,
  -- Folded, Pmenu and the telescope/cmp/nvim-tree groups. It lists no statusline or
  -- tabufline groups, so those stay solid - which is the rule the rest of the window
  -- already follows: bars opaque, content translucent.
  --
  -- Two things to know before editing this line. `require("base46").toggle_transparency()`
  -- flips it by string-replacing the literal text `transparency = <value>` in this
  -- file, so reformatting the assignment breaks the toggle silently. And because
  -- ~/.config/nvim is a stow symlink, that toggle writes into this repo - expect the
  -- flip to show up in `git status`.
  transparency = true,
}

return M
