local M = {}

local notify = require("notify")

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

  local status, err = pcall(vim.cmd, "lopen 10")
  if not status then
    notify.warning(err, "Location list")
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
    return notify.info("Pesquisa cancelada", "RipGrep")
  else
    local status, err = pcall(vim.cmd([[--@as function]]), ('silent grep! "' .. input .. '"'))
    if not status then
      return notify.error(err, "Busca")
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
  for _, key in ipairs(keys) do
    local lhs = key[1]
    local rhs = key[2]
    local key_options = key[3]
    vim.keymap.set(mode, (prefix .. lhs), rhs, vim.tbl_extend("force", global_options, (key_options or {})))
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

--- Generate a code image from a range of lines in the current buffer.
--- The generated image is created using the `silicon` command and copied to the clipboard.
---
--- @param args table A table containing the following fields:
---   - line1 (number): The starting line of the range (1-based).
---   - line2 (number): The ending line of the range (1-based).
---
--- The function performs the following steps:
--- 1. Retrieves the lines from the buffer within the specified range.
--- 2. Writes the lines to a temporary file.
--- 3. Executes the `silicon` command to generate a code image.
--- 4. Copies the generated image to the clipboard using `osascript` (macOS-specific).
--- 5. Cleans up temporary files.
---
--- Notifications are displayed for success or failure during the process.
M.generate_code_image = function(args)
  local line1, line2 = args.line1, args.line2

  local data_path = vim.fn.stdpath("data")
  local code_temp_file = data_path .. "/code-silicon.code"
  local img_temp_file = data_path .. "/image-silicon.png"

  local language = get_silicon_language(vim.fn.expand("%:e"))
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

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
  local silicon_exit_code = vim.v.shell_error
  vim.fn.delete(code_temp_file)

  if silicon_exit_code ~= 0 then
    notify.error(silicon_result, notify_title)
    return
  end

  local osascript_cmd = string.format("osascript -e 'set the clipboard to (POSIX file \"%s\")'", img_temp_file)
  local copy_result = vim.fn.system(osascript_cmd)

  if copy_result == "" then
    notify.info("Code image copied to clipboard", notify_title)
  else
    notify.error(copy_result, notify_title)
  end
end

--- Get the key to insert
--- @param key string
--- @return string
M.get_key_insert = function(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

--- Insert a character at the end of the current line without moving the cursor
function InsertEndOperator()
  local ok, char = pcall(vim.fn.getcharstr)
  if not ok or char == "\27" then
    return
  end
  local column = vim.fn.col(".")
  vim.cmd("normal! A" .. char .. "")
  vim.fn.cursor(vim.fn.line("."), column)
end

return M
