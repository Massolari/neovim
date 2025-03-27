return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  config = true,
  keys = { { "<leader>et", "<cmd>Mason<CR>", desc = "Ferramentas (Mason)" } },
  opts = { registries = { "github:mason-org/mason-registry", "github:visimp/mason-registry" } },
}

