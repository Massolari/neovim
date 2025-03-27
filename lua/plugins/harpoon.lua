local functions = require("functions")

return {
  "ThePrimeagen/harpoon",
  config = true,
  keys = {
    {
      "<leader><space>",
      function()
        require("harpoon.mark").add_file()
        functions.show_info("Arquivo marcado", "Harpoon")
      end,
      desc = "Marcar arquivo com harpoon",
    },
    {
      "<leader>ph",
      function()
        return require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Mostrar marcas do harpoon",
    },
    unpack(vim.tbl_map(function(n)
      return {
        ("<leader>" .. n),
        function()
          return require("harpoon.ui").nav_file(n)
        end,
        desc = ("Ir para marca " .. n .. " do harpoon"),
      }
    end, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 })),
  },
}
