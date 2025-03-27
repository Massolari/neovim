local functions = require("functions")

return {
  "NeogitOrg/neogit",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  opts = { disable_commit_confirmation = true },
  keys = functions.prefixed_keys({
    {
      "s",
      function()
        require("neogit").open()
      end,
      desc = "Status",
    },
    {
      "c",
      function()
        require("neogit").open({ "commit" })
      end,
      desc = "Commit",
    },
    {
      "p",
      function()
        require("neogit").open({ "pull" })
      end,
      desc = "Pull",
    },
    {
      "P",
      function()
        require("neogit").open({ "push" })
      end,
      desc = "Push",
    },
  }, "<leader>g"),
}
