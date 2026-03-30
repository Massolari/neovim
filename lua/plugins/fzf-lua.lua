require("plugins.nvim-web-devicons")
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

require("fzf-lua").setup({
  winopts = {
    backdrop = 100,
    split = "botright new | resize 15",
  },
  files = {
    formatter = { "path.filename_first", 2 },
  },
  fzf_opts = {
    ["--style"] = "minimal",
    ["--info"] = "hidden",
  },
  ui_select = true,
})

vim.keymap.set("n", "<leader>b", function()
  require("fzf-lua").buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>B", function()
  require("fzf-lua").buffers({ cwd_only = true })
end, { desc = "Buffers do diretório atual" })

vim.keymap.set("n", "<leader>cp", function()
  require("fzf-lua").lsp_workspace_symbols()
end, { desc = "Buscar símbolos no projeto" })

vim.keymap.set("n", "<leader>ee", function()
  require("fzf-lua").builtin()
end, { desc = "Comandos do Fzf-lua" })

vim.keymap.set("n", "<leader>ehf", function()
  require("fzf-lua").files({ cwd = vim.fn.stdpath("data") .. "/rest" })
end, { desc = "Abrir" })

vim.keymap.set("n", "<leader>el", function()
  require("fzf-lua").blines({ winopts = { split = "belowright new" } })
end, { desc = "Pesquisar nas linhas do buffer" })

vim.keymap.set("n", "<leader>enf", function()
  require("fzf-lua").files({ cwd = vim.g.obsidian_dir, hidden = false })
end, { desc = "Abrir arquivo" })

vim.keymap.set("n", "<leader>er", function()
  require("fzf-lua").oldfiles()
end, { desc = "Arquivos recentes" })

vim.keymap.set("n", "<leader>f", function()
  require("fzf-lua").files()
end, { desc = "Buscar (find) arquivo" })

vim.keymap.set("n", "<leader>gi", function()
  require("fzf-lua").git_bcommits()
end, { desc = "Histórico de commits do arquivo atual" })

vim.keymap.set("n", "<leader>gr", function()
  require("fzf-lua").git_branches()
end, { desc = "Listar branches" })

vim.keymap.set("n", "gO", function()
  require("fzf-lua").lsp_document_symbols()
end, { desc = "Buscar símbolos no arquivo" })

vim.keymap.set("n", "<leader>o", function()
  require("fzf-lua").treesitter()
end, { desc = "Buscar símbolos no arquivo com treesitter" })

vim.keymap.set("n", "<leader>pe", function()
  require("fzf-lua").grep_cword()
end, { desc = "Procurar texto sob cursor" })

vim.keymap.set("n", "<leader>pz", function()
  require("fzf-lua").zoxide()
end, { desc = "Zoxide" })

vim.keymap.set("n", "<leader>ps", function()
  require("fzf-lua").live_grep()
end, { desc = "Procurar (search) nos arquivos" })

vim.keymap.set("n", "gri", function()
  require("fzf-lua").lsp_implementations()
end, { desc = "Implementações" })

vim.keymap.set("n", "grr", function()
  require("fzf-lua").lsp_references()
end, { desc = "Referências" })

vim.keymap.set("n", "gY", function()
  require("fzf-lua").lsp_typedefs()
end, { desc = "Definição do tipo" })
