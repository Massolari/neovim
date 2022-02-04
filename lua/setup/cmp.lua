local cmp = require'cmp'
local lspkind = require'lspkind'
local luasnip = require'luasnip'
require("luasnip/loaders/from_vscode").lazy_load()

local sources = {
  { name = 'nvim_lsp' },
  { name = 'cmp_tabnine' },
  { name = 'luasnip' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'calc' },
  { name = 'emoji' },
}

-- Filter sources table using vim.g.disabled_cmp_sources variable that is a list of names
local disabled_sources = vim.g.disabled_cmp_sources or {}
local enabled_sources = {}
for _, source in ipairs(sources) do
  local is_disabled = false
  for _, disabled in ipairs(disabled_sources) do
    if source.name == disabled then
      is_disabled = true
      break
    end
  end
  if not is_disabled then
    table.insert(enabled_sources, source)
  end
end


cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },
  documentation = {
    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        path = "[Path]",
        buffer = "[Buffer]",
        calc = "[Calc]",
        nvim_lsp = "[LSP]",
        cmp_tabnine = "[TabNine]",
        luasnip = "[LuaSnip]",
        emoji = "[Emoji]",
      })[entry.source.name]
      return vim_item
    end
  },
  sources = enabled_sources,
})

vim.cmd([[imap <expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>']])
vim.cmd([[imap <expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>']])


