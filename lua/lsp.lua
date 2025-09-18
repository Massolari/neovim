--- Gets the hover content from the LSP result.
--- @param response table The LSP hover result.
--- @return string|nil The hover content as a string.
local function get_hover_content(response)
  if not response.result then
    return nil
  end

  local result = response.result

  if type(result.contents) == "string" then
    return result.contents
  end

  if not result.contents and not result.contents.value then
    return nil
  end

  return result.contents.value
end

--- Shows a hover window in the bottom right corner of the screen.
--- The window displays hover information from all attached LSP clients about the symbol under the cursor.
local function show_hover_window()
  vim.lsp.buf_request_all(0, "textDocument/hover", vim.lsp.util.make_position_params(0, "utf-8"), function(responses)
    local lines = {}
    local longer_line = 0
    local concealed_lines = 0
    for _, resp in pairs(responses) do
      local content = get_hover_content(resp)
      if content then
        local language = type(resp.result.contents) == "table" and resp.result.contents.language
        local result_lines = vim.split(content, "\n", { plain = true, trimempty = true })
        for _, line in ipairs(result_lines) do
          if line:match("```") then
            concealed_lines = concealed_lines + 1
          end
          longer_line = math.max(longer_line, #line)
          table.insert(lines, line)
        end
        if language then
          table.insert(lines, 1, "```" .. language)
          table.insert(lines, "```")
          concealed_lines = concealed_lines + 2
        end
      end
    end

    if vim.tbl_isempty(lines) then
      return
    end

    local max_height = math.floor(vim.fn.winheight(0) * 0.3)
    local height = math.min(#lines - concealed_lines, max_height)

    local max_width = math.floor(vim.fn.winwidth(0) * 0.3)
    local width = math.min(longer_line, max_width)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "win",
      row = vim.fn.winheight(0) - 1,
      col = vim.fn.winwidth(0) - width - 1,
      width = width,
      height = height,
      focusable = false,
      anchor = "SW",
      style = "minimal",
    })
    vim.treesitter.start(buf, "markdown")
    vim.wo[win].conceallevel = 3
    vim.wo[win].wrap = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufHidden", "InsertCharPre" }, {
      once = true,
      callback = function()
        pcall(vim.api.nvim_win_close, win, true)
      end,
    })
  end)
end

--- Function executed when a LSP client is attached to a buffer.
--- This function is responsible for setting up various LSP features
--- @param client vim.lsp.Client The LSP client.
--- @param bufnr number The buffer number.
local function on_attach(client, bufnr)
  if client:supports_method("textDocument/documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method("textDocument/completion") then
    if client.server_capabilities.completionProvider.completionItem then
      client.server_capabilities.completionProvider.completionItem.snippetSupport = true
    else
      client.server_capabilities.completionProvider.completionItem = {
        snippetSupport = true,
      }
    end
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
    vim.lsp.inlay_hint.enable()
  end

  if client:supports_method("textDocument/foldingRange") then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end

  if client:supports_method("textDocument/hover") then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = show_hover_window,
      group = vim.api.nvim_create_augroup("_lsp_hover", {}),
    })
  end
end

-- :help LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      on_attach(client, vim.api.nvim_get_current_buf())
    end
  end,
})
