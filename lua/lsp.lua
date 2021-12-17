local nvim_lsp = require("lspconfig")

local mappings = require("mappings")


local border = {
  {"┌", "FloatBorder"},
  {"─", "FloatBorder"},
  {"┐", "FloatBorder"},
  {"│", "FloatBorder"},
  {"┘", "FloatBorder"},
  {"─", "FloatBorder"},
  {"└", "FloatBorder"},
  {"│", "FloatBorder"},
}

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  mappings.lsp(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  local lsp_reference_color = 'lightyellow'
  if vim.opt.background:get() ~= 'light' then
    lsp_reference_color = 'black'
  end
  vim.cmd('hi LspReferenceRead cterm=bold ctermbg='..lsp_reference_color..' guibg=' .. lsp_reference_color)
  vim.cmd('hi LspReferenceText cterm=bold ctermbg='..lsp_reference_color..' guibg=' .. lsp_reference_color)
  vim.cmd('hi LspReferenceWrite cterm=bold ctermbg='..lsp_reference_color..' guibg=' .. lsp_reference_color)


  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false)
  else
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua require'functions'.highlight_word()
      autocmd CursorMoved <buffer> lua require'functions'.clear_highlight_word()
      augroup END
      ]],
      false)
  end


  if client.resolved_capabilities.code_lens then
    vim.api.nvim_exec(
      [[
      augroup lsp_code_lens_refresh
      autocmd! * <buffer>
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
      augroup END
      ]],
      false
    )
    vim.cmd [[highlight LspCodeLens guifg=DarkGrey]]
    vim.cmd [[highlight LspCodeLensSeparator guifg=DarkGrey]]
  end
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = 'x', -- Could be '●', '▎', '■'
    },
  })

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
