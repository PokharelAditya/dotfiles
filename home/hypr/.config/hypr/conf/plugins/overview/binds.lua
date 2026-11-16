hl.bind(MOD .. "tab", hl.plugin.scrolloverview.overview("open"))
hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.dispatch(hl.plugin.scrolloverview.overview("open"))
	end,
})

hl.define_submap("scrolloverview", function()
	hl.bind(MOD .. "tab", hl.plugin.scrolloverview.overview("close"))
	hl.gesture({
		fingers = 4,
		direction = "down",
		action = function()
			hl.dispatch(hl.plugin.scrolloverview.overview("close"))
		end,
	})

	hl.bind("H", hl.plugin.scrolloverview.navigate("left"))
	hl.bind("L", hl.plugin.scrolloverview.navigate("right"))
	hl.bind("K", hl.plugin.scrolloverview.navigate("up"))
	hl.bind("J", hl.plugin.scrolloverview.navigate("down"))

	hl.bind("O", hl.plugin.scrolloverview.overview("close"))
	hl.bind("Q", hl.dsp.window.close())

	hl.bind("mouse:272", function()
		hl.plugin.scrolloverview.overview("select")
		hl.plugin.scrolloverview.window("select")
		hl.plugin.scrolloverview.overview("off")
	end, { mouse = true })
	hl.bind(MOD .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

	hl.bind("Shift_L", function()
		SET_SHIFT_PRESSED("left", true)
	end, { transparent = true, non_consuming = true })

	hl.bind("Shift_R", function()
		SET_SHIFT_PRESSED("right", true)
	end, { transparent = true, non_consuming = true })

	hl.bind("SHIFT + Shift_L", function()
		SET_SHIFT_PRESSED("left", false)
	end, {
		release = true,
		transparent = true,
		non_consuming = true,
		submap_universal = true,
	})

	hl.bind("SHIFT + Shift_R", function()
		SET_SHIFT_PRESSED("right", false)
	end, {
		release = true,
		transparent = true,
		non_consuming = true,
		submap_universal = true,
	})
end)
