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
# Private files to back up to USB
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
# Backup: Private → USB
# ─────────────────────────────────────────
backup_private() {
    # 1. Ask for device
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

    # 2. Mount the USB temporarily under /tmp
    info "Mounting $USB_DEV..."
    sudo cryptsetup open "$USB_DEV" backup 
    MOUNT_POINT="/mnt/usb"
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount "/dev/mapper/backup" "$MOUNT_POINT"

    # Make sure we unmount on exit no matter what
    trap "info 'Unmounting USB...'; sudo umount '$MOUNT_POINT'; sudo rmdir '$MOUNT_POINT'; sudo cryptsetup close backup" EXIT

    USB_HOME="$MOUNT_POINT/home"
    USB_SYSTEM="$MOUNT_POINT/system"
    sudo mkdir -p "$USB_HOME" "$USB_SYSTEM"

    # 3. Init git repo on USB if not already present
    if [[ ! -d "$MOUNT_POINT/.git" ]]; then
        info "Initialising local git repo on USB..."
        sudo git -C "$MOUNT_POINT" init -q
        info "Git repo initialised at $MOUNT_POINT"
        sudo git -C "$MOUNT_POINT" config user.email "pokhareladitya.pro@gmail.com"
        sudo git -C "$MOUNT_POINT" config user.name "Aditya Pokharel"
    fi

    # 4. Sync home files
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
          sudo rsync -av "$SRC" "$(dirname "$DEST")/"
          success "  Done: ~/$entry"
      done
    fi

    # 5. Sync system files (requires sudo for reading protected paths)
    if [[ ${#PRIVATE_SYSTEM_FILES[@]} -gt 0 ]]; then
      echo ""
      info "Backing up private SYSTEM files..."

      for entry in "${PRIVATE_SYSTEM_FILES[@]}"; do
          SRC="$entry"
          # Strip leading slash so we get a relative path under USB_SYSTEM
          REL="${entry#/}"
          DEST="$USB_SYSTEM/$REL"

          if [[ ! -e "$SRC" ]]; then
              warn "Skipping (not found): $SRC"
              continue
          fi

          sudo mkdir -p "$(dirname "$DEST")"
          info "  rsync: $entry"
          sudo rsync -av "$SRC" "$(dirname "$DEST")/"
          success "  Done: $entry"
      done
    fi

    # 6. Git commit snapshot
    echo ""
    info "Committing snapshot to USB git repo..."
    sudo git -C "$MOUNT_POINT" add -A
    if sudo git -C "$MOUNT_POINT" diff --cached --quiet; then
        info "Nothing new to commit — backup already up to date."
    else
        COMMIT_MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
        sudo git -C "$MOUNT_POINT" commit -m "$COMMIT_MSG"
        success "Snapshot committed: $COMMIT_MSG"
    fi

    echo ""
    success "Private backup complete."
}

# ─────────────────────────────────────────
# Main menu
# ─────────────────────────────────────────
echo ""
echo "What do you want to back up?"
echo "  1) Private files → USB drive"
echo "  2) Public files → GitHub repo  (not yet implemented)"
echo "  3) Both"
echo ""
read -rp "Choose [1/2/3]: " CHOICE

case "$CHOICE" in
    1) backup_private ;;
    2) echo "Public backup not yet implemented." ;;
    3) backup_private
       echo "Public backup not yet implemented." ;;
    *) error "Invalid choice '$CHOICE'."; exit 1 ;;
esac
