return {
  -- !I!
  -- Inc-rename
  {
    "smjonas/inc-rename.nvim",
    config = true,
    keys = { { "<A-r>", ":IncRename ", desc = "IncRename" } },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = -1
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zK", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- nvimlsp
          vim.lsp.buf.hover()
        end
      end)

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      require("ufo").setup({
        fold_virt_text_handler = handler,
        open_fold_hl_timeout = 500,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            close = "q",
            switch = "<Tab>",
            trace = "<CR>",
          },
        },
        provider_selector = function(bufnr, filetype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
  {
    "numToStr/Navigator.nvim",
    lazy = false,
    keys = {
      { "<C-h>", "<CMD>NavigatorLeft<CR>", desc = "Navigator Left" },
      { "<C-l>", "<CMD>NavigatorRight<CR>", desc = "Navigator Right" },
      { "<C-k>", "<CMD>NavigatorUp<CR>", desc = "Navigator Up" },
      { "<C-j>", "<CMD>NavigatorDown<CR>", desc = "Navigator Down" },
    },
    config = true,
  },
}
