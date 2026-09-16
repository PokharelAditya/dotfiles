# Arch Linux Dotfiles & System Configuration

Personal backup and restoration setup for my Arch Linux environment.

This repository contains my user configurations, system configuration files, installed package lists, and automated backup/restore scripts to rebuild my customized Arch Linux setup.

The goal is not to create a full system image, but to maintain a reproducible configuration that can be applied to a fresh Arch Linux installation.

## Repository Structure

```text
.
├── home/                    # User configuration files (managed with stow)
│   ├── nvim/
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   ├── zsh/
│   └── ...
│
├── system/                  # System configuration files (copied manually)
│   ├── grub/
│   ├── pacman/
│   └── ...
│
├── packages/                # Package lists
│   ├── official.txt        # Official repository packages
│   └── aur.txt             # AUR packages
│
├── services/                # Enabled service lists
│   ├── system.txt          # System-level services
│   └── user.txt            # User-level services
│
├── backup.sh               # Automated backup script
├── restore.sh              # Automated restore script
└── files.sh                # File definitions for backup/restore
```

## File Categories

Configuration files are separated into two categories:

### Public Files (dotfiles repo)

Public configuration files are tracked in this Git repository and pushed to GitHub. These include:

**Home files:**
* Desktop environment configs (Hypr, i3, Waybar)
* Application configs (Neovim, Kitty, Rofi)
* Shell configuration (Zsh, P10k)
* Development tools (Git)
* Theme settings (GTK, Qt)

**System files:**
* Bootloader configuration (GRUB)
* Display manager (SDDM)
* Package manager settings (Pacman)

### Private Files (USB drive)

Private files contain sensitive data and are backed up to an encrypted USB drive:

**Home files:**
* SSH keys
* API credentials
* Application-specific configs with tokens
* Shell history

**System files:**
* Network connections

## Backup

The `backup.sh` script automates backing up both public and private files.

### Usage

```bash
chmod +x backup.sh
./backup.sh
```

Choose what to back up:
1. Public files → dotfiles repo (GitHub)
2. Private files → USB drive
3. Both

### What It Does

**For public files:**
* Syncs configuration files from `files.sh` to `home/` and `system/`
* Saves installed package lists (`official.txt`, `aur.txt`)
* Saves enabled service lists (`system.txt`, `user.txt`)
* Creates a git commit with timestamp
* Optionally pushes to GitHub

**For private files:**
* Mounts encrypted USB drive with `cryptsetup`
* Syncs sensitive files to USB
* Creates git snapshot on USB for version control
* Copies entire dotfiles repo to USB as backup

## Restore

The `restore.sh` script automates restoring your system configuration.

### Usage

```bash
chmod +x restore.sh
./restore.sh
```

Choose what to restore:
1. Public files ← dotfiles repo
2. Private files ← USB drive
3. Packages
4. Services
5. All

### What It Does

**For public files:**
* Restores home configs using **GNU Stow** (creates symlinks)
* Copies system configs to `/etc`, `/boot`, etc.

**For private files:**
* Mounts encrypted USB drive
* Restores sensitive files to home directory
* Restores system files (like NetworkManager connections)

**For packages:**
* Installs packages from `official.txt` (pacman)
* Installs AUR packages from `aur.txt` (yay/paru)

**For services:**
* Enables system services from `services/system.txt` via `systemctl enable`
* Enables user services from `services/user.txt` via `systemctl --user enable`
* Services are registered for next boot/login, not started immediately

### How Stow Works

Stow creates symbolic links from their normal locations to the repository:

```text
~/.config/nvim → ~/dotfiles/home/nvim/.config/nvim
```

This keeps configuration files in the repository while applications use their standard paths.

## Backup Philosophy

This repository intentionally avoids backing up unnecessary system data.

Not included:

* Personal files
* Cache files
* Temporary data
* Application-generated data
* Large binary files

Only configuration and reproducible setup files are maintained.

## Tools

Main environment:

* Arch Linux
* Hyprland

---

Maintained as a personal Linux environment backup and restoration system.
