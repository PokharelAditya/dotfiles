# Arch Linux Dotfiles & System Configuration

Personal backup and restoration setup for my Arch Linux environment.

This repository contains my user configurations, system configuration files, installed package lists, and restoration scripts to rebuild my customized Arch Linux setup.

The goal is not to create a full system image, but to maintain a reproducible configuration that can be applied to a fresh Arch Linux installation.

## Repository Structure

```text
.
├── home/
│   ├── nvim/
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   ├── rofi/
│   └── zsh/
│
├── system/
│   ├── grub/
│   ├── pacman/
│   ├── mkinitcpio/
│   └── systemd/
│
├── packages/
│   ├── official.txt
│   └── aur.txt
│
└── install.sh
```

## Home Configuration

The `home/` directory contains user-level configuration files.

These files are managed using **GNU Stow**.

Stow creates symbolic links from their normal locations:

```text
~/.config/nvim
        |
        v
~/dotfiles/home/nvim/.config/nvim
```

This allows the configuration files to remain inside this repository while applications continue using their standard paths.

Example:

```bash
stow -d home nvim hypr waybar kitty rofi zsh
```

## System Configuration

The `system/` directory contains root-level configuration files.

System files are **copied manually** instead of being managed using Stow.

This avoids creating symbolic links inside sensitive locations such as:

* `/etc`
* `/boot`
* system configuration directories

During restoration, these files are copied to their required locations using `install.sh`.

## Package Backup

Installed packages are separated into two categories.

### Official Repository Packages

Generated using:

```bash
pacman -Qneq > packages/official.txt
```

Installed with:

```bash
sudo pacman -S --needed - < packages/official.txt
```

### AUR Packages

Generated using:

```bash
pacman -Qmeq > packages/aur.txt
```

Installed using an AUR helper:

```bash
yay -S --needed - < packages/aur.txt
```

## Installation

After installing a fresh Arch Linux system:

```bash
git clone git@github.com:PokharelAditya/altEco.git dotfiles
cd dotfiles 
chmod +x install.sh
./install.sh
```

The installation script handles:

* Installing package lists
* Applying user configurations with Stow
* Restoring selected system configurations

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
