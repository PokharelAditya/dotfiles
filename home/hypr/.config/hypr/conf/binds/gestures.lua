hl.config({
	gestures = {
	},
})

hl.gesture({ fingers = 2, direction = "pinch", mods = MOD, action = "cursor_zoom", zoom_level = 1.2, mode = "live" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
hl.gesture({ fingers = 3, direction = "swipe", mods = MOD, action = "resize" })
hl.gesture({
	fingers = 4,
	direction = "left",
	action = function()
		hl.exec_cmd("playerctl pause")
	end,
})
hl.gesture({
	fingers = 4,
	direction = "right",
	action = function()
		hl.exec_cmd("playerctl play")
	end,
})
hl.gesture({
	fingers = 4,
	direction = "left",
	mods = MOD,
	action = function()
		hl.exec_cmd("playerctl previous")
	end,
})
hl.gesture({
	fingers = 4,
	direction = "right",
	mods = MOD,
	action = function()
		hl.exec_cmd("playerctl next")
	end,
})
-- hl.gesture({ fingers = 4, direction = "horizontal", action = })
