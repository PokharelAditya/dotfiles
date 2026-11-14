-- https://github.com/yayuuu/hyprland-scroll-overview.git

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
                color = "rgba(0,0,0,0.4)"
            },
        },
    },
})

local altTab = require("conf.plugins.overview.alt-tab")

local openOverview = hl.plugin.scrolloverview.overview("open")
local closeOverview = hl.plugin.scrolloverview.overview("close")
local selectOverview = hl.plugin.scrolloverview.overview("select")
local selectWindow = hl.plugin.scrolloverview.window("select")

local function open_overview()
    if hl.get_current_submap() == "scrolloverview" then
        return
    end

    altTab.restore()
    hl.dispatch(openOverview)
end

local function close_overview()
    hl.dispatch(closeOverview)
    altTab.restore()
end

hl.bind(MOD .. "tab", open_overview)
hl.gesture({ fingers = 4, direction = "up", action = open_overview })

hl.define_submap("scrolloverview", function()
    hl.bind(MOD .. "tab", close_overview)
    hl.gesture({ fingers = 4, direction = "down", action = close_overview })

    hl.bind("H", hl.plugin.scrolloverview.navigate("left"))
    hl.bind("L", hl.plugin.scrolloverview.navigate("right"))
    hl.bind("K", hl.plugin.scrolloverview.navigate("up"))
    hl.bind("J", hl.plugin.scrolloverview.navigate("down"))

    hl.bind("O", close_overview)
    hl.bind("Q", hl.dsp.window.close())

    hl.bind("mouse:272", function()
        hl.dispatch(selectOverview)
        hl.dispatch(selectWindow)
        close_overview()
    end, { mouse = true })
    hl.bind(MOD .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
end)

hl.bind(ALT .. "tab", altTab.next, { submap_universal = true })
hl.bind(ALT .. "Alt_L", altTab.close, { release = true, transparent = true, submap_universal = true })
hl.bind(ALT .. "Alt_R", altTab.close, { release = true, transparent = true, submap_universal = true })
