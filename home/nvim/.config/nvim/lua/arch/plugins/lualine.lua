return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			blue = "#65D1FF",
      light_blue = "#89b4fa",
			green = "#3EFFDC",
      light_green = "#a6e3a1",
			yellow = "#FFDA7B",
      light_yellow = "#f9e2af",
			red = "#FF4A4A",
      light_red = "#f38ba8",
      orange = "#ff9e64",
      light_orange = "#fab387",
			violet = "#FF61EF",
      light_violet = "#f5c2e7",
      magenta = "#cba6f7",
      cyan = "#89dceb",

			fg = "#c3ccdc",
      main_fg = "#111111",
			bg = "NONE",
			inactive_bg = "NONE",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.light_blue, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.light_green, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.light_violet, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.light_yellow, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.light_red, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			terminal = {
				a = { bg = colors.light_orange, fg = colors.main_fg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
			},
			sections = {
        lualine_a = {
          {
            'mode',
            separator = { left = '', right = '' },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            'branch',
            icon = "",
						color = { fg = colors.light_green },
            padding = { left = 2, right = 1 },
          },
          {
            'diff',
            colored = true,
            padding = { left = 1, right = 1 },
          },
          {
            'diagnostics',
            padding = { left = 2, right = 1 },
          },
          {
            function()
              return require("auto-session.lib").current_session_name(true)
            end,
            icon = "",
            color = { fg = colors.green },
          },
        },
				lualine_c = {
					{
						"filename",
            color = { fg = colors.blue },
            path = 3,
            shorting_target = 40,
						file_status = true,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
            padding = { left = 1, right = 1 },
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.light_yellow },
            padding = { left = 1, right = 2 },
					},
					{
            "encoding",
            color = { fg = colors.light_violet },
            padding = { left = 1, right = 2 },
          },
					{
            "fileformat",
            color = { fg = colors.cyan },
            padding = { left = 1, right = 2 },
          },
					{
            "filetype",
            colored = false,
            color = { fg = colors.magenta },
            padding = { left = 2, right = 1 },
          },
				},
        lualine_y = {
          {
            'progress',
						color = { fg = colors.light_green },
            padding = { left = 1, right = 1 },
          },
          -- {
          --   'searchcount',
          --   padding = { left = 1, right = 1 },
          -- },
          -- {
          --   'selectioncount',
          --   padding = { left = 1, right = 1 },
          -- },
          -- {
          --   'tabs',
          --   padding = { left = 1, right = 1 },
          -- },
          -- {
          --   'windows',
          --   padding = { left = 1, right = 1 },
          -- },
					-- {
          --  "buffers",
          --  padding = { left = 1, right = 1 },
          -- },
          -- {
          --   'lsp_status',
          --   padding = { left = 1, right = 1 },
          -- },
        },
        lualine_z = {
          {
            'location',
            separator = { left = '', right = '' },
            padding = { left = 1, right = 1 },
          }
        },
			},
      inactive_sections = {
				lualine_c = {
          {
					  function()
              local dir = vim.fn.expand('%:p:h'):gsub(os.getenv("HOME"), "~")
              return dir
            end,
				  },
          {
            "filename",
            file_status = true,
				  },
        },
      }
		})
	end,
}
