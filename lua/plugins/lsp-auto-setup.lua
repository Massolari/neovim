local functions = require("functions")

-- local plugin_dir = vim.g.local_plugins_dir .. "/lsp-auto-setup.nvim"

--- @type LazyPluginSpec
return {
  "Massolari/lsp-auto-setup.nvim",
  -- cond = functions.dir_exists(plugin_dir),
  -- dir = plugin_dir,
  config = true,
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    server_config = {
      ltex_plus = function(default_config)
        --- @type vim.lsp.Config
        return {
          root_dir = vim.uv.cwd,
          filetypes = { "octo", unpack(default_config.filetypes) },
          settings = {
            ltex = {
              enabled = {
                "bibtex",
                "context",
                "context.tex",
                "gitcommit",
                "html",
                "latex",
                "markdown",
                "octo",
                "org",
                "restructuredtext",
                "rsweave",
              },
            },
          },
        }
      end,
      tailwindcss = function(default_config)
        --- @type vim.lsp.Config
        return {
          settings = {
            tailwindCSS = {
              includeLanguages = { elm = "html", gleam = "html" },
              experimental = {
                classRegex = {
                  '\\bclass[\\s(<|]+"([^"]*)"',
                  '\\bclass[\\s(]+"[^"]*"[\\s+]+"([^"]*)"',
                  '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                  '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                  '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                  '\\bclassList[\\s\\[\\(]+"([^"]*)"',
                  '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
                  '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
                },
              },
            },
          },
          init_options = { userLanguages = { elm = "html", gleam = "html" } },
          filetypes = { "elm", "gleam", unpack(default_config.filetypes) },
        }
      end,
      ts_ls = function(default_config)
        --- @type vim.lsp.Config
        return {
          on_attach = function(client, bufnr)
            local cmd_description = "Go to source definition"

            vim.keymap.set("n", "gri", function()
              local position_params = vim.lsp.util.make_position_params(0, client.offset_encoding)

              client:exec_cmd({
                title = cmd_description,
                command = "_typescript.goToSourceDefinition",
                arguments = { vim.uri_from_bufnr(0), position_params.position },
              }, { bufnr = 0 }, function(error, result)
                if error then
                  vim.notify("Error when executing command: " .. error.message, vim.log.levels.ERROR)
                  return
                end
                if result and #result > 0 then
                  local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
                  vim.fn.setqflist(items)
                  vim.lsp.util.show_document(result[1], client.offset_encoding)
                end
              end)
            end, { desc = cmd_description })

            if default_config.on_attach then
              default_config.on_attach(client, bufnr)
            end
          end,
        }
      end,
    },
  },
}
