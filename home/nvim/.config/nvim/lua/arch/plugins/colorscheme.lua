return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
        transparent = true,
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})

			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
			vim.cmd([[highlight Folded guibg=#69696950 guifg=#eeeeee]])

      vim.cmd[[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi NormalSB guibg=NONE ctermbg=NONE
        hi NormalFloat guibg=NONE ctermbg=NONE
        
        hi Float guibg=NONE ctermbg=NONE
        hi FloatBorder guibg=NONE ctermbg=NONE
        hi FloatTitle guibg=NONE ctermbg=NONE

        hi NvimTreeNormal guibg=NONE ctermbg=NONE
        hi NvimTreeNormalNC guibg=NONE ctermbg=NONE

        hi StatusLine guibg=NONE ctermbg=NONE
        hi StatusLineNC guibg=NONE ctermbg=NONE

        hi TelescopeNormal guibg=NONE ctermbg=NONE
        hi TelescopeBorder guibg=NONE ctermbg=NONE
        hi TelescopePromptNormal guibg=NONE ctermbg=NONE
        hi TelescopePromptBorder guibg=NONE ctermbg=NONE
        hi TelescopePromptTitle guibg=NONE ctermbg=NONE
        hi TelescopeResultsNormal guibg=NONE ctermbg=NONE
        hi TelescopeResultsBorder guibg=NONE ctermbg=NONE
        hi TelescopeResultsTitle guibg=NONE ctermbg=NONE
        hi TelescopePreviewNormal guibg=NONE ctermbg=NONE
        hi TelescopePreviewBorder guibg=NONE ctermbg=NONE
        hi TelescopePreviewTitle guibg=NONE ctermbg=NONE

        hi Pmenu guibg=NONE ctermbg=NONE 
        hi PmenuSbar guibg=NONE ctermbg=NONE 

        hi WhichKeyNormal guibg=NONE ctermbg=NONE

        hi DiagnosticVirtualTextInfo guibg=NONE ctermbg=NONE
        hi DiagnosticVirtualTextWarn guibg=NONE ctermbg=NONE
        hi DiagnosticVirtualTextError guibg=NONE ctermbg=NONE

        hi TroubleNormal guibg=NONE ctermbg=NONE
        hi TroubleNormalNC guibg=NONE ctermbg=NONE
      ]]
		end,
	},
}
