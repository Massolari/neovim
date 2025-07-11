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
    },
  },
}
