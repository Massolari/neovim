{1 :yetone/avante.nvim
 :event :VeryLazy
 :lazy false
 :version false
 ; Set this to "*" for latest release or false for latest code
 :opts {:provider :copilot :copilot {:model :claude-3.5-sonnet}}
 :build :make
 :dependencies [:stevearc/dressing.nvim
                :nvim-lua/plenary.nvim
                :MunifTanjim/nui.nvim
                :echasnovski/mini.pick
                :nvim-telescope/telescope.nvim
                :hrsh7th/nvim-cmp
                :ibhagwan/fzf-lua
                :nvim-tree/nvim-web-devicons
                :zbirenbaum/copilot.lua
                {1 :HakonHarnes/img-clip.nvim
                 :event :VeryLazy
                 :opts {:default {:embed_image_as_base64 false
                                  :prompt_for_file_name false
                                  :drag_and_drop {:insert_mode true}
                                  :use_absolute_path true}}}
                {1 :MeanderingProgrammer/render-markdown.nvim
                 :opts {:file_types [:markdown :Avante]}
                 :ft [:markdown :Avante]}]}

