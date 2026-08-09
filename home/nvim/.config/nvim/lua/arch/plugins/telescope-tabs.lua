return {
	"LukasPietzschmann/telescope-tabs",

	dependencies = {
    "nvim-telescope/telescope.nvim"
  },

  config = function()
    require("telescope").load_extension("telescope-tabs")

    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<leader>ft", "<cmd>Telescope telescope-tabs list_tabs sort_mru=true sort_lastused=true initial_mode=normal<cr>", { desc = "Find tabs" })
  end,
}
