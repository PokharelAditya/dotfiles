---------------
---- INPUT ----
---------------

hl.config({
	input = {
		accel_profile = "flat",
		sensitivity = -0.2,

		follow_mouse = 1,
		focus_on_close = 0,
		follow_mouse_shrink = 20,
		follow_mouse_threshold = 30,
		mouse_refocus = true,

		natural_scroll = false,
		scroll_button = 274,
		scroll_method = "on_button_down",
		scroll_button_lock = true,
		scroll_factor = 2,
		off_window_axis_events = 2,

		kb_layout = "us",
		numlock_by_default = true,
    repeat_delay = 300,
    repeat_rate = 40,

		touchpad = {
      tap_to_click = true,
      tap_button_map = "lrm",
      tap_and_drag = true,
      drag_lock = 2,
			natural_scroll = true,
			scroll_factor = 0.25,
      disable_while_typing = true,
		},

		touchdevice = {
      enabled = true,
      output = "huaweiTab"
    },
	},

	cursor = {
		no_hardware_cursors = 1,
	},
})

hl.device({
	name = "asup1205:00-093a:2003-touchpad",

	sensitivity = 1,
	scroll_method = "2fg",
})

require("scripts.huaweiTab.touch-keep-focus")
