local group = vim.api.nvim_create_augroup("_general-settings", {})

-- Fechar o buffer de help e man com `q`
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help", "man" },
  callback = function()
    vim.keymap.set("n", "q", ":close<CR>", { buffer = true })
  end,
  group = group,
})

-- Destacar o texto copiado
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.hl.on_yank()

    if vim.v.event.operator == "y" then
      -- Usar os registros para armazenar o histórico de cópias
      for i = 9, 1, -1 do
        vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
      end
    end
  end,
  group = group,
})

-- Recuperar a posição do cursor ao abrir um arquivo
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local row = mark[1]
    if (row > 1) and (row <= vim.api.nvim_buf_line_count(0)) then
      return vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  group = group,
})

-- Habilitar o número relativo ao sair do modo de inserção
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = true
  end,
  group = group,
})

-- Desabilitar o número relativo ao entrar no modo de inserção
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = false
  end,
  group = group,
})

-- Habilitar o corretor ortográfico ao editar arquivos markdown e txt
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "txt" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.complete = { "k", ".", "b", "w" }
  end,
  group = vim.api.nvim_create_augroup("_markdown", {}),
})

-- Redimensionar as janelas ao redimensionar a tela
vim.api.nvim_create_autocmd(
  { "VimResized" },
  { pattern = "*", command = "tabdo wincmd =", group = vim.api.nvim_create_augroup("_auto_resize", {}) }
)

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("_cmdline_changed", {}),
  pattern = "[:\\/?]",
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local ev_name, ev_kind, ev_build = ev.data.spec.name, ev.data.kind, vim.tbl_get(ev.data.spec, "data", "build")
    if ev_build then
      if not ev.data.active then
        vim.cmd.packadd(ev_name)
      end
      local build_kind = ev_build.kind or { "install", "update" }
      if vim.tbl_contains(build_kind, ev_kind) then
        ev_build.run(ev)
      end
    end
  end,
})
