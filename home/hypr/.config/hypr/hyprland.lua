------------------
---- HYPRLAND ----
------------------

require("conf.debug.debug")
require("conf.monitors.monitors")
require("conf.looks.looks")
require("conf.layouts.layouts")

require("conf.autostart.autostart")

require("conf.short.default")

require("conf.environments.env")






-- Curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.animation({ leaf = "global",              enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",              enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",             enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",           enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",          enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",              enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",             enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",               enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",              enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",            enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",           enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",        enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",       enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",          enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",          enabled = true,  speed = 7,    bezier = "quick" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true,  speed = 2,    bezier = "almostLinear", style = "slide bottom" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true,  speed = 2,    bezier = "almostLinear", style = "slide top" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        -- pseudotile = true,
        preserve_split = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 2, direction = "pinch", mods = MOD, action = "cursor_zoom", zoom_level = 1.2, mode = "live" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
hl.gesture({ fingers = 3, direction = "swipe", mods = MOD, action = "resize" })
-- hl.gesture({ fingers = 4, direction = "down", action = put lockscreen here })
-- hl.gesture({ fingers = 4, direction = "up", action = workspace overview })
-- hl.gesture({ fingers = 4, direction = "horizontal", action = })

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    input = {
        kb_layout = "us",
        numlock_by_default = true,

        follow_mouse = 1,
        sensitivity  = -0.2,
        accel_profile = "flat",
        scroll_method = "on_button_down",
        scroll_button = 274,
        scroll_button_lock = true,
        scroll_factor = 2,
        natural_scroll = false,
    },
})

hl.device({
    name           = "asup1205:00-093a:2003-touchpad",
    sensitivity    = 1,
    scroll_method  = "2fg",
    scroll_factor  = 1,
    natural_scroll = true,
})

--------------------------
---- WORKSPACE RULES  ----
--------------------------

-- local function fit_widths(is_open)
--     local ws = hl.get_active_workspace()
--     if not ws then return end
--     if tostring(ws.name):match("^special:") then return end  -- leave special workspaces alone
--
--     local n = #hl.get_workspace_windows(ws.id)
--
--     if n == 1 then
--         hl.dispatch(hl.dsp.layout("colresize all 0.8"))
--     elseif n == 2 and is_open then
--         hl.dispatch(hl.dsp.layout("colresize all 0.5"))
--     end
-- end
--
-- hl.on("window.open",    function() fit_widths(true)  end)
-- hl.on("window.destroy", function() fit_widths(false) end)

local specialWorkspaces = {
  ["⌘"] = {
    app = "kitty btop",
    monitor = "lenovoMonitor",
    key = "Escape",
    full = 1
  },
  ["♬"] = {
    app = "pear-desktop",
    monitor = "huaweiTab",
    key = "M",
    full = 2
  },
  ["◉"] = {
    app = "discord",
    monitor = "lenovoMonitor",
    key = "D",
    full = 1
  }
}

hl.on("workspace.created", function(ws)
  local short = ws.name:match("^special:(.+)$")
	local pro = specialWorkspaces[short]
	if pro and ws.is_empty then
		hl.exec_cmd(pro.app)
	end
end)

for name,pro in pairs(specialWorkspaces) do
	hl.window_rule({
		name = "fs-" .. name,
		match = { workspace = "special:" .. name },
		fullscreen_state = pro.full,
	})

  hl.bind(MOD .. pro.key, function()
      local ws = "special:" .. name

      local visible = false
      for _, m in ipairs(hl.get_monitors()) do
          local sp = m.active_special_workspace
          if sp and sp.name == ws then visible = true end
      end

      local w = hl.get_active_window()
      local focused = w ~= nil and w.workspace ~= nil and w.workspace.name == ws

      if focused then
          hl.dispatch(hl.dsp.workspace.toggle_special(name))
      elseif visible then
          hl.dispatch(hl.dsp.focus({ monitor = pro.monitor }))
      else
          hl.dispatch(hl.dsp.focus({ monitor = pro.monitor }))
          hl.dispatch(hl.dsp.workspace.toggle_special(name))
      end
  end)
end


---------------------
---- KEYBINDINGS ----
---------------------


-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(MOD .. "CTRL + H", hl.dsp.exec_cmd("~/.config/hypr/scripts/exit-hyprland.sh"))
hl.bind(MOD .. "R", hl.dsp.exec_cmd('hyprctl reload && notify-send "Hyprland" "Hyprland reloaded"'))
hl.bind(MOD .. "Q", hl.dsp.window.close())
hl.bind(MOD .. "CTRL + B", hl.dsp.exec_cmd('(killall waybar && notify-send "Waybar" "Waybar disabled") || (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configLaptop & notify-send "Waybar" "Waybar enabled")'))
hl.bind(MOD .. "ALT + B", hl.dsp.exec_cmd('(killall waybar && notify-send "Waybar" "Waybar disabled") || (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configExternal & notify-send "Waybar" "Waybar enabled")'))
-- hl.bind(MOD .. "CTRL + B", hl.dsp.exec_cmd('killall waybar && (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/config) & notify-send "Waybar" "Waybar reloaded"'))
hl.bind(MOD .. "E", hl.dsp.exec_cmd(FILE))
hl.bind(MOD .. "T", hl.dsp.exec_cmd(TERM))
hl.bind(MOD .. "A", hl.dsp.exec_cmd(MENU))
hl.bind(MOD .. "B", hl.dsp.exec_cmd(BROWSER))
-- hl.bind(MOD .. "N", hl.dsp.exec_cmd("notion-desktop"))
-- hl.bind(MOD .. "D", hl.dsp.exec_cmd('if hyprctl clients | grep "class: discord"; then hyprctl dispatch closewindow class:discord; else discord; fi'))
-- hl.bind(MOD .. "D", hl.dsp.workspace.toggle_special("discordWorkspace"))
hl.bind(MOD .. "SHIFT + D", hl.dsp.exec_cmd("discover-overlay -x || discover-overlay"))
-- hl.bind(MOD .. "Y", hl.dsp.exec_cmd('if hyprctl clients | grep "com.github.th_ch.youtube_music"; then hyprctl dispatch closewindow class:com.github.th_ch.youtube_music; else pear-desktop; fi'))
-- hl.bind(MOD .. "Z", hl.dsp.focus({ workspace = "M"}))
-- hl.bind(MOD .. "Y", hl.dsp.workspace.toggle_special("musicWorkspace"))
hl.bind(MOD .. "SHIFT + F", hl.dsp.window.fullscreen_state({ action = "toggle", internal = 1, client = 0 }))
hl.bind(MOD .. "F", hl.dsp.window.fullscreen_state({ action = "toggle", internal = 2, client = 0 }))
hl.bind(MOD .. "ALT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. "P", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"))
-- hl.bind(MOD .. "P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(MOD .. "X", hl.dsp.layout("togglesplit")) -- dwindle


-- For controlling androids
-- hl.workspace_rule({
--     workspace       = "special:scrcpyWorkspace",
--     on_created_empty = 'scrcpy --otg --shortcut-mod=lsuper --window-title="specialScrcpy"',
-- })
--
-- -- hl.bind(MOD .. "S", hl.dsp.workspace.toggle_special("scrcpyWorkspace"))
-- -- hl.bind(MOD .. "S", hl.dsp.sendshortcut("ALT_R", "Return"))
-- hl.bind(MOD .. "S", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace scrcpyWorkspace"))
-- hl.bind(MOD .. "S", hl.dsp.submap("scrcpyMode"))
--
-- hl.define_submap("scrcpyMode", function()
--     hl.bind(MOD .. "S", hl.dsp.workspace.toggle_special("scrcpyWorkspace"))
--     hl.bind(MOD .. "S", hl.dsp.submap("reset"))
--     hl.bind(MOD .. "Escape", hl.dsp.submap("reset"))
--
--     hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
--     hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
--     hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
--     hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
--     hl.bind("XF86RFKill",           hl.dsp.exec_cmd('notify-send "hi" "hello"'),                        { locked = true, repeating = true })
--
--     hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
--     hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
--     hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
--     hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-- end)
--
-- hl.window_rule({
--     name  = "scrcpy-transparent",
--     match = { title = "specialScrcpy" },
--     opacity  = 0,
--     no_blur  = true,
-- })

-- Move focus with MOD + arrow keys
hl.bind(MOD .. "left",  hl.dsp.focus({ monitor = "left" }))
hl.bind(MOD .. "right", hl.dsp.focus({ monitor = "right" }))
-- hl.bind(MOD .. "Up",   hl.dsp.focus({ monitor = "up" }))
-- hl.bind(MOD .. "Down", hl.dsp.focus({ monitor = "down" }))
hl.bind(MOD .. "H", hl.dsp.layout("focus l"))
hl.bind(MOD .. "L", hl.dsp.layout("focus r"))
hl.bind(MOD .. "K", hl.dsp.layout("focus u"))
hl.bind(MOD .. "J", hl.dsp.layout("focus d"))
-- hl.bind(subMod .. "tab", hl.dsp.focus({ last = true }))
-- hl.bind(MOD .. "H", hl.dsp.focus({ window = "left" }))
-- hl.bind(MOD .. "L", hl.dsp.focus({ window = "right" }))
-- hl.bind(MOD .. "K", hl.dsp.focus({ window = "up" }))
-- hl.bind(MOD .. "J", hl.dsp.focus({ window = "down" }))

hl.bind(MOD .. "up", hl.dsp.focus({ workspace = "next" }))
hl.bind(MOD .. "down",   hl.dsp.focus({ workspace = "previous" }))
-- Switch workspaces with MOD + [0-9]
-- Move active window to a workspace with MOD + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(MOD .. "" .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(MOD .. "SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(MOD .. "W",         hl.dsp.workspace.toggle_special("▧"))
hl.bind(MOD .. "SHIFT + W", hl.dsp.window.move({ workspace = "special:▧" }))

-- Scroll through existing workspaces with MOD + scroll
-- hl.bind(MOD .. "tab",        hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(MOD .. "SHIFT + tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. "mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(MOD .. "mouse_up",   hl.dsp.focus({ workspace = "m-1" }))

-- Move/resize windows with MOD + LMB/RMB and dragging
hl.bind(MOD .. "mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(MOD .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 10%+"),                         { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 10%-"),                         { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Example windowrule
-- hl.window_rule({ name = "float-kitty", match = { class = "^(kitty)$", title = "^(kitty)$" }, float = true })

-- Ignore maximize requests from apps. You'll probably like this.
-- hl.window_rule({
--     name  = "suppress-maximize-events",
--     match = { class = ".*" },
--     suppress_event = "maximize",
-- })
--
-- -- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--     no_focus = true,
-- })
--



require("conf.plugins.overview.scroll-overview")
