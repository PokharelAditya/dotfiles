--------------------
---- DECORATION ----
--------------------

hl.config({
	decoration = {
		active_opacity = 1,
		inactive_opacity = 1,
		fullscreen_opacity = 1,

		rounding = 8,
		rounding_power = 10,

		border_part_of_window = true,

		dim_inactive = true,
		dim_strength = 0.1,
		dim_modal = true,
		dim_special = 0.4,
		dim_around = 0.4,

		blur = {
			enabled = true,
			ignore_opacity = true,
			new_optimizations = true,
			special = false,
			popups = false,
			input_methods = false,
			brightness = 0.8,
			contrast = 1.2,
			vibrancy = 0.12,
			vibrancy_darkness = 1,
			size = 8,
			passes = 2,
			noise = 0.08,
			-- variant = 3 ,
			-- drops = { speed = 5 }
		},

		shadow = {
			enabled = true,
			color = ACTIVE_SHADOW,
			color_inactive = INACTIVE_SHADOW,
			range = 8,
			render_power = 3,
		},

		glow = {
			enabled = false,
		},

		motion_blur = {
			enabled = false,
		},

		wobble = {
			enabled = true,
      intensity = 0.1
		},
	},
})
