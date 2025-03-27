return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "petertriho/cmp-git",
    "hrsh7th/cmp-path",
    "garymjr/nvim-snippets",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local disabled_sources = (vim.g.disabled_cmp_sources or {})
    local default_sources

    default_sources = {
      { name = "nvim_lsp" },
      { name = "snippets" },
      { name = "path" },
      { name = "git" },
      {
        name = "buffer",
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      { name = "calc" },
      { name = "emoji" },
    }

    local sources = vim.tbl_filter(function(source)
      return not vim.tbl_contains(disabled_sources, source.name)
    end, default_sources)

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      view = { entries = { follow_cursor = true } },
      mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-.>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ["<C-p>"] = function(fallback)
          if cmp.visible() then
            return cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            return fallback()
          end
        end,
        ["<C-n>"] = function(fallback)
          if cmp.visible() then
            return cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            return fallback()
          end
        end,
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      },
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          before = function(entry, vim_item)
            vim_item.menu = vim_item.kind
            vim_item.kind = (lspkind.presets.codicons[vim_item.kind] or vim_item.kind) .. " "

            return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
          end,
        }),
      },
      sources = sources,
    })

    require("cmp_git").setup()

    cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
