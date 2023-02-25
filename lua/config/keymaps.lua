-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local u = require("utils.func")

vim.keymap.set("n", "<C-a>", "<esc>ggVG<CR>") -- Select all
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>") -- " Use * to add w/out jumping
vim.keymap.set("n", "&", function() -- Rename word under cursor
  vim.api.nvim_feedkeys(":keepjumps normal! mi*`i<CR>", "n", false)
  u.press_enter()
  vim.api.nvim_feedkeys(":%s//", "n", false)
end)

-- Copy current path to clipboard
vim.keymap.set("n", "<leader>yd", u.copy_dir_to_clipboard, { desc = "Copy dir to clipboard" })
vim.keymap.set("n", "<leader>yf", u.copy_file_to_clipboard, { desc = "Copy file to clipboard" })

-- Center the view after jumping up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
