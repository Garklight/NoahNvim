local lsp = {}

lsp.ensure_installed = {
  "lua-language-server",  "json-lsp",
  "fixjson", "html-lsp",
  "css-lsp","pyright","sql-formatter"
}


lsp.servers={
  "cssls",
  "html",
  "jsonls",
  "lua_ls",
  "pyright"
}

lsp.language_setup = function ()
  return {
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  }
end

return lsp
