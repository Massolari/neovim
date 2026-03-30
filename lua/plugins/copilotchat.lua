local functions = require("functions")

functions.on_pack_changed("CopilotChat.nvim", function(ev)
  vim.system({ "make tiktoken" }, { cwd = ev.data.path })
end)

vim.pack.add({ { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim", version = "main" } })
require("CopilotChat").setup({
  debug = false,
  model = "claude-sonnet-4.5",
  prompts = {
    CommitPtBr = {
      prompt = "> #git:staged\n\nEscreva uma mensagem de commit em português (Brasil) seguindo a convenção commitizen. Certifique-se que o título tem no máximo 50 caracteres e a mensagem está com quebra de linha em 72 caracteres. Envolva toda a mensagem em um bloco de código com a linguagem gitcommit.",
    },
  },
})

vim.keymap.set({ "n", "x" }, "<leader>ic", function()
  require("CopilotChat").toggle()
end, { desc = "Assistente" })
vim.keymap.set("n", "<leader>io", "<cmd>CopilotChatCommit<CR>", { desc = "Escrever mensagem de commit" })
vim.keymap.set(
  "n",
  "<leader>iO",
  "<cmd>CopilotChatCommitPtBr<CR>",
  { desc = "Escrever mensagem de commit em português" }
)
