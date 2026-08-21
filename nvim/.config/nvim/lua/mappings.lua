-- Keymaps. NvChad's defaults first, then overrides below.

require "nvchad.mappings"

local map = vim.keymap.set

-- Command mode without the shift key. `;` is otherwise repeat-last-f, which is
-- cheaper to lose than a keypress on every single command.
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Leave insert mode without reaching for escape. `jk` is rare enough in prose and
-- code that the ambiguity timeout almost never fires.
map("i", "jk", "<ESC>")
