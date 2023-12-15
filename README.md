# shell

shell scripts for system/hardware management and general maintenance

| folder name  | comment                    |
| :----------- | :------------------------- |
| old          | old stuff                  |

| name                 | comment                                                                       |
| :------------------- | :---------------------------------------------------------------------------- |
| alpha_restore.sh     | find png files with suspicious data in alpha channel                          |
| alsa.sh              | change volume with status notification                                        |
| aria2c.sh            | add download urls to aria2c                                                   |
| aur_pkgstats.sh      | download package stats from the aur                                           |
| aurbuild_update.sh   | aurutils sync packages and sync devel packages                                |
| backlight.sh         | change backlight brightness with status notification                          |
| backup_keys.sh       | key backup with rsync to specific usb device                                  |
| backup_nds.sh        | nds flashcard backup with rsync (roms backup as list)                         |
| backup_system.sh     | system backup with rsync from local/remote location to specific usb device    |
| color_picker.sh      | pick color with a tool, copy hex to clipboard and preview with notify-send    |
| delete_metafiles.sh  | delete hidden apple metadata files in home folder                             |
| git_clone.sh         | clone all repositories of a user or organization                              |
| git_multi.sh         | execute git command on multiple repositories                                  |
| padd_update.sh       | script to update pi-hole padd                                                 |
| ssh_exec.sh          | execute command with ssh if remote host not local host                        |
| status.sh            | simple script for system information in different formats                     |
| sync_notes.sh        | sync notes to webserver                                                       |
| system_cleanup.sh    | purge cache and remove duplicated entries from python-, bash- and zsh-history |
| touchpad_toggle.sh   | disable/enable touchpad                                                       |
| urxvtc.sh            | start urxvtd if not already running and open urxvtc                           |
| w3m.sh               | terminal wrapper for w3m with or without suckless tabbed                      |
| wallpaper.sh         | set and load wallpaper (file/random file from directory) from xresources      |
| windows_key.sh       | read windows product key from uefi                                            |
| wireguard_toggle.sh  | enable/disable wireguard interface with predefined config in systemd-network  |

related projects:

- [dmenu](https://github.com/mrdotx/dmenu)
- [dotfiles](https://github.com/mrdotx/dotfiles)
