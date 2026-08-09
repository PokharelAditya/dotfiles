return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-o>"] = actions.select_default,
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = require("telescope.actions").close,
						["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
					n = {
						["o"] = actions.select_default,
						["t"] = actions.select_tab,
						["x"] = actions.select_horizontal,
						["v"] = actions.select_vertical,
						["q"] = require("telescope.actions").close,
						["d"] = require("telescope.actions").delete_buffer,
					},
				},
			},
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function()
				vim.wo.wrap = true
				vim.wo.linebreak = true
        vim.wo.breakindent = true
			end,
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>Telescope frecency workspace=CWD<cr>",
			{ desc = "Frecency find files in cwd" }
		)
		keymap.set("n", "<leader>fa", "<cmd>Telescope frecency<cr>", { desc = "Frecency find files" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fp", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
			{ desc = "Find Buffers" }
		)
	end,
}
