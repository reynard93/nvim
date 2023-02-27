local lspconfig_util_status_ok, lspconfig_util = pcall(require, "lspconfig.util")
if not lspconfig_util_status_ok then
  return
end

return {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = lspconfig_util.root_pattern("deno.json", "deno.jsonc"),
}
