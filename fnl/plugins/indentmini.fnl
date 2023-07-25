(local {: require-and} (require :functions))

{1 :nvimdev/indentmini.nvim
 :event :BufEnter
 :opts {:char "│"}
 :config (fn [_ opts]
           (require-and :indentmini #($.setup opts))
           (vim.cmd.highlight "default link IndentLine IndentBlanklineChar"))}
