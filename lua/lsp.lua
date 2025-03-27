vim.lsp.set_log_level = "trace"
vim.lsp.log = vim.inspect

--- Function executed when a LSP client is attached to a buffer.
--- This function is responsible for setting up various LSP features
--- @param client table The LSP client.
--- @param bufnr number The buffer number.
local function on_attach(client, bufnr)
  if client:supports_method("textDocument/documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method("textDocument/completion") then
    client.server_capabilities.completionProvider.completionItem.snippetSupport = true
  end

  if client:supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = 0,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end,
      group = vim.api.nvim_create_augroup("_code_lens", {}),
    })
  end

  if client:supports_method("textDocument/inlayHint") then
    return vim.lsp.inlay_hint.enable()
  end

  if client:supports_method("textDocument/foldingRange") then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
end

vim.lsp.handlers["client/registerCapability"] = (function(overriden)
  return function(err, res, ctx)
    local result = overriden(err, res, ctx)

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      on_attach(client, vim.api.nvim_get_current_buf())
    end

    return result
  end
end)(vim.lsp.handlers["client/registerCapability"])
