return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { winopts = { backdrop = 100 }, files = { formatter = { "path.filename_first", 2 } } },
  cmd = "FzfLua",
  keys = {
    {
      "<leader>b",
      function()
        require("fzf-lua").buffers({ winopts = { width = 0.4, height = 0.6, preview = { layout = "vertical" } } })
      end,
      desc = "Buffers",
    },
    {
      "<leader>cp",
      function()
        require("fzf-lua").lsp_workspace_symbols()
      end,
      desc = "Buscar símbolos no projeto",
    },
    {
      "<leader>ee",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "Comandos do Fzf-lua",
    },
    {
      "<leader>ehf",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("data") .. "/rest" })
      end,
      desc = "Abrir",
    },
    {
      "<leader>el",
      function()
        require("fzf-lua").blines({ winopts = { split = "belowright new" } })
      end,
      desc = "Pesquisar nas linhas do buffer",
    },
    {
      "<leader>enf",
      function()
        require("fzf-lua").files({ cwd = vim.g.obsidian_dir, hidden = false })
      end,
      desc = "Abrir arquivo",
    },
    {
      "<leader>er",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Arquivos recentes",
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").files()
      end,
      desc = "Buscar (find) arquivo",
    },
    {
      "<leader>gi",
      function()
        require("fzf-lua").git_bcommits()
      end,
      desc = "Histórico de commits do arquivo atual",
    },
    {
      "<leader>gr",
      function()
        require("fzf-lua").git_branches()
      end,
      desc = "Listar branches",
    },
    {
      "gO",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "Buscar símbolos no arquivo",
    },
    {
      "<leader>o",
      function()
        require("fzf-lua").treesitter()
      end,
      desc = "Buscar símbolos no arquivo com treesitter",
    },
    {
      "<leader>pe",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Procurar texto sob cursor",
    },
    {
      "<leader>pz",
      function()
        require("fzf-lua").zoxide()
      end,
      desc = "Zoxide",
    },
    {
      "<leader>ps",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Procurar (search) nos arquivos",
    },
    {
      "gri",
      function()
        require("fzf-lua").lsp_implementations()
      end,
      desc = "Implementações",
    },
    {
      "grr",
      function()
        require("fzf-lua").lsp_references()
      end,
      desc = "Referências",
    },
    {
      "gY",
      function()
        require("fzf-lua").lsp_typedefs()
      end,
      desc = "Definição do tipo",
    },
  },
}
