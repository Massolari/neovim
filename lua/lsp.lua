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
local function show_hover_window(bufnr)
  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/hover",
    vim.lsp.util.make_position_params(0, "utf-8"),
    function(responses)
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

      if vim.tbl_isempty(lines) or longer_line == 0 then
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
      vim.wo[win][0].spell = false
      vim.wo[win][0].conceallevel = 3
      vim.wo[win][0].wrap = true
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufHidden", "InsertCharPre" }, {
        once = true,
        callback = function()
          pcall(function()
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { unload = true })
          end)
        end,
      })
    end
  )
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

    vim.lsp.completion.enable(true, client.id, bufnr, {
      convert = function(item)
        local doc = item.documentation
        if not doc or type(doc) ~= "string" or not vim.startswith(doc, "#") then
          local item_kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Unknown"
          local kind_icon = require("lspkind").presets.codicons[item_kind] or ""
          local has_additional_edits = item.additionalTextEdits and next(item.additionalTextEdits) ~= nil
          local hl_group = "@lsp.type." .. string.lower(item_kind)
          return {
            abbr = string.format("%s%s", item.label, has_additional_edits and "~" or ""),
            kind = kind_icon .. " ",
            kind_hlgroup = hl_group,
          }
        end
        local color = doc:sub(1, 7) -- Make sure to get the full hex code
        local hl_color = color:sub(2) -- Remove the '#' for hl group name
        local hl_group = "lsp_color_" .. hl_color
        vim.api.nvim_set_hl(0, hl_group, { fg = color, bg = color })
        return {
          kind_hlgroup = "lsp_color_" .. hl_color,
          kind = "XX",
        }
      end,
    })

    vim.api.nvim_create_autocmd("CompleteChanged", {
      buffer = bufnr,
      callback = function()
        local info = vim.fn.complete_info({ "selected" })
        local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
        if nil == completionItem then
          return
        end

        local resolvedItem =
          vim.lsp.buf_request_sync(bufnr, vim.lsp.protocol.Methods.completionItem_resolve, completionItem, 500)

        local clientItem = resolvedItem and resolvedItem[client.id]
        if not clientItem then
          return
        end
        local docs = vim.tbl_get(clientItem, "result", "documentation", "value")
        if nil == docs then
          return
        end

        local winData = vim.api.nvim__complete_set(info["selected"], { info = docs })
        if not winData.winid or not vim.api.nvim_win_is_valid(winData.winid) then
          return
        end

        vim.api.nvim_win_set_config(winData.winid, { border = "rounded" })
        vim.treesitter.start(winData.bufnr, "markdown")
        vim.wo[winData.winid].conceallevel = 3
      end,
    })
  end

  if client:supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = 0,
      callback = function()
        if vim.fn.has("nvim-0.12") == 1 then
          vim.lsp.codelens.enable()
        else
          vim.lsp.codelens.refresh({ bufnr = 0 })
        end
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

  if client:supports_method("textDocument/inlineCompletion") and vim.fn.has("nvim-0.12") == 1 then
    vim.lsp.inline_completion.enable()
  end

  if client:supports_method("textDocument/hover") then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        pcall(show_hover_window, bufnr)
      end,
      group = vim.api.nvim_create_augroup("_lsp_hover", { clear = false }),
    })
  end

  if client:supports_method("textDocument/semanticTokens/full") and vim.fn.has("nvim-0.12") == 1 then
    vim.lsp.semantic_tokens.enable(true)
  end

  if client:supports_method("textDocument/onTypeFormatting") and vim.fn.has("nvim-0.12") == 1 then
    vim.lsp.on_type_formatting.enable()
  end

  if client:supports_method("textDocument/linkedEditingRange") then
    vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
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
