(local {: require-and} (require :functions))

[{1 :mfussenegger/nvim-dap
  :enabled false
  :dependencies [{1 :mxsdev/nvim-dap-vscode-js
                  :dependencies [:mfussenegger/nvim-dap
                                 {1 :microsoft/vscode-js-debug
                                  :lazy true
                                  :build "npm install --legacy-peer-deps; npx gulp vsDebugServerBundle; mv dist out; git checkout package-lock.json"}]
                  :opts {:debugger_path (.. (vim.fn.stdpath :data)
                                            :/lazy/vscode-js-debug)
                         :adapters [:pwa-chrome]
                         :node_path vim.g.node_path}
                  :config true}]
  :keys [{1 :<leader>db
          2 #(require-and :dap #($.toggle_breakpoint))
          :desc "Adicionar/remover breakpoint"}
         {1 :<leader>dh
          2 #(require-and :dap.ui.widgets #($.hover))
          :desc "Mostrar hover"}
         {1 :<leader>dc 2 #(require-and :dap #($.continue)) :desc :Continuar}
         {1 :<leader>dr
          2 #(require-and :dap #($.repl.open))
          :desc "Abrir REPL"}
         {1 :<leader>di 2 #(require-and :dap #($.step_into)) :desc "Step into"}
         {1 :<leader>do 2 #(require-and :dap #($.step_out)) :desc "Step out"}
         {1 :<leader>dn 2 #(require-and :dap #($.step_over)) :desc "Step over"}
         {1 :<leader>dp 2 #(require-and :dap #($.step_back)) :desc "Step back"}
         {1 :<leader>dt 2 #(require-and :dap #($.terminate)) :desc :Finalizar}]
  :config (fn []
            (let [dap (require :dap)]
              (each [_ language (pairs [:typescript
                                        :javascript
                                        :typescriptreact
                                        :javascriptreact])]
                (tset dap.configurations language
                      [{:type :pwa-chrome
                        :request :launch
                        :name "Chrome Launch"}]))))}
 {1 :rcarriga/nvim-dap-ui
  :enabled false
  :name :dapui
  :config true
  :keys [{1 :<leader>du
          2 #(require-and :dapui #($.toggle))
          :desc "Mostrar/esconder janelas (dapui)"}]
  :dependencies :mfussenegger/nvim-dap}]
