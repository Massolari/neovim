local M = {}

--- Show a notification
--- @param message string
--- @param level number
--- @param title string
--- @param options? table
local function show_notification(message, level, title, options)
  options = options or {}
  options.title = title
  vim.notify(message, level, options)
end

--- Show a warning notification
--- @param message string
--- @param title string
--- @param options? table
M.show_warning = function(message, title, options)
  show_notification(message, vim.log.levels.WARN, title, options)
end

--- Show an info notification
--- @param message string
--- @param title string
--- @param options? table
M.show_info = function(message, title, options)
  show_notification(message, vim.log.levels.INFO, title, options)
end

--- Show an error notification
--- @param message string
--- @param title string
--- @param options? table
M.show_error = function(message, title, options)
  show_notification(message, vim.log.levels.ERROR, title, options)
end

--- Check if the quickfix or location list is open
--- @param window "quickfix" | "location"
--- @return boolean
local function is_location_quickfix_open(window)
  local query = "v:val.loclist"
  if window == "quickfix" then
    query = "v:val.quickfix && !v:val.loclist"
  end

  local windows = vim.fn.getwininfo()
  local wanted_windows = vim.fn.filter(windows, query)
  return vim.fn.len(wanted_windows) > 0
end

--- Toggle the quickfix window
M.toggle_quickfix = function()
  local is_open = is_location_quickfix_open("quickfix")
  if is_open then
    return vim.cmd.cclose()
  else
    return vim.cmd("botright copen 10")
  end
end

--- Toggle the location list window
M.toggle_location_list = function()
  local is_open = is_location_quickfix_open("location")
  if is_open then
    vim.cmd.lclose()
    return
  end

  local status, err = pcall(vim.cmd([[--@as function]]), "lopen 10")
  if not status then
    M.show_warning(err, "Location list")
  end
end

--- Prompts the user for an input and passes the result to a function.
--- @generic T
--- @param prompt string The message displayed to the user
--- @param fun fun(any): T The function that will be called with the user input
--- @param default? T Default value to be used if the user does not provide input
--- @return T|nil - The result of executing the `fun` function with the provided input, or nil if an error occurs
M.with_input = function(prompt, fun, default)
  local status, maybe_input = nil, nil
  status, maybe_input = pcall(vim.fn.input, prompt, "")
  local input = maybe_input

  if (maybe_input == "") and (default ~= nil) then
    input = default
  end

  if status then
    return fun(input)
  end
end

--- Prompts the user for an input and searches for the provided text.
--- The search is performed using the `grep` command.
M.grep = function()
  local search_status, input = pcall(vim.fn.input, "Procurar por: ")
  if not search_status or (input == "") then
    return M.show_info("Pesquisa cancelada", "RipGrep")
  else
    local status, err = pcall(vim.cmd([[--@as function]]), ('silent grep! "' .. input .. '"'))
    if not status then
      return M.show_error(err, "Busca")
    else
      return vim.cmd.copen()
    end
  end
end

--- Check if a file exists
--- @param filename string
--- @return boolean
M.file_exists = function(filename)
  return vim.fn.filereadable(filename) > 0
end

--- Check if a directory exists
--- @param path string
--- @return boolean
M.dir_exists = function(path)
  return (vim.fn.isdirectory(path) > 0)
end

math.randomseed(os.time())

--- Get a random number
--- @param max number
--- @return number
M.get_random = function(max)
  return math.random(max)
end

--- Get a random item from a list
--- @generic T
--- @param list table<T>
--- @return T
M.get_random_item = function(list)
  return list[M.get_random(#list)]
end

--- Apply a prefix to each key in a list of mappings
--- @param mappings table
--- @param prefix string
M.prefixed_keys = function(mappings, prefix)
  local new_mappings = {}
  for index, mapping in ipairs(mappings) do
    ---@type string
    local keys = mapping[1]
    ---@type string|function
    local cmd = mapping[2]
    ---@type table<string, any>
    local map_options = mapping

    local new_mapping = vim.tbl_extend("keep", { (prefix .. keys), cmd }, map_options)
    if nil ~= new_mapping then
      new_mappings[index] = new_mapping
    else
    end
  end

  return new_mappings
end

--- Helper function to set key mappings
--- @param mode string
--- @param keys table
--- @param options? table
M.keymaps_set = function(mode, keys, options)
  local global_options = (options or {})
  local prefix = (global_options.prefix or "")
  global_options.prefix = nil
  for _, _17_ in ipairs(keys) do
    local lhs = _17_[1]
    local rhs = _17_[2]
    local _3flocal_options = _17_[3]
    vim.keymap.set(mode, (prefix .. lhs), rhs, vim.tbl_extend("force", global_options, (_3flocal_options or {})))
  end
  return nil
end

--- Get a language for the silicon command based on the file extension
--- @param file_extension string
--- @return string
local function get_silicon_language(file_extension)
  if file_extension == "fnl" then
    return "clj"
  elseif file_extension == "gleam" then
    return "rust"
  else
    return file_extension
  end
end

--- Generate an image from the code
--- @param args table
M.generate_code_image = function(args)
  local line1 = args["line1"]
  local line2 = args["line2"]

  local data_path = vim.fn.stdpath("data")
  local code_temp_file = (data_path .. "/code-silicon.code")
  local img_temp_file = (data_path .. "/image-silicon.png")

  local language = get_silicon_language(vim.fn.expand("%:e"))

  local lines = vim.api.nvim_buf_get_lines(0, (line1 - 1), line2, false)

  local notify_title = "Silicon"
  vim.fn.delete(code_temp_file)
  vim.fn.delete(img_temp_file)
  vim.fn.writefile(lines, code_temp_file)
  local silicon_cmd = string.format(
    "silicon -l %s -o %s < %s",
    language,
    vim.fn.shellescape(img_temp_file),
    vim.fn.shellescape(code_temp_file)
  )
  local silicon_result = vim.fn.system(silicon_cmd)
  local silicon_exit_code = vim.fn.system("echo $status")
  vim.fn.delete(code_temp_file)

  if (silicon_result ~= "") or (silicon_exit_code ~= "0\n") then
    M.show_error(silicon_result, notify_title)
    return
  end

  local osascript_cmd =
    string.format("osascript -e 'set the clipboard to (POSIX file \"%s\")'", vim.fn.shellescape(img_temp_file))
  local copy_result = vim.fn.system(osascript_cmd)
  if copy_result == "" then
    M.show_info("Imagem de c\195\179digo copiada para o clipboard", notify_title)
    return
  end
  return M.show_error(copy_result, notify_title)
end

--- Configuration options for LSP servers
M.lsp_config_options = {
  elixirls = function()
    return { cmd = { "elixir-ls" } }
  end,
  lua_ls = function()
    local function _24_(client)
      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = { version = "LuaJIT" },
        diagnostics = { unusedLocalIgnore = { "_*" } },
        hint = { enable = true },
        workspace = { library = { vim.env.VIMRUNTIME } },
      })
      return nil
    end
    return { on_init = _24_, settings = { Lua = {} } }
  end,
  ltex_plus = function(default_config)
    return {
      root_dir = vim.uv.cwd,
      filetypes = { "octo", _G.unpack(default_config.filetypes) },
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
  fennel_ls = function()
    return { settings = { ["fennel-ls"] = { libraries = {}, ["extra-globals"] = "vim unpack" } } }
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
  ts_ls = function()
    return {
      init_options = {
        preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    }
  end,
  yamlls = function()
    return { settings = { yaml = { keyOrdering = false } } }
  end,
}

--- Start the LTeX server
M.start_ltex = function()
  vim.ui.input({ prompt = "Language: ", default = "pt-BR" }, function(language)
    if (language == "") or (language == nil) then
      return
    end

    local lspconfig = require("lspconfig")
    local config = M.lsp_config_options.ltex(lspconfig.ltex.document_config.default_config)
    lspconfig.ltex.setup(vim.tbl_extend("force", config, { settings = { ltex = { language = language } } }))
  end)
end

--- Get the key to insert
--- @param key string
--- @return string
M.get_key_insert = function(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

return M
