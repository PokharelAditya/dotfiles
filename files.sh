# ─────────────────────────────────────────
# Private files → USB
# ─────────────────────────────────────────
PRIVATE_HOME_FILES=(
    ".ssh"
    ".config/opencode"
    ".config/omniroute"
    ".config/sunshine"
    ".config/kdeconnect"
    ".config/YouTube Music/config.json"
    ".zsh_history"
)

PRIVATE_SYSTEM_FILES=(
    "/etc/NetworkManager/system-connections"
)

# ─────────────────────────────────────────
# Public files → dotfiles repo
# Each entry: "<src-relative-to-HOME> <dest-folder-in-dotfiles/home>"
# ─────────────────────────────────────────
PUBLIC_HOME_FILES=(
    ".config/discover_overlay/config.ini      discord"
    ".config/gtk-3.0/settings.ini             gtk"
    ".config/gtk-4.0/settings.ini             gtk"
    ".config/hypr                             hypr"
    ".config/i3                               i3"
    ".config/kitty                            kitty"
    ".config/nvim                             nvim"
    ".config/qt5ct                            qt"
    ".config/qt6ct                            qt"
    ".config/rog                              rog"
    ".config/waybar                           waybar"
    ".config/brave-flags.conf                 brave"
    ".config/mimeapps.list                    desktop"
    ".zshrc                                   zsh"
    ".p10k.zsh                                zsh"
    ".gitconfig                               git"
    ".local/bin                               scripts"
    "wallpapers                               wallpapers"
)

# Each entry: "<src-relative-to-SYSTEM>"
PUBLIC_SYSTEM_FILES=(
    "/etc/default/grub"
    "/boot/grub/themes"
    "/etc/sddm.conf"
    "/usr/share/sddm"
    "/etc/pacman.conf"
)
