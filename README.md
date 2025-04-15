# shell

shell scripts for system/hardware management and general maintenance

| folder  | comment                                        |
| :------ | :--------------------------------------------- |
| archive | old stuff and things that couldn't be assigned |
| config  | configuration files and examples               |
| systemd | systemd services and timer                     |

| file                 | comment                                                                       |
| :------------------- | :---------------------------------------------------------------------------- |
| alsa.sh              | change volume with status notification                                        |
| aria2c.sh            | add download urls to aria2c                                                   |
| aurbuild.sh          | aurutils sync packages and sync devel packages                                |
| backlight.sh         | change backlight brightness with status notification                          |
| backup_keys.sh       | key backup with rsync to specific usb device                                  |
| backup_nds.sh        | nds flashcard backup with rsync (roms backup as list)                         |
| backup_system.sh     | system backup with rsync from local/remote location to specific usb device    |
| color_picker.sh      | pick color with a tool, copy hex to clipboard and preview with notify-send    |
| compressor.sh        | script to compress/extract/list files and folders                             |
| cyanrip.sh           | wrapper for cyanrip cd ripping tool                                           |
| dynv6.sh             | script to update dyndns service dynv6 with multi-config file                  |
| fritzbox.sh          | get data from the fritzbox: external ipv4/-v6 and current up-/download rates  |
| git_multi.sh         | execute git command on multiple repositories                                  |
| git_repos.sh         | perform oparations for all repositories of a user or organization             |
| padd_update.sh       | script to update pi-hole padd                                                 |
| pdf.sh               | script to compress/convert/chain/unchain pdf files                            |
| pkgstats.sh          | download package stats from arch packages                                     |
| ssh_exec.sh          | execute command with ssh if remote host is not local host                     |
| status.sh            | simple script for system information in different formats                     |
| stopwatch.sh         | script to measure the time                                                    |
| sync_notes.sh        | sync notes to webserver                                                       |
| system_cleanup.sh    | purge cache and remove duplicated entries from python-, bash- and zsh-history |
| test_broadband.sh    | outputs speedtest-cli results to a structured csv file                        |
| test_drive.sh        | measure drive speed with dd in current folder                                 |
| test_notification.sh | generates test messages for processing with notify-send                       |
| touchpad_toggle.sh   | disable/enable touchpad                                                       |
| urxvtc.sh            | start urxvtd if not already running and open urxvtc                           |
| w3m.sh               | terminal wrapper for w3m with or without suckless tabbed                      |
| wallpaper.sh         | set and load wallpaper (file/random file from directory) from xresources      |
| windows_key.sh       | read windows product key from uefi                                            |
| wireguard_toggle.sh  | enable/disable wireguard interface with predefined config in systemd-network  |

related projects:

- [dmenu](https://github.com/mrdotx/dmenu)
- [dotfiles](https://github.com/mrdotx/dotfiles)
