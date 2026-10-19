local resolution = "1920x1080"
local refreshRate = 144
local position = "3800x1200"

hl.monitor({
    disabled = false,
    output = "eDP-1",
    mode = resolution.."@"..refreshRate,
    position = position,
    scale = 1.0,
    bitdepth = 10,
    vrr = 0
})

hl.monitor({
    disabled = false,
    output = "eDP-2",
    mode = resolution.."@"..refreshRate,
    position = position,
    scale = 1.0,
    bitdepth = 10,
    vrr = 0
})
