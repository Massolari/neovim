local wk = require("which-key")
local options = { buffer = nil, silent = true, noremap = true, nowait = true }
local functions = require("functions")

-- Insert
vim.keymap.set("i", "<c-j>", function()
  if vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
    return
  end

  vim.api.nvim_feedkeys(functions.get_key_insert("<Down>"), "n", false)
end, { desc = "Mover para baixo" })

vim.keymap.set("i", "<c-k>", function()
  if vim.snippet.active({ direction = -1 }) then
    vim.snippet.jump(-1)
    return
  end

  vim.api.nvim_feedkeys(functions.get_key_insert("<Up>"), "n", false)
end, { desc = "Mover para cima" })

vim.keymap.set("i", "<Tab>", function()
  if not vim.lsp.inline_completion.get() then
    return "<Tab>"
  end
end, {
  expr = true,
  desc = "Aceitar sugestão de código em linha",
})

vim.keymap.set("i", "<M-n>", function()
  vim.lsp.inline_completion.select({ count = 1 })
end, {
  desc = "Próxima sugestão de código em linha",
})

vim.keymap.set("i", "<M-p>", function()
  vim.lsp.inline_completion.select({ count = -1 })
end, {
  desc = "Sugestão de código anterior em linha",
})

--- https://github.com/neovim/neovim/issues/35476#issuecomment-3693418042
local function accept_completion(item)
  local insert_text = item.insert_text
  if type(insert_text) == "string" then
    local range = item.range
    if range then
      local lines = vim.split(insert_text, "\n")
      local current_lines =
        vim.api.nvim_buf_get_text(range.start.buf, range.start.row, range.start.col, range.end_.row, range.end_.col, {})

      local row = 1
      while row <= #lines and row <= #current_lines and lines[row] == current_lines[row] do
        row = row + 1
      end

      local col = 1
      while
        row <= #lines
        and col <= #lines[row]
        and row <= #current_lines
        and col <= #current_lines[row]
        and lines[row][col] == current_lines[row][col]
      do
        col = col + 1
      end

      local word = string.match(lines[row]:sub(col), "%s*[^%s]%w*")
      item.insert_text = table.concat(vim.list_slice(lines, 1, row - 1), "\n")
        .. (row <= #current_lines and "" or "\n")
        .. (row <= #lines and col <= #lines[row] and lines[row]:sub(1, col - 1) or "")
        .. word
    end
  end
  return item
end

vim.keymap.set("i", "<m-right>", function()
  vim.lsp.inline_completion.get({
    on_accept = accept_completion,
  })
end, {
  desc = "Inserir próxima palavra da sugestão de código em linha",
})

-- Diagnostics
vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Próximo erro de código" })

vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Erro de código anterior" })

-- Normal com leader
functions.keymaps_set("n", {
  {
    ".",
    function()
      vim.lsp.buf.code_action({ context = { only = { "quickfix" } }, apply = true })
    end,
    { desc = "Corrigir" },
  },
  {
    "=",
    "<c-w>=",
    { desc = "Igualar tamanho das janelas" },
  },
  {
    ";",
    function()
      local ok, char = pcall(vim.fn.getcharstr)
      if not ok or char == "\27" then
        return
      end
      local column = vim.fn.col(".")
      vim.cmd("normal! A" .. char .. "")
      vim.fn.cursor(vim.fn.line("."), column)
    end,
    { desc = "Adiciona um caractere no final da linha" },
  },
  {
    "<Tab>",
    "\30",
    { desc = "Alterar para arquivo anterior" },
  },
  {
    "%",
    "ggVG",
    { desc = "Selecionar tudo" },
  },
  {
    "D",
    "<cmd>bd<CR>",
    { desc = "Deletar buffer e fechar janela" },
  },
  {
    "F",
    function()
      require("conform").format()
    end,
    { desc = "Formatar código" },
  },
  {
    "q",
    function()
      functions["toggle_quickfix"]()
    end,
    { desc = "Alternar quickfix" },
  },
  { "v", "<cmd>vsplit<CR>", { desc = "Dividir verticalmente" } },
  { "s", "<cmd>w<CR>", { desc = "Salvar buffer" } },
  {
    "/",
    function()
      functions.grep()
    end,
    { desc = "Buscar com ripgrep" },
  },
}, { prefix = "<leader>" })

-- Código
functions.keymaps_set("n", {
  {
    "d",
    function()
      require("trouble").toggle("diagnostics")
    end,
    { desc = "Problemas (diagnostics)" },
  },
  {
    "e",
    function()
      vim.diagnostic.open_float()
    end,
    { desc = "Mostrar erro da linha" },
  },
  {
    "i",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
    { desc = "Ativar/desativar dicas de código" },
  },
}, { prefix = "<leader>c" })

-- Editor
functions.keymaps_set("n", {
  {
    "=",
    "mpgg=G`p",
    { desc = "Indentar arquivo" },
  },
  {
    "b",
    function()
      require("nvim-web-browser").open()
    end,
    { desc = "Navegador (browser)" },
  },
  {
    "hn",
    function()
      functions.with_input("Novo arquivo: ", function(name)
        if name ~= "" then
          return vim.cmd.e((vim.fn.stdpath("data") .. "/rest/" .. name .. ".http"))
        else
          return nil
        end
      end)
    end,
    { desc = "Novo" },
  },
  {
    "N",
    function()
      vim.cmd.edit((vim.g.obsidian_dir .. "/Notas/Notas.md"))
    end,
    { desc = "Abrir notas" },
  },
  {
    "nn",
    function()
      local vaults = vim.fn.split(vim.fn.system("ls '" .. vim.g.obsidian_dir .. "'"), "\n")

      vim.ui.select(vaults, { prompt = "Cofre para novo arquivo" }, function(vault)
        functions.with_input("Novo arquivo: ", function(name)
          if name ~= "" then
            return vim.cmd.e((vim.g.obsidian_dir .. "/" .. vault .. "/" .. name))
          else
            return nil
          end
        end)
      end)
    end,
    { desc = "Novo arquivo" },
  },
  { "q", "<cmd>qa<CR>", { desc = "Fechar" } },
  { "R", "<cmd>restart<CR>", { desc = "Reiniciar Neovim" } },
  { "u", "<cmd>Lazy<CR>", { desc = "Plugins" } },
}, { prefix = "<leader>e" })
vim.keymap.set("v", "<leader>ei", ":Silicon<CR>", { desc = "Gerar imagem do código (silicon})" })

wk.add({
  { "<leader>a", group = "Avante", nowait = true, remap = false },
  { "<leader>b", group = "Buffer", nowait = true, remap = false },
  { "<leader>c", group = "Code", nowait = true, remap = false },
  { "<leader>e", group = "Editor", nowait = true, remap = false },
  { "<leader>eh", group = "Cliente HTTP", nowait = true, remap = false },
  { "<leader>g", group = "Git", nowait = true, remap = false },
  { "<leader>gb", group = "Blame", nowait = true, remap = false },
  { "<leader>gh", group = "Hunks", nowait = true, remap = false },
  { "<leader>gi", group = "Issues (Github)", nowait = true, remap = false },
  { "<leader>gu", group = "Pull Requests (Github)", nowait = true, remap = false },
  { "<leader>h", "<cmd>split<CR>", desc = "Dividir horizontalmente", nowait = true, remap = false },
  { "<leader>i", group = "Inteligência Artificial", nowait = true, remap = false },
  { "<leader>is", group = "Sidekick", nowait = true, remap = false },
  {
    "<leader>l",
    function()
      functions.toggle_location_list()
    end,
    desc = "Alternar locationlist",
    nowait = true,
    remap = false,
  },
  { "<leader>en", group = "Notas", nowait = true, remap = false },
  { "<leader>p", group = "Projeto", nowait = true, remap = false },
  { "<leader>w", group = "Window", proxy = "<C-w>", nowait = true, remap = false },
}, vim.tbl_extend("force", options, { mode = "n", prefix = "<leader>" }))

-- Buffer
vim.keymap.set("n", "<c-n>", "<cmd>bn<CR>", { desc = "Próximo buffer" })
vim.keymap.set("n", "<c-p>", "<cmd>bp<CR>", { desc = "Buffer anterior" })

-- Redo
vim.keymap.set("n", "U", "<c-r>", { desc = "Refazer" })

-- Pesquisa
vim.keymap.set("n", "n", "nzzzv", { nowait = true })
vim.keymap.set("n", "N", "Nzzzv", { nowait = true })

-- Janelas
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")

-- Limpar espaços em branco
vim.keymap.set("n", "<F5>", "mp<cmd>%s/\\s\\+$/<CR>`p")

-- Enter no modo normal quebra a linha
vim.keymap.set("n", "<CR>", "i<CR><Esc>")

-- Esc no modo normal, limpa a seleção
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alterar tamanho das janelas
vim.keymap.set("n", "<left>", "<cmd>vertical resize -5<cr>")
vim.keymap.set("n", "<right>", "<cmd>vertical resize +5<cr>")
vim.keymap.set("n", "<up>", "<cmd>resize -5<cr>")
vim.keymap.set("n", "<down>", "<cmd>resize +5<cr>")

-- Sempre se mover linha a linha com j/k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Depois de indentar manter a linha selecionada
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Mover linhas selecionadas
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Mapeamentos do helix
vim.keymap.set({ "n", "o", "x" }, "gh", "0", { desc = "Ir para início da linha" })
vim.keymap.set({ "n", "o", "x" }, "gl", "$", { desc = "Ir para fim da linha" })
vim.keymap.set({ "n", "o", "x" }, "gs", "^", { desc = "Ir para primeiro caractere não branco" })

-- Clipboard
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Colar da área de transferência" })
vim.keymap.set({ "n", "x" }, "gP", '"+P', { desc = "Colar da área de transferência antes do cursor" })
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copiar para área de transferência" })

-- Usar <c-m> como <CR>
vim.keymap.set({ "n", "i", "v", "c", "x" }, "<c-m>", "<CR>", { remap = true })

-- Selecionar nós do treesitter
vim.keymap.set("n", "<M-o>", "vgrn", { remap = true })
vim.keymap.set("x", "<M-o>", "grn", { remap = true })
vim.keymap.set("x", "<M-i>", "grm", { remap = true })

-- LSP
vim.keymap.set("n", "grf", function()
  vim.lsp.buf.format()
end, { desc = "Formatar arquivo" })

vim.keymap.set("n", "<leader>k", function()
  vim.lsp.buf.hover()
end, { desc = "Mostrar documentação" })

-- Juntar linhas
vim.keymap.set("n", "<leader>j", "J", { desc = "Juntar linhas" })
