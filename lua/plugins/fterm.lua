return {
  "numToStr/FTerm.nvim",
  config = function()
    local fTerm = require("FTerm")
    vim.keymap.set("n", "<C-t>", fTerm.toggle, {})
    vim.keymap.set("t", "<C-t>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>')
  end,
}
