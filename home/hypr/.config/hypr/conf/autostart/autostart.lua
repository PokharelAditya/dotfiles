-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    hl.exec_cmd("systemctl --user restart skwd-walld.service")
    hl.exec_cmd("waybar -s ~/.config/waybar/themes/ml4w/black/style.css -c ~/.config/waybar/themes/ml4w/configLaptop")
    hl.exec_cmd("kdeconnect-indicator")
    -- hl.exec_cmd("sleep 2 && rog-control-center &")
    -- hl.exec_cmd("sleep 2 && cardwire-gui &")
    -- hl.exec_cmd("sleep 2 && discover-overlay &")
    -- hl.exec_cmd("sleep 2 && tailscale systray &")

    hl.exec_cmd("sleep 2 && /home/adityaarch/.config/hypr/scripts/battery/ac-battery-switch.sh")
    hl.exec_cmd("sleep 2 && /home/adityaarch/.config/hypr/scripts/gpu/backlit.sh")
    -- hl.exec_cmd("sleep 2 && /home/adityaarch/.config/hypr/scripts/battery-notification.sh &")
end)
