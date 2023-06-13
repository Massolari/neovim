(import-macros {: g!} :hibiscus.vim)

{1 :github/copilot.vim
 :event :InsertEnter
 :init (fn []
         (vim.keymap.set :i :<C-q> "copilot#Accept(\"\\<C-q>\")"
                         {:remap true
                          :silent true
                          :script true
                          :expr true
                          :replace_keycodes false})
         (g! :copilot_no_tab_map true))}
