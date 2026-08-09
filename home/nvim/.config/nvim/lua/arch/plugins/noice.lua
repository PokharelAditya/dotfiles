return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
    -- dependencies = {
      -- "rcarriga/nvim-notify", --only used when using notify instead of mini
    -- },
		opts = {
      presets = {
        bottom_search = false,
        command_palette = true,
      },
			messages = {
				enabled = true, -- enables the Noice messages UI
				view = "mini", -- default view for messages
				view_error = "mini", -- view for errors
				view_warn = "mini", -- view for warnings
				view_history = "messages", -- view for :messages
				view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
			},
			notify = {
				enabled = true,
				view = "mini",
			},
			lsp = {
        progress = {
          enabled = true,
					view = "mini",
        },
				message = {
					enabled = true,
					view = "mini",
				},
			},
			views = {
				cmdline_popup = {
					position = {
						row = "90%",
						col = "50%",
					},
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
				},
				cmdline_popupmenu = {
					position = {
						row = "72%",
						col = "50%",
					},
          size = {
            height = "40%",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
				},
				mini = {
					timeout = 3000, -- timeout in milliseconds
					align = "center",
					position = {
						row = "95%",
						col = "100%",
					},
          size = "auto",
					win_options = {
						wrap = true, -- this enables line wrapping
						linebreak = true, -- wraps at word boundaries
					},
				},
			},
    },
	},
}
