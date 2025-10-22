--- @type LazyPluginSpec
return {
  "folke/sidekick.nvim",
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return
        end

        if vim.lsp.inline_completion.get() then
          return
        end

        return "<Tab>" -- fallback to normal tab
      end,
      expr = true,
      desc = "Ir/Aplicar NES (Next Edit Suggestion)",
      mode = { "n", "i" },
    },
    {
      "<c-q>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        require("sidekick.nes").update()
      end,
      desc = "Atualizar NES",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Alterar foco com Sidekick",
    },
    {
      "<leader>iss",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Alternar CLI",
      mode = { "n", "v" },
    },
    {
      "<leader>isp",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Perguntar",
      mode = { "n", "v" },
    },
    {
      "<leader>isf",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Enviar arquivo",
      mode = { "n", "v" },
    },
  },
}
