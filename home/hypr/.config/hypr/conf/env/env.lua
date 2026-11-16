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
--
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
