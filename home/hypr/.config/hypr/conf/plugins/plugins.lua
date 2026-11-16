hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload")
end)

-- https://github.com/yayuuu/hyprland-scroll-overview.git
require("conf.plugins.overview.scroll-overview")
