# ─────────────────────────────────────────
# Private files → USB
# ─────────────────────────────────────────
PRIVATE_HOME_FILES=(
    ".ssh"
    ".config/opencode"
    ".config/omniroute"
)

PRIVATE_SYSTEM_FILES=(
    "/etc/NetworkManager/system-connections"
)

# ─────────────────────────────────────────
# Public files → dotfiles repo
# Each entry: "<src-relative-to-HOME> <dest-folder-in-dotfiles/home>"
# ─────────────────────────────────────────
PUBLIC_HOME_FILES=(
    ".config/hypr          hypr"
    ".zshrc                zsh"
    ".p10k.zsh             zsh"
    ".gitconfig            git"
    ".local/bin            scripts"
    "wallpapers            wallpapers"
)

# Each entry: "<src-relative-to-SYSTEM>"
PUBLIC_SYSTEM_FILES=(
    # e.g. "/etc/some-public-config"
)
