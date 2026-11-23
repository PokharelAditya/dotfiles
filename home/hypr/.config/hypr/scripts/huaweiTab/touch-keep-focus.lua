-- Hyprland 0.57.x: restore focus even when either monitor is empty.
-- Touch is inferred while the physical cursor remains outside huaweiTab.
local TOUCH_MONITOR = "huaweiTab"
local DELAY_MS = 1
local CLICK_FOCUS_REASON = 16
local KEYBIND_FOCUS_REASON = 2

local generation = 0
local restoring = false
local observed_monitor = hl.get_active_monitor()
local empty_keybind = nil

local function same_monitor(a, b)
    return a ~= nil and b ~= nil and a.name ~= nil and a.name == b.name
end

local function same_window(a, b)
    if a == nil or b == nil then
        return a == nil and b == nil
    end
    return a.address ~= nil and a.address == b.address
end

local function workspace_name(workspace)
    return workspace ~= nil and workspace.addressable_name or nil
end

local function snapshot(monitor, window)
    if window ~= nil and not same_monitor(window.monitor, monitor) then
        window = nil
    end
    return {
        monitor = monitor,
        window = window,
        workspace = monitor ~= nil and workspace_name(monitor.active_workspace) or nil,
        special = monitor ~= nil and workspace_name(monitor.active_special_workspace) or nil,
    }
end

local keep = snapshot(observed_monitor, hl.get_active_window())

local function remember_current()
    observed_monitor = hl.get_active_monitor()
    keep = snapshot(observed_monitor, hl.get_active_window())
end

local function cursor_elsewhere()
    local monitor = hl.get_monitor_at_cursor()
    return monitor ~= nil and monitor.name ~= TOUCH_MONITOR
end

local function focus_without_warp(spec)
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
        hl.dispatch(hl.dsp.focus(spec))
    end)
    restoring = false
    hl.config({ cursor = saved })
    remember_current()
    if not ok then
        error(err)
    end
end

local function schedule_restore(monitor, window)
    generation = generation + 1
    local ticket = generation
    local previous = keep
    if previous.monitor == nil or (same_monitor(previous.monitor, monitor)
        and (previous.window == nil or same_window(previous.window, window))) then
        keep = snapshot(monitor, window)
        return
    end

    hl.timer(function()
        if generation ~= ticket then
            return
        end
        if not same_monitor(hl.get_active_monitor(), monitor)
            or not same_window(hl.get_active_window(), window) or not cursor_elsewhere() then
            remember_current()
            return
        end

        local target = previous.monitor
        -- Do not undo a workspace change or focus a disconnected monitor.
        if target.name == nil or not target.enabled
            or workspace_name(target.active_workspace) ~= previous.workspace
            or workspace_name(target.active_special_workspace) ~= previous.special then
            remember_current()
            return
        end

        local old_window = previous.window
        if old_window ~= nil and old_window.mapped and old_window.visible
            and not old_window.hidden and same_monitor(old_window.monitor, target) then
            focus_without_warp({ window = "address:" .. old_window.address })
        else
            -- An empty screen still has monitor/workspace focus to restore.
            focus_without_warp({ monitor = target.name })
        end
    end, { timeout = DELAY_MS, type = "oneshot" })
end

hl.on("monitor.focused", function(monitor)
    local from = observed_monitor
    observed_monitor = monitor -- This event fires before Hyprland updates its getter.
    if restoring then
        return
    end

    -- Focusing an empty monitor by keybind emits window.active(nil, 2)
    -- BEFORE monitor.focused. Do not mistake that sequence for a touch.
    local ordinary = empty_keybind ~= nil and same_monitor(empty_keybind.monitor, from)
    empty_keybind = nil
    if not ordinary and monitor ~= nil and monitor.name == TOUCH_MONITOR and cursor_elsewhere() then
        -- Some background/layer touches change only monitor focus.
        schedule_restore(monitor, hl.get_active_window())
    else
        generation = generation + 1
        keep = snapshot(monitor, hl.get_active_window())
    end
end)

hl.on("window.active", function(window, reason)
    if restoring then
        return
    end
    local monitor = window ~= nil and window.monitor or observed_monitor
    empty_keybind = nil
    if monitor ~= nil and monitor.name == TOUCH_MONITOR
        and reason == CLICK_FOCUS_REASON and cursor_elsewhere() then
        -- nil is a valid touch target: it means the empty desktop.
        schedule_restore(monitor, window)
    else
        generation = generation + 1
        keep = snapshot(monitor, window)
        if window == nil and reason == KEYBIND_FOCUS_REASON then
            local marker = { monitor = monitor }
            empty_keybind = marker
            hl.timer(function()
                if empty_keybind == marker then
                    empty_keybind = nil
                end
            end, { timeout = 1, type = "oneshot" })
        end
    end
end)
