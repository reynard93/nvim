-- Kanagawa colors
-- These are used by other plugins, duplicated from Kanagawa repository
local colorMap = {
  sumiInk1 = "#1F1F28",
  sumiInk3 = "#363646",
  sumiInk4 = "#54546D",
  waveBlue1 = "#223249",
  waveBlue2 = "#2D4F67",
  winterGreen = "#2B3328",
  winterYellow = "#49443C",
  winterRed = "#43242B",
  winterBlue = "#252535",
  autumnGreen = "#76946A",
  autumnRed = "#C34043",
  autumnYellow = "#DCA561",
  samuraiRed = "#E82424",
  roninYellow = "#FF9E3B",
  waveAqua1 = "#6A9589",
  dragonBlue = "#658594",
  fujiGray = "#727169",
  springViolet1 = "#938AA9",
  oniViolet = "#957FB8",
  crystalBlue = "#7E9CD8",
  springViolet2 = "#9CABCA",
  springBlue = "#7FB4CA",
  lightBlue = "#A3D4D5",
  waveAqua2 = "#7AA89F",
  springGreen = "#98BB6C",
  boatYellow1 = "#938056",
  boatYellow2 = "#C0A36E",
  carpYellow = "#E6C384",
  sakuraPink = "#D27E99",
  waveRed = "#E46876",
  peachRed = "#FF5D62",
  surimiOrange = "#FFA066",
  katanaGray = "#717C7C",
}

local function setup()
  local default_colors = require("kanagawa.colors").setup()
  local kanagawa = require("kanagawa")

  local strongHighlight = "#fa7af6"

  kanagawa.setup({
    undercurl = true, -- enable undercurls
    commentStyle = {
      italic = true,
    },
    functionStyle = {},
    keywordStyle = {
      italic = true,
    },
    statementStyle = {},
    typeStyle = {},
    variablebuiltinStyle = {
      italic = true,
    },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    colors = {},
    overrides = {
      IncSearch = { fg = "black", bg = strongHighlight, underline = true, bold = true },
      Search = { fg = "black", bg = default_colors.oniViolet },
      Substitute = { fg = "black", bg = strongHighlight },
      MatchParen = { fg = strongHighlight, bg = default_colors.sumiInk1 },
    },
  })

  -- Make background transparent. I like semi-transparent background in the terminal.
  vim.cmd([[
    augroup user_colors
      autocmd!
      autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
    augroup END
  ]])

  vim.cmd.colorscheme("kanagawa")
  vim.api.nvim_set_hl(0, "@tag", { fg = default_colors.lightBlue })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = default_colors.lightBlue })
  vim.api.nvim_set_hl(0, "@tag.attribute", { fg = default_colors.sakuraPink })
  vim.cmd.hi("NonText guifg=bg")
end
local kanagawa = {
  colorMap,
  setup,
}

return kanagawa
