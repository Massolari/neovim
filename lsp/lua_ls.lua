return {
  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = { version = "LuaJIT" },
      diagnostics = { unusedLocalIgnore = { "_*" } },
      hint = { enable = true },
      workspace = { library = { vim.env.VIMRUNTIME } },
    })
  end,
  settings = { Lua = {} },
}
