require("plugins.plenary")

vim.pack.add({ "https://github.com/NeogitOrg/neogit" })

require("neogit").setup({
  disable_commit_confirmation = true,
  mappings = {
    status = {
      ["Y"] = false,
      ["<localleader>Y"] = "YankSelected",
      ["y"] = false,
      ["<localleader>y"] = "ShowRefs",
    },
    popup = {
      ["b"] = false,
      ["<localleader>b"] = "BranchPopup",
      ["l"] = false,
      ["<localleader>l"] = "LogPopup",
      ["v"] = false,
      ["<localleader>v"] = "RevertPopup",
      ["w"] = false,
      ["<localleader>w"] = "WorktreePopup",
    },
  },
})

vim.keymap.set("n", "<leader>gs", require("neogit").open, { desc = "Status" })

vim.keymap.set("n", "<leader>gc", function()
  require("neogit").open({ "commit" })
end, { desc = "Commit" })

vim.keymap.set("n", "<leader>gp", function()
  require("neogit").open({ "pull" })
end, { desc = "Pull" })

vim.keymap.set("n", "<leader>gP", function()
  require("neogit").open({ "push" })
end, { desc = "Push" })
