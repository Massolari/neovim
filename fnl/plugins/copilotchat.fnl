(local {: require-and} (require :functions))

{1 :CopilotC-Nvim/CopilotChat.nvim
 :branch :canary
 :dependencies [:zbirenbaum/copilot.lua :nvim-lua/plenary.nvim]
 :keys [{1 :<leader>ea
         2 #(require-and :CopilotChat #($.toggle))
         :desc :Assistente}]
 :opts {:debug true}}
