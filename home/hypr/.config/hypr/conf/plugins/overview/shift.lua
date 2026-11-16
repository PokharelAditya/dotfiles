SHIFT_PRESSED = {
	left = false,
	right = false,
}

function SET_SCROLLING_MODE(mode)
	hl.config({
		plugin = {
			scrolloverview = {
				input = {
					scrolling_mode = mode,
				},
			},
		},
	})
end

function RESET_SCROLLING_MODE()
	SHIFT_PRESSED.left = false
	SHIFT_PRESSED.right = false
	SET_SCROLLING_MODE(0)
end

function SET_SHIFT_PRESSED(side, pressed)
	SHIFT_PRESSED[side] = pressed
	SET_SCROLLING_MODE((SHIFT_PRESSED.left or SHIFT_PRESSED.right) and 1 or 0)
end

RESET_SCROLLING_MODE()
