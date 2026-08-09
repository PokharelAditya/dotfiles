#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─────────────────────────────────────────
# Helper
# ─────────────────────────────────────────
info()    { echo "[INFO] $*"; }
success() { echo "[OK]   $*"; }
warn()    { echo "[WARN] $*"; }
error()   { echo "[ERR]  $*" >&2; }

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

# ─────────────────────────────────────────
# Backup: Private → USB
# ─────────────────────────────────────────
backup_private() {
    echo ""
    read -rp "Enter USB device (e.g. /dev/sda1): " USB_DEV

    if [[ -z "$USB_DEV" ]]; then
        error "No device provided. Aborting."
        exit 1
    fi

    if ! lsblk "$USB_DEV" &>/dev/null; then
        error "Device '$USB_DEV' not found. Aborting."
        exit 1
    fi

    info "Mounting $USB_DEV..."
    sudo cryptsetup open "$USB_DEV" backup
    MOUNT_POINT="/mnt/usb"
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount "/dev/mapper/backup" "$MOUNT_POINT"

    trap "info 'Unmounting USB...'; sudo umount '$MOUNT_POINT'; sudo rmdir '$MOUNT_POINT'; sudo cryptsetup close backup" EXIT

    USB_PRIVATE="$MOUNT_POINT/private"
    USB_HOME="$USB_PRIVATE/home"
    USB_SYSTEM="$USB_PRIVATE/system"
    sudo mkdir -p "$USB_HOME" "$USB_SYSTEM"

    # Init git repo on USB if not already present
    if [[ ! -d "$USB_PRIVATE/.git" ]]; then
        info "Initialising local git repo on USB private..."
        sudo git -C "$USB_PRIVATE" init -q
        sudo git -C "$USB_PRIVATE" config user.email "pokhareladitya.pro@gmail.com"
        sudo git -C "$USB_PRIVATE" config user.name "Aditya Pokharel"
        info "Git repo initialised at $USB_PRIVATE"
    fi

    # Sync home files
    if [[ ${#PRIVATE_HOME_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Backing up private HOME files..."

        for entry in "${PRIVATE_HOME_FILES[@]}"; do
            SRC="$HOME/$entry"
            DEST="$USB_HOME/$entry"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found): $SRC"
                continue
            fi

            sudo mkdir -p "$(dirname "$DEST")"
            info "  rsync: ~/$entry"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: ~/$entry"
        done
    fi

    # Sync system files
    if [[ ${#PRIVATE_SYSTEM_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Backing up private SYSTEM files..."

        for entry in "${PRIVATE_SYSTEM_FILES[@]}"; do
            SRC="$entry"
            REL="${entry#/}"
            DEST="$USB_SYSTEM/$REL"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found): $SRC"
                continue
            fi

            sudo mkdir -p "$(dirname "$DEST")"
            info "  rsync: $entry"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: $entry"
        done
    fi

    # Git commit snapshot
    echo ""
    info "Committing snapshot to USB git repo..."
    sudo git -C "$USB_PRIVATE" add -A
    if sudo git -C "$USB_PRIVATE" diff --cached --quiet; then
        info "Nothing new to commit — backup already up to date."
    else
        COMMIT_MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
        sudo git -C "$USB_PRIVATE" commit -m "$COMMIT_MSG"
        success "Snapshot committed: $COMMIT_MSG"
    fi

    # Copy dotfiles repo into USB if not already there
    if [[ "$SCRIPT_DIR" != "$MOUNT_POINT/dotfiles" ]]; then
        echo ""
        info "Copying dotfiles repo to USB..."
        sudo rsync -av --delete "$SCRIPT_DIR" "$MOUNT_POINT"
        success "Dotfiles copied to USB."
    fi

    echo ""
    success "Private backup complete."
}

# ─────────────────────────────────────────
# Backup: Public → dotfiles repo
# ─────────────────────────────────────────
backup_public() {
    echo ""
    info "Backing up public files to dotfiles repo..."

    # Sync home files
    if [[ ${#PUBLIC_HOME_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Syncing public HOME files..."

        for entry in "${PUBLIC_HOME_FILES[@]}"; do
            SRC_REL=$(echo "$entry" | awk '{print $1}')
            DEST_REL=$(echo "$entry" | awk '{print $2}')

            SRC="$HOME/$SRC_REL"
            DEST="$SCRIPT_DIR/home/$DEST_REL/$SRC_REL"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found): $SRC"
                continue
            fi

            if [[ "$(readlink -f "$SRC")" == "$(readlink -f "$DEST")" ]]; then
                warn "Skipping (symlink detected): $SRC"
                continue
            fi

            mkdir -p "$(dirname "$DEST")"
            info "  rsync: ~/$SRC_REL → $DEST_REL"
            rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: ~/$SRC_REL"
        done
    fi

    # Sync system files
    if [[ ${#PUBLIC_SYSTEM_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Syncing public SYSTEM files..."

        for entry in "${PUBLIC_SYSTEM_FILES[@]}"; do
            SRC="$entry"
            REL="${entry#/}"
            DEST="$SCRIPT_DIR/system/$REL"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found): $SRC"
                continue
            fi

            sudo mkdir -p "$(dirname "$DEST")"
            info "  rsync: $SRC → $DEST"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: $SRC"
        done
    fi

    # Save package lists
    echo ""
    info "Saving package lists..."
    mkdir -p "$SCRIPT_DIR/packages"
    pacman -Qqen > "$SCRIPT_DIR/packages/official.txt"
    success "Official packages saved."
    pacman -Qqem > "$SCRIPT_DIR/packages/aur.txt"
    success "AUR packages saved."

    # Git commit
    echo ""
    info "Committing to dotfiles repo..."
    git -C "$SCRIPT_DIR" add -A
    if git -C "$SCRIPT_DIR" diff --cached --quiet; then
        info "Nothing new to commit — dotfiles already up to date."
    else
        COMMIT_MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
        git -C "$SCRIPT_DIR" commit -m "$COMMIT_MSG"
        success "Committed: $COMMIT_MSG"
    fi

    # Push to GitHub
    echo ""
    read -rp "Push to GitHub? [y/N]: " PUSH_CHOICE
    if [[ "$PUSH_CHOICE" =~ ^[Yy]$ ]]; then
        info "Pushing to GitHub..."
        git -C "$SCRIPT_DIR" push origin main
        success "Pushed to GitHub."
    else
        info "Skipped push. You can push manually later with: git push"
    fi

    echo ""
    success "Public backup complete."
}

# ─────────────────────────────────────────
# Main menu
# ─────────────────────────────────────────
echo ""
echo "What do you want to back up?"
echo "  1) Public files  → dotfiles repo (GitHub)"
echo "  2) Private files → USB drive"
echo "  3) Both"
echo ""
read -rp "Choose [1/2/3]: " CHOICE

case "$CHOICE" in
    1) backup_public ;;
    2) backup_private ;;
    3) backup_public 
       backup_private ;;
    *) error "Invalid choice '$CHOICE'."; exit 1 ;;
esac
