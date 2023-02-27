local  lspconfig = require("lspconfig")
return {
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
      init_options = {
        languageFeatures = {
          references = true,
          definition = true,
          typeDefinition = true,
          callHierarchy = true,
          hover = false,
          rename = true,
          signatureHelp = true,
          codeAction = true,
          completion = {
            defaultTagNameCase = "both",
            defaultAttrNameCase = "kebabCase",
          },
          schemaRequestService = true,
          documentHighlight = true,
          codeLens = true,
          semanticTokens = true,
          diagnostics = true,
        },
        documentFeatures = {
          selectionRange = true,
          foldingRange = true,
          linkedEditingRange = true,
          documentSymbol = true,
          documentColor = true,
        },
      },
      settings = {
        volar = {
          codeLens = {
            references = true,
            pugTools = true,
            scriptSetupTools = true,
          },
        },
      },
      root_dir = lspconfig.util.root_pattern("package.json", "vue.config.js"),
}
