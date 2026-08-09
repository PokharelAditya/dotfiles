return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		lang = "cpp",
		storage = {
			home = vim.fn.stdpath("data") .. "/leetcode",
			cache = vim.fn.stdpath("cache") .. "/leetcode",
		},
		editor = {
			reset_previous_code = false,
		},
		picker = { provider = telescope },
	},

	config = function(_, opts)
		require("leetcode").setup(opts)

		vim.keymap.set("n", "<leader>lm", "<cmd>Leet menu<CR>", { desc = "Leetcode Menu" })
		vim.keymap.set("n", "<leader>lc", "<cmd>Leet console<CR>", { desc = "Console" })
		vim.keymap.set("n", "<leader>li", "<cmd>Leet info<CR>", { desc = "Info" })
		vim.keymap.set("n", "<leader>lt", "<cmd>Leet tabs<CR>", { desc = "Tabs" })
		vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>", { desc = "Run Tests" })
		vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", { desc = "Submit Code" })
		vim.keymap.set("n", "<leader>ld", "<cmd>Leet desc<CR>", { desc = "Description" })
		vim.keymap.set("n", "<leader>ll", "<cmd>Leet list<CR>", { desc = "List" })
		vim.keymap.set("n", "<leader>lo", "<cmd>Leet open<CR>", { desc = "Open in browser" })
		vim.keymap.set("n", "<leader>lL", "<cmd>Leet last_submit<CR>", { desc = "Replace code to last submitted" })
		vim.keymap.set("n", "<leader>lR", "<cmd>Leet reset<CR>", { desc = "Reset code to default" })
	end,
}
