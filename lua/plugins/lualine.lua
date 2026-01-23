local diagnostic_icon = vim.diagnostic.config().signs.text or {}

local colors = {
  yellow = "DarkYellow",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

---@param padding table|number
local function border(padding)
  return {
    function()
      return "▊"
    end,
    color = { fg = colors.blue },
    padding = padding,
    separator = "",
  }
end

local filename = { "filename", padding = 0, color = { fg = colors.magenta, gui = "bold" } }
local filename_path = vim.tbl_extend("force", filename, { path = 1 })

--- @type LazyPluginSpec
return {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.started_by_firenvim,
  event = "VimEnter",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      opts = {
        override = { gleam = { icon = " ", color = "#ffaff3", cterm_color = "219", name = "Gleam" } },
      },
    },
  },
  opts = {
    options = {
      disabled_filetypes = { statusline = { "dashboard" }, winbar = { "dashboard", "kulala_ui", "neoment_room" } },
      component_separators = "·",
      globalstatus = vim.o.laststatus == 3,
      section_separators = "",
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        border({ right = 1 }),
        { "mode", separator = "", padding = { right = 1 } },
        { "filetype", icon_only = true, padding = 0, separator = "" },
        filename_path,
        { "location", padding = { left = 1 }, separator = "" },
        { "progress", padding = { left = 1, right = 1 }, color = { gui = "bold" }, separator = "" },
        {
          "diagnostics",
          symbols = {
            error = diagnostic_icon[vim.diagnostic.severity.ERROR] .. " ",
            warn = diagnostic_icon[vim.diagnostic.severity.WARN] .. " ",
            info = diagnostic_icon[vim.diagnostic.severity.INFO] .. " ",
            hint = diagnostic_icon[vim.diagnostic.severity.HINT],
          },
          separator = "",
        },
        {
          function()
            return vim.fn.reg_recording()
          end,
          cond = function()
            return "" ~= vim.fn.reg_recording()
          end,
          icon = "󰑊",
          separator = "",
          color = { fg = colors.red, gui = "bold" },
        },
        {
          function()
            return "%="
          end,
          separator = "",
        },
        { "lsp_status", ignore_lsp = { "copilot" } },
      },
      lualine_x = {
        { "searchcount", separator = "" },
        {
          function()
            local clients = vim.lsp.get_clients({ name = "copilot" })
            if #clients > 0 then
              return " "
            else
              return " "
            end
          end,
          separator = "",
        },
        { "branch", icon = " ", color = { fg = colors.violet, gui = "bold" }, separator = "" },
        border(0),
      },
      lualine_y = {},
      lualine_z = {},
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        border({ right = 1 }),
        filename,
        { "navic", color = { gui = "bold" } },
      },
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { border({ right = 1 }), { "filename", padding = 0 }, { "navic", color = { gui = "bold" } } },
    },
  },
  config = true,
}
