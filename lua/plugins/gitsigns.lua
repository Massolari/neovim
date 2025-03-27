return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPre",
  opts = {
    on_attach = function(_)
      local gs = require("gitsigns")

      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end

        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { buffer = true, expr = true, desc = "Próximo git hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end

        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { buffer = true, expr = true, desc = "Git hunk anterior" })

      vim.keymap.set("n", "<leader>ghu", gs.reset_hunk, { buffer = true })

      vim.keymap.set("v", "<leader>ghu", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = true, desc = "Desfazer (undo)" })

      vim.keymap.set("n", "<leader>ghv", gs.preview_hunk, { buffer = true, desc = "Ver" })

      vim.keymap.set("n", "<leader>gbb", function()
        gs.blame_line({ full = true, desc = "Linha" })
      end)
    end,
    current_line_blame = true,
    current_line_blame_opts = { delay = 0 },
    linehl = false,
    numhl = false,
  },
}
