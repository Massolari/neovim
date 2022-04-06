local lsp_status = require'lsp-status'
local illuminate = require'illuminate'

local mappings = require'mappings'



local border = {
{"┌", "FloatBorder"},
{"─", "FloatBorder"},
{"┐", "FloatBorder"},
{"│", "FloatBorder"},
{"┘", "FloatBorder"},
{"─", "FloatBorder"},
{"└", "FloatBorder"},
{"│", "FloatBorder"},
}

local activate_code_lens = function(client)
  if client.resolved_capabilities.code_lens then
    vim.api.nvim_exec(
      [[
      augroup lsp_code_lens_refresh
      autocmd! * <buffer>
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
      augroup END
      ]],
      false
    )
  end
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_status.on_attach(client)
  client.config.capabilities = vim.tbl_extend('keep', client.config.capabilities or {}, lsp_status.capabilities)

  -- Mappings.
  mappings.lsp(client, bufnr)

  -- Destacar palavras
  illuminate.on_attach(client)

  activate_code_lens(client)
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = 'x', -- Could be '●', '▎', '■'
    },
  })

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)


local get_tailwind_config = function()
  local opts = {
    filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "edge", "eelixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "elm" },
    init_options = {
      userLanguages = {
        elm = "html",
        eelixir = "html-eex",
        eruby = "erb"
      }
    },
    settings = {
      tailwindCSS = {
        classAttributes = { "class", "className", "classList", "ngClass" },
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidConfigPath = "error",
          invalidScreen = "error",
          invalidTailwindDirective = "error",
          invalidVariant = "error",
          recommendedVariantOrder = "warning"
        },
        validate = true,
        experimental = {
          classRegex = {
            "\\bclass\\s+\"([^\"]*)\""
          }
        }
      },
    }
  }

  return opts
end

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  local custom_opts = {}
  if server.name == 'tailwindcss' then
    custom_opts = vim.tbl_extend('keep', get_tailwind_config(), opts)
  end
  opts = vim.tbl_extend('keep', custom_opts, opts)

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
