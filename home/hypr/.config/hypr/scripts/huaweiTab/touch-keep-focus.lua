-- Hyprland 0.57.x: restore keyboard focus without moving the cursor.
-- Touch is inferred from click-style focus on huaweiTab while the cursor
-- remains on another monitor. This does not block or synthesize touch events.
local TOUCH_MONITOR = "huaweiTab"
local DELAY_MS = 400
local CLICK_FOCUS_REASON = 16 -- FOCUS_REASON_CLICK in Hyprland 0.57.x

local keep = hl.get_active_window()
local generation = 0
local restoring = false

local function cursor_elsewhere()
    local monitor = hl.get_monitor_at_cursor()
    return monitor ~= nil and monitor.name ~= TOUCH_MONITOR
end

local function same_window(a, b)
    return a ~= nil and b ~= nil and a.address ~= nil and a.address == b.address
end

local function focus_without_warp(window)
    -- Change these only for this dispatch; preserve normal keybind behavior.
    local saved = {
        no_warps = hl.get_config("cursor.no_warps"),
        warp_on_change_workspace = hl.get_config("cursor.warp_on_change_workspace"),
        warp_on_monitor_change = hl.get_config("cursor.warp_on_monitor_change"),
        warp_on_toggle_special = hl.get_config("cursor.warp_on_toggle_special"),
    }
    hl.config({ cursor = {
        no_warps = true,
        warp_on_change_workspace = 0,
        warp_on_monitor_change = 0,
        warp_on_toggle_special = 0,
    } })

    restoring = true
    local ok, err = pcall(function()
        hl.dispatch(hl.dsp.focus({ window = "address:" .. window.address }))
    end)
    restoring = false
    hl.config({ cursor = saved })
    keep = hl.get_active_window()
    if not ok then
        error(err)
    end
end

hl.on("window.active", function(window, reason)
    if restoring then
        return
    end

    -- A later ordinary focus change cancels any pending restoration.
    generation = generation + 1
    local ticket = generation
    local touch_focus = window ~= nil and window.monitor ~= nil
        and window.monitor.name == TOUCH_MONITOR
        and reason == CLICK_FOCUS_REASON and cursor_elsewhere()

    if not touch_focus or keep == nil or same_window(window, keep) then
        keep = window
        return
    end

    local previous = keep
    hl.timer(function()
        if generation ~= ticket then
            return
        end
        local active = hl.get_active_window()
        if same_window(active, window) and previous.mapped and previous.visible
            and not previous.hidden and cursor_elsewhere() then
            focus_without_warp(previous)
        else
            keep = active
        end
    end, { timeout = DELAY_MS, type = "oneshot" })
end)
