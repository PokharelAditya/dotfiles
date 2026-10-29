------------------
---- HYPRLAND ----
------------------


------------------
---- MONITORS ----
------------------

require("monitors")
require("conf.eDP")

require("workspaces")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 2 && xhost +SI:localuser:root &")
    hl.exec_cmd("sleep 2 && /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")

    hl.exec_cmd("waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configLaptop &")
    hl.exec_cmd("sleep 2 && kdeconnectd & kdeconnect-indicator &")
    -- hl.exec_cmd("sleep 2 && rog-control-center &")
    -- hl.exec_cmd("sleep 2 && cardwire-gui &")
    -- hl.exec_cmd("sleep 2 && discover-overlay &")
    -- hl.exec_cmd("sleep 2 && tailscale systray &")

    hl.exec_cmd("sleep 5 && /home/adityaarch/.config/hypr/scripts/battery/ac-battery-switch.sh &")
    hl.exec_cmd("sleep 5 && /home/adityaarch/.config/hypr/scripts/gpu/backlit.sh &")
    -- hl.exec_cmd("sleep 2 && /home/adityaarch/.config/hypr/scripts/battery-notification.sh &")
end)


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"
local browser     = "brave"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")
-- hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
-- hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
-- hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-- hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- hl.env("GDK_SCALE", "1")

-- hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("CLUTTER_BACKEND", "wayland")

-- hl.env("MOZ_ENABLE_WAYLAND", "1")

-- hl.env("OZONE_PLATFORM", "wayland")
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(102,178,255,1)", "rgba(6,188,228,0.6)", "rgba(00,00,00,1)", "rgba(6,188,228,0.6)", "rgba(102,178,255,1)"}, angle = 90 },
            inactive_border = "rgba(105,105,105,0.67)",
        },

        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    layout = {
        single_window_aspect_ratio = "4 3",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 4,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(26,26,26,0.93)",
        },

        blur = {
            enabled   = true,
            size      = 4,
            passes    = 3,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

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
hl.animation({ leaf = "workspaces",          enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn",        enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut",       enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
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
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical",   action = "special",  workspace = "musicWorkspace" })
hl.gesture({ fingers = 4, direction = "vertical",   action = "special",  workspace = "discordWorkspace" })

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

hl.workspace_rule({
    workspace       = "special:musicWorkspace",
    on_created_empty = 'if hyprctl clients | grep "com.github.th_ch.youtube_music"; then hyprctl dispatch closewindow class:com.github.th_ch.youtube_music; else pear-desktop; fi',
})
hl.workspace_rule({
    workspace       = "special:discordWorkspace",
    on_created_empty = 'if hyprctl clients | grep "class: discord"; then hyprctl dispatch closewindow class:discord; else discord; fi',
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("~/.config/hypr/scripts/exit-hyprland.sh"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd('hyprctl reload && notify-send "Hyprland" "Hyprland reloaded"'))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd('(killall waybar && notify-send "Waybar" "Waybar disabled") || (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configLaptop & notify-send "Waybar" "Waybar enabled")'))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd('(killall waybar && notify-send "Waybar" "Waybar disabled") || (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configExternal & notify-send "Waybar" "Waybar enabled")'))
-- hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd('killall waybar && (waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/config) & notify-send "Waybar" "Waybar reloaded"'))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("notion-desktop"))
-- hl.bind(mainMod .. " + D", hl.dsp.exec_cmd('if hyprctl clients | grep "class: discord"; then hyprctl dispatch closewindow class:discord; else discord; fi'))
hl.bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("discordWorkspace"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("discover-overlay -x || discover-overlay"))
-- hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd('if hyprctl clients | grep "com.github.th_ch.youtube_music"; then hyprctl dispatch closewindow class:com.github.th_ch.youtube_music; else pear-desktop; fi'))
hl.bind(mainMod .. " + Y", hl.dsp.workspace.toggle_special("musicWorkspace"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
-- hl.bind(mainMod .. " + X", hl.dsp.layout("togglesplit")) -- dwindle


-- For controlling androids
hl.workspace_rule({
    workspace       = "special:scrcpyWorkspace",
    on_created_empty = 'scrcpy --otg --shortcut-mod=lsuper --window-title="specialScrcpy"',
})

-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scrcpyWorkspace"))
-- hl.bind(mainMod .. " + S", hl.dsp.sendshortcut("ALT_R", "Return"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace scrcpyWorkspace"))
hl.bind(mainMod .. " + S", hl.dsp.submap("scrcpyMode"))

hl.define_submap("scrcpyMode", function()
    hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scrcpyWorkspace"))
    hl.bind(mainMod .. " + S", hl.dsp.submap("reset"))
    hl.bind(mainMod .. " + Escape", hl.dsp.submap("reset"))

    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
    hl.bind("XF86RFKill",           hl.dsp.exec_cmd('notify-send "hi" "hello"'),                        { locked = true, repeating = true })

    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
end)

hl.window_rule({
    name  = "scrcpy-transparent",
    match = { title = "specialScrcpy" },
    opacity  = 0,
    no_blur  = true,
})

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + W",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + tab",        hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

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
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})


