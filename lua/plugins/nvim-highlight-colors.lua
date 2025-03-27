return {
  "brenoprata10/nvim-highlight-colors",
  event = "BufReadPre",
  keys = { { "<leader>eo", "<cmd>HighlightColors Toggle<cr>", desc = "Alternar visualiza\195\167\195\163o de cores" } },
  opts = { enable_tailwind = true, render = "virtual" },
  config = true,
}

