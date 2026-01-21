--- @type LazyPluginSpec
return {
  "folke/sidekick.nvim",
  config = function()
    require("sidekick").setup()

    vim.keymap.set({ "n", "i" }, "<tab>", function()
      -- if there is a next edit, jump to it, otherwise apply it if any
      if require("sidekick").nes_jump_or_apply() then
        return
      end

      if vim.lsp.inline_completion.get() then
        return
      end

      return "<Tab>" -- fallback to normal tab
    end, { expr = true, desc = "Ir/Aplicar NES (Next Edit Suggestion)" })

    vim.keymap.set("n", "<c-q>", function()
      -- if there is a next edit, jump to it, otherwise apply it if any
      require("sidekick.nes").update()
    end, { desc = "Atualizar NES" })

    vim.keymap.set({ "n", "x", "i", "t" }, "<c-.>", function()
      require("sidekick.cli").toggle()
    end, { desc = "Alterar foco com Sidekick" })

    vim.keymap.set({ "n", "v" }, "<leader>iss", function()
      require("sidekick.cli").toggle({ focus = true })
    end, { desc = "Alternar CLI" })

    vim.keymap.set({ "n", "v" }, "<leader>isp", function()
      require("sidekick.cli").select_prompt()
    end, { desc = "Perguntar" })

    vim.keymap.set({ "n", "v" }, "<leader>isf", function()
      require("sidekick.cli").send({ msg = "{file}" })
    end, { desc = "Enviar arquivo" })
  end,
}
