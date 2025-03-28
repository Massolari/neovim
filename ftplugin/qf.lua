--- Restores cursor position after executing a command in the quickfix window.
--- @param old_line number
local function restore_cursor_position(old_line)
  local winid = vim.fn.win_getid()
  pcall(vim.api.nvim_win_set_cursor, winid, { old_line, 0 })
end

--- Runs a function and restores the cursor position after it finishes.
--- @param f function
local function run_and_restore_cursor_position(f)
  local old_line = vim.fn.line(".")
  pcall(f)
  restore_cursor_position(old_line)
end

vim.opt_local.buflisted = false
vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
vim.keymap.set("n", "q", ":q<CR>", { buffer = true })

vim.keymap.set("n", "d", function()
  local line = vim.fn.line(".")
  local quickfix = vim.fn.getqflist()
  table.remove(quickfix, line)
  vim.fn.setqflist(quickfix)
  vim.cmd("copen")
  restore_cursor_position(line)
end, { buffer = true, nowait = true })

vim.keymap.set("n", "D", function()
  local line = vim.fn.line(".")
  local qf_list = vim.fn.getqflist()
  local current_item = qf_list[line]
  local current_bufnr = (current_item and current_item.bufnr)

  local filtered_list = {}
  for _, item in ipairs(qf_list) do
    if item.bufnr ~= current_bufnr then
      table.insert(filtered_list, item)
    end
  end

  vim.fn.setqflist(filtered_list)
  restore_cursor_position(line)
end, { buffer = true })

vim.keymap.set("n", "u", function()
  run_and_restore_cursor_position(function()
    vim.cmd("silent colder")
  end)
end, { buffer = true })

vim.keymap.set("n", "U", function()
  run_and_restore_cursor_position(function()
    vim.cmd("silent cnewer")
  end)
end, { buffer = true })

vim.keymap.set("n", "<c-r>", function()
  run_and_restore_cursor_position(function()
    vim.cmd("silent cnewer")
  end)
end, { buffer = true })

vim.keymap.set("n", "<leader>f", ":Cfilter ", { buffer = true, desc = "Filtrar items" })
