(local {: dir-exists?} (require :functions))

{1 :Massolari/forem.nvim
 :cond (dir-exists? (.. vim.env.HOME :/forem.nvim))
 :dir (.. vim.env.HOME :/forem.nvim)
 :cmd :Forem
 :dependencies [:nvim-lua/plenary.nvim :nvim-telescope/telescope.nvim]}

