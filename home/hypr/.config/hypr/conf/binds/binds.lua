require("conf.binds.gestures")

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
hl.bind(MOD .. "SHIFT + F", hl.dsp.window.fullscreen_state({ action = "toggle", internal = 1, client = 1 }))
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


