vim.lsp.set_log_level = "trace"
vim.lsp.log = vim.inspect
local function on_attach(client, bufnr)
  if client:supports_method("textDocument/documentSymbol") then
    require "nvim-navic".attach(client, bufnr)
  else
  end
  if client:supports_method("textDocument/completion") then
    client.server_capabilities.completionProvider.completionItem.snippetSupport = true
  else
  end
  if client:supports_method("textDocument/codeLens") then
    local function _4_()
      return vim.lsp.codelens.refresh({bufnr = 0})
    end
    vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {buffer = 0, callback = _4_, group = vim.api.nvim_create_augroup("_code_lens", {})})
  else
  end
  if client:supports_method("textDocument/inlayHint") then
    return vim.lsp.inlay_hint.enable()
  else
    return nil
  end
end
local function _7_(overriden)
  local function _8_(err, res, ctx)
    local result = overriden(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      on_attach(client, vim.api.nvim_get_current_buf)
      return result
    else
      return nil
    end
  end
  return _8_
end
vim.lsp.handlers["client/registerCapability"] = _7_(vim.lsp.handlers["client/registerCapability"])
return nil
