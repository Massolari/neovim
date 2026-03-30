require("plugins.plenary")

vim.pack.add({ "https://github.com/NeogitOrg/neogit" })

require("neogit").setup({
  disable_commit_confirmation = true,
})

vim.keymap.set("n", "<leader>gs", function()
  require("neogit").open()
end, { desc = "Status" })

vim.keymap.set("n", "<leader>gc", function()
  require("neogit").open({ "commit" })
end, { desc = "Commit" })

vim.keymap.set("n", "<leader>gp", function()
  require("neogit").open({ "pull" })
end, { desc = "Pull" })

vim.keymap.set("n", "<leader>gP", function()
  require("neogit").open({ "push" })
end, { desc = "Push" })
