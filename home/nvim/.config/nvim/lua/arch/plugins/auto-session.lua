return {
	"rmagatti/auto-session",
	lazy = false,

	opts = {
		enabled = true,
		auto_save = true,
		auto_restore = true,
		auto_create = true,
		auto_restore_last_session = false,
		cwd_change_handling = false,
		single_session_mode = false,

		suppressed_dirs = { "~/" },

		git_use_branch_name = true,
		git_auto_restore_on_branch_change = false,

		bypass_save_filetypes = { "alpha", "dashboard" },

		---@type SessionLens
		session_lens = {
			picker = "telescope",
			load_on_setup = true,
			picker_opts = {
				theme = "dropdown",
				previewer = true,
				sorting_strategy = "descending",
				selection_strategy = "reset",
				scroll_strategy = "cycle",
				layout_strategy = "horizontal",
				layout_config = {
					height = 0.9,
					width = 0.8,
					preview_cutoff = 120,
					prompt_position = "bottom",
				},
				border = true,
				borderchars = {
					prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				prompt_title = "Prompt",
				results_title = "Sessions",
			},
			previewer = "summary",
			shorten_paths = true,

			---@type SessionLensMappings
			mappings = {
				delete_session = { {"i", "n"}, "<C-d>" },
				alternate_session = { {"i", "n"}, "<C-s>" },
				copy_session = { {"i", "n"}, "<C-y>" },
			},
		},
	},

	config = function(_, opts)
		require("auto-session").setup(opts)

		local keymap = vim.keymap

		keymap.set("n", "<leader>fw", "<cmd>AutoSession search<CR>", { desc = "Search sessions" })
		keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session" })
		keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session" })
		keymap.set("n", "<leader>wd", "<cmd>AutoSession delete<CR>", { desc = "Delete session" })
		vim.keymap.set("n", "<leader>wS", function()
			vim.ui.input({ prompt = "Session name: " }, function(name)
				if name and name ~= "" then
					vim.cmd("AutoSession save " .. name)
				end
			end)
		end, { desc = "Save session with name" })
		keymap.set("n", "<leader>wR", function()
			vim.ui.input({ prompt = "Restore session: " }, function(name)
				if name and name ~= "" then
					vim.cmd("AutoSession restore " .. name)
				end
			end)
		end, { desc = "Restore session with name" })
		keymap.set("n", "<leader>wD", function()
			vim.ui.input({ prompt = "Delete session: " }, function(name)
				if name and name ~= "" then
					vim.cmd("AutoSession delete " .. name)
				end
			end)
		end, { desc = "Delete session with name" })
	end,
}
