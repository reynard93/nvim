-- local cssls = require("lspconfig.server_configurations.cssls")
-- local emmet_ls = require("lspconfig.server_configurations.emmet_ls")
-- local eslint = require("plugins.servers.eslint")
-- local html = require("lspconfig.server_configurations.html")
-- local jsonls = require("neoconf.plugins.jsonls")
local lua_ls = require("plugins.lsp.servers.lua_ls")
local volar = require("plugins.lsp.servers.volar")
local eslint = require("plugins.lsp.servers.eslint")
local denols = require("plugins.lsp.servers.denols")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "simrat39/inlay-hints.nvim",
      "jose-elias-alvarez/typescript.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      ---@type lspconfig.options
      servers = {
        -- cssls = cssls,
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "sass",
            "scss",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },
        lua_ls = lua_ls,
        volar = volar,
        eslint = eslint,
        html = {},
        denols = denols,
        quick_lint_js = {},
        cssls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(plugin, opts)
      if plugin.servers then
        require("lazyvim.util").deprecate("lspconfig.servers", "lspconfig.opts.servers")
      end
      if plugin.setup_server then
        require("lazyvim.util").deprecate("lspconfig.setup_server", "lspconfig.opts.setup[SERVER]")
      end

      -- setup autoformat
      require("lazyvim.plugins.lsp.format").autoformat = opts.autoformat

      -- setup formatting and keymaps
      require("lazyvim.util").on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.format").on_attach(client, buffer)
        -- require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
        require("config.lsp_keymaps").on_attach(client, buffer)
      end)

      -- -- override keymaps
      -- -- https://github.com/LazyVim/LazyVim/commit/47ba46f184ce34b634d70a2ef8739cccbbc23258
      -- local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- -- change a keymap
      -- -- keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
      -- keys[#keys + 1] = { "gtd", "<cmd>Telescope lsp_definitions<CR>" }
      -- keys[#keys + 1] = { "g;D", vim.lsp.buf.declaration }
      --
      -- -- add a keymap
      -- -- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
      --
      -- -- disable a keymap
      -- keys[#keys + 1] = { "K", false }
      -- keys[#keys + 1] = { "[d", false }
      -- keys[#keys + 1] = { "]d", false }
      -- keys[#keys + 1] = { "[e", false }
      -- keys[#keys + 1] = { "]e", false }
      -- keys[#keys + 1] = { "]w", false }
      -- keys[#keys + 1] = { "[w", false }

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_opts = servers[server] or {}
          server_opts.capabilities = capabilities
          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
              return
            end
          end
          require("lspconfig")[server].setup(server_opts)
        end,
      })

      local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
      clangd_capabilities.offsetEncoding = "utf-8"
      require("lspconfig").clangd.setup({
        capabilities = clangd_capabilities,
      })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = require("plugins.lsp.null-ls-settings").init(),
  },
  -- cmdline tools and lsp servers
  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
        },
        ui = {
          -- currently only round theme
          theme = "round",
          -- this option only work in neovim 0.9
          title = true,
          -- border type can be single,double,rounded,solid,shadow.
          border = "rounded",
          colors = {
            --title background color
            title_bg = "#98be65",
            -- normal_bg = "#202328",
            normal_bg = "#242b38",
            white = "#bbc2cf",
            yellow = "#ECBE7B",
            cyan = "#008080",
            darkblue = "#081633",
            green = "#98be65",
            orange = "#FF8800",
            violet = "#a9a1e1",
            purple = "#c678dd",
            blue = "#51afef",
            red = "#ec5f67",
            black = "#1c1c19",
          },
          kind = {},
        },
      })

      local keymap = vim.keymap.set
      -- Lsp finder find the symbol definition implement reference
      -- if there is no implement it will hide
      -- when you use action in finder like open vsplit then you can
      -- use <C-t> to jump back
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

      -- Code action
      -- keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      -- Rename
      keymap("n", "gR", "<cmd>Lspsaga rename<CR>")

      -- Peek Definition
      -- you can edit the definition file in this float window
      -- also support open/vsplit/etc operation check definition_action_keys
      -- support tagstack C-t jump back
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

      -- Go to Definition
      keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

      -- Show line diagnostics you can pass argument ++unfocus to make
      -- show_line_diagnostics float window unfocus
      -- keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

      -- Show cursor diagnostic
      -- also like show_line_diagnostics  support pass ++unfocus
      -- keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

      -- Show buffer diagnostic
      -- keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

      -- Diagnostic jump can use `<c-o>` to jump back
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- Diagnostic jump with filter like Only jump to error
      keymap("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)

      keymap("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

      -- Toggle Outline
      keymap("n", "<leader>cs", "<cmd>Lspsaga outline<CR>")

      -- Hover Doc
      -- if there has no hover will have a notify no information available
      -- to disable it just Lspsaga hover_doc ++quiet
      -- press twice it will jump into hover window
      -- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
      -- if you want keep hover window in right top you can use ++keep arg
      -- notice if you use hover with ++keep you press this keymap it will
      -- close the hover window .if you want jump to hover window must use
      -- wincmd command <C-w>w
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

      -- Callhierarchy
      keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
      keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
    end,
  },
}
