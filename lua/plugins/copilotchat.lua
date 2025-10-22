return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  build = "make tiktoken",
  keys = {
    {
      "<leader>ic",
      function()
        require("CopilotChat").toggle()
      end,
      mode = { "n", "x" },
      desc = "Assistente",
    },
    { "<leader>io", "<cmd>CopilotChatCommit<CR>", desc = "Escrever mensagem de commit" },
    { "<leader>iO", "<cmd>CopilotChatCommitPtBr<CR>", desc = "Escrever mensagem de commit" },
  },
  opts = {
    debug = false,
    model = "claude-sonnet-4.5",
    prompts = {
      CommitPtBr = {
        prompt = "> #git:staged\n\nEscreva uma mensagem de commit em português (Brasil) seguindo a convenção commitizen. Certifique-se que o título tem no máximo 50 caracteres e a mensagem está com quebra de linha em 72 caracteres. Envolva toda a mensagem em um bloco de código com a linguagem gitcommit.",
      },
    },
  },
}
