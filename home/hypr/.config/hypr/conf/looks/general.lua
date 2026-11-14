-----------------------
---- GENERAL LOOKS ----
-----------------------

hl.config({
	general = {
		allow_tearing = false,

		gaps_in = 5,
		gaps_out = 10,
		gaps_workspaces = 0,
		float_gaps = { top = 10, bottom = 10, left = 10, right = 10 },

		border_size = 2,
		resize_on_border = false,
		resize_corner = false,
		no_focus_fallback = true,

		col = {
			active_border = ACTIVE_BORDER,
			inactive_border = INACTIVE_BORDER,
		},

		snap = {
			enabled = true,
			border_overlap = false,
			respect_gaps = true,
			monitor_gap = 12,
			window_gap = 12,
		},
	},
})
