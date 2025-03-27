return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = { "github/copilot.vim", { "nvim-lua/plenary.nvim", branch = "master" } },
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
    debug = true,
    model = "claude-3.7-sonnet",
    prompts = {
      CommitPtBr = {
        prompt = "> #git:staged\n\nEscreva uma mensagem de commit em portugu\195\170s (Brasil) seguindo a conven\195\167\195\163o commitizen. Certifique-se que o t\195\173tulo tem no m\195\161ximo 50 caracteres e a mensagem est\195\161 com quebra de linha em 72 caracteres. Envolva toda a mensagem em um bloco de c\195\179digo com a linguagem gitcommit.",
      },
    },
  },
}
