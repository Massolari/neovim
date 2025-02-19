(local {: require-and} (require :functions))

{1 :CopilotC-Nvim/CopilotChat.nvim
 :dependencies [:zbirenbaum/copilot.lua
                {1 :nvim-lua/plenary.nvim :branch :master}]
 :keys [{1 :<leader>ic
         2 #(require-and :CopilotChat #($.toggle))
         :mode [:n :x]
         :desc :Assistente}
        {1 :<leader>io
         2 :<cmd>CopilotChatCommit<CR>
         :desc "Escrever mensagem de commit"}
        {1 :<leader>iO
         2 :<cmd>CopilotChatCommitPtBr<CR>
         :desc "Escrever mensagem de commit"}]
 :opts {:debug true
        :model :claude-3.5-sonnet
        :prompts {:CommitPtBr {:prompt "> #git:staged

Escreva uma mensagem de commit em português (Brasil) seguindo a convenção commitizen. Certifique-se que o título tem no máximo 50 caracteres e a mensagem está com quebra de linha em 72 caracteres. Envolva toda a mensagem em um bloco de código com a linguagem gitcommit."}}}}

