{1 :yetone/avante.nvim
 :event :VeryLazy
 :lazy false
 :version false
 ; Set this to "*" for latest release or false for latest code
 :opts {:provider :copilot :copilot {:model :claude-3.7-sonnet}}
 :build :make
 :dependencies [:stevearc/dressing.nvim
                :nvim-lua/plenary.nvim
                :MunifTanjim/nui.nvim
                ; Optional dependencies
                :hrsh7th/nvim-cmp
                :ibhagwan/fzf-lua
                :nvim-tree/nvim-web-devicons
                {1 :MeanderingProgrammer/render-markdown.nvim
                 :opts {:file_types [:markdown :Avante]}
                 :ft [:markdown :Avante]}]}
