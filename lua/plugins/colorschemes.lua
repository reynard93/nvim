return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa", -- tokyonight, catppucin, onedark
    },
  },
  {
    "rebelot/kanagawa.nvim",
    config = require("utils.kanagawa").setup,
  },
}
