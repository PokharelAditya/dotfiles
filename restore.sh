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
# File lists (shared with backup.sh)
# ─────────────────────────────────────────
source "$SCRIPT_DIR/files.sh"

# ─────────────────────────────────────────
# Restore: Private ← USB
# ─────────────────────────────────────────
restore_private() {
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

    if [[ ! -d "$USB_PRIVATE" ]]; then
        error "No private backup found on USB at $USB_PRIVATE. Aborting."
        exit 1
    fi

    # Restore home files
    if [[ ${#PRIVATE_HOME_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Restoring private HOME files..."

        for entry in "${PRIVATE_HOME_FILES[@]}"; do
            SRC="$USB_HOME/$entry"
            DEST="$HOME/$entry"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found on USB): $SRC"
                continue
            fi

            mkdir -p "$(dirname "$DEST")"
            info "  rsync: ~/$entry"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: ~/$entry"
        done
    fi

    # Restore system files
    if [[ ${#PRIVATE_SYSTEM_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Restoring private SYSTEM files..."

        for entry in "${PRIVATE_SYSTEM_FILES[@]}"; do
            REL="${entry#/}"
            SRC="$USB_SYSTEM/$REL"
            DEST="$entry"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found on USB): $SRC"
                continue
            fi

            sudo mkdir -p "$(dirname "$DEST")"
            info "  rsync: $entry"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: $entry"
        done
    fi

    echo ""
    success "Private restore complete."
}

# ─────────────────────────────────────────
# Restore: Public ← dotfiles repo
# ─────────────────────────────────────────
restore_public() {
    echo ""
    info "Restoring public files from dotfiles repo..."

    # Restore home files via stow
    if [[ ${#PUBLIC_HOME_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Restoring public HOME files via stow..."

        if ! command -v stow &>/dev/null; then
            error "stow is not installed. Install it with: sudo pacman -S stow"
            exit 1
        fi

        declare -A seen_pkgs=()
        UNIQUE_PKGS=()

        for entry in "${PUBLIC_HOME_FILES[@]}"; do
            SRC=$(echo "$entry" | awk '{print $1}')
            PKG=$(echo "$entry" | awk '{print $2}')
            PKG_DIR="$SCRIPT_DIR/home/$PKG"

            if [[ ! -d "$PKG_DIR" ]]; then
                warn "Skipping (not found in dotfiles): home/$PKG"
                continue
            fi

            if [[ "$(readlink -f "$HOME/$SRC")" == "$(readlink -f "$PKG_DIR/$SRC")" ]]; then
                warn "Skipping (symlink detected): $SRC"
                continue
            fi

            if [[ -e "$HOME/$SRC" ]]; then
              info "  removing: $HOME/$SRC"
              rm -r "$HOME/$SRC"
            fi

            if [[ -z "${seen_pkgs[$PKG]:-}" ]]; then
                seen_pkgs[$PKG]=1
                UNIQUE_PKGS+=("$PKG")
            fi
        done

        for PKG in "${UNIQUE_PKGS[@]}"; do
            info "  stow: home/$PKG → ~/"
            stow --dir="$SCRIPT_DIR/home" --target="$HOME" "$PKG"
            success "  Done: home/$PKG"
        done
    fi

    # Restore system files
    if [[ ${#PUBLIC_SYSTEM_FILES[@]} -gt 0 ]]; then
        echo ""
        info "Restoring public SYSTEM files..."

        for entry in "${PUBLIC_SYSTEM_FILES[@]}"; do
            REL="${entry#/}"
            SRC="$SCRIPT_DIR/system/$REL"
            DEST="$entry"

            if [[ ! -e "$SRC" ]]; then
                warn "Skipping (not found in dotfiles): $SRC"
                continue
            fi

            sudo mkdir -p "$(dirname "$DEST")"
            info "  rsync: $SRC → $DEST"
            sudo rsync -av --delete "$SRC" "$(dirname "$DEST")"
            success "  Done: $SRC"
        done
    fi

    echo ""
    success "Public restore complete."
}

# ─────────────────────────────────────────
# Restore: Packages
# ─────────────────────────────────────────
restore_packages() {
    echo ""
    info "Installing packages..."

    OFFICIAL="$SCRIPT_DIR/packages/official.txt"
    AUR="$SCRIPT_DIR/packages/aur.txt"

    if [[ -f "$OFFICIAL" ]]; then
        info "Installing official packages..."
        awk '{print $1}' "$OFFICIAL" | sudo pacman -S --needed -
        success "Official packages installed."
    else
        warn "Official package list not found: $OFFICIAL"
    fi

    if [[ -f "$AUR" ]]; then
        if command -v yay &>/dev/null; then
            AUR_HELPER="yay"
        elif command -v paru &>/dev/null; then
            AUR_HELPER="paru"
        else
            warn "No AUR helper found (yay/paru). Skipping AUR packages."
            AUR_HELPER=""
        fi

        if [[ -n "$AUR_HELPER" ]]; then
            info "Installing AUR packages with $AUR_HELPER..."
            awk '{print $1}' "$AUR" | "$AUR_HELPER" -S --needed -
            success "AUR packages installed."
        fi
    else
        warn "AUR package list not found: $AUR"
    fi

    echo ""
    success "Package restore complete."
}

# ─────────────────────────────────────────
# Restore: Services
# ─────────────────────────────────────────
restore_services() {
    echo ""
    info "Enabling services..."

    SYSTEM_SERVICES="$SCRIPT_DIR/services/system.txt"
    USER_SERVICES="$SCRIPT_DIR/services/user.txt"

    if [[ -f "$SYSTEM_SERVICES" ]]; then
        info "Enabling system services..."
        while IFS= read -r service; do
            [[ -z "$service" ]] && continue
            info "  enabling: $service"
            sudo systemctl enable "$service"
            success "  Done: $service"
        done < "$SYSTEM_SERVICES"
    else
        warn "System services list not found: $SYSTEM_SERVICES"
    fi

    if [[ -f "$USER_SERVICES" ]]; then
        info "Enabling user services..."
        while IFS= read -r service; do
            [[ -z "$service" ]] && continue
            info "  enabling: $service"
            systemctl --user enable "$service"
            success "  Done: $service"
        done < "$USER_SERVICES"
    else
        warn "User services list not found: $USER_SERVICES"
    fi

    echo ""
    success "Services restore complete."
}

# ─────────────────────────────────────────
# Main menu
# ─────────────────────────────────────────
echo ""
echo "What do you want to restore?"
echo "  1) Public files without packages and services ← dotfiles repo (GitHub)"
echo "  2) Private files ← USB drive"
echo "  3) Packages ← dotfiles repo (GitHub)"
echo "  4) Services ← dotfiles repo (GitHub)"
echo "  5) All"
echo ""
read -rp "Choose [1/2/3/4/5]: " CHOICE

case "$CHOICE" in
    1) restore_public ;;
    2) restore_private ;;
    3) restore_packages ;;
    4) restore_services ;;
    5) restore_public
       restore_private
       restore_packages
       restore_services ;;
    *) error "Invalid choice '$CHOICE'."; exit 1 ;;
esac
