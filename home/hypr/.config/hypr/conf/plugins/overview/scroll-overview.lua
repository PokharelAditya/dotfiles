hl.config({
	plugin = {
		scrolloverview = {
			gesture_distance = 300, -- how far is the "max" for the gesture
			scale = 0.32, -- preferred overview scale
			workspace_gap = 0,
			layout = "vertical", -- vertical, horizontal, or auto (per-monitor orientation)
			cross_monitor_drag = true,
			wallpaper = 0, -- 0: global only, 1: per-workspace only, 2: both
			wallpaper_layer = "auto", -- auto, background, or bottom
			blur = false, -- blur only the main overview wallpaper

			shadow = {
				enabled = true,
				color = OVERVIEW_SHADOW,
				range = 8,
				render_power = 3,
			},

			input = {
				touchpad_scroll_factor = 4,
				scroll_event_delay = 100,
			},
		},
	},
})

require("conf.plugins.overview.shift")
require("conf.plugins.overview.binds")
