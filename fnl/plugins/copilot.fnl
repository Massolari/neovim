{1 :zbirenbaum/copilot.lua
 :event :InsertEnter
 :cmd :Copilot
 :config true
 :opts {:suggestion {:auto_trigger true
                     :keymap {:accept :<c-q> :next :<m-n> :prev :<m-p>}}
        :filetypes {:* true}}}

