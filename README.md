# shell

shell scripts for system/hardware management and general maintenance

| folder name  | comment                    |
| :----------- | :------------------------- |
| old          | old stuff                  |

| name                 | comment                                                                       |
| :------------------- | :---------------------------------------------------------------------------- |
| alpha_restore.sh     | find png files with suspicious data in alpha channel                          |
| aria2c.sh            | add download urls to aria2c                                                   |
| backup.sh            | rsync backup to remote location (ssh)                                         |
| backup_usb.sh        | rsync backup to usb                                                           |
| chameleon.sh         | pick color with chameleon to copy to clipboard and primary                    |
| cpu_policy.sh        | change cpu policies with cpufreqctl                                           |
| delete_metafiles.sh  | delete hidden apple metadata files in home folder                             |
| git_clone.sh         | clone all repositories of a user or organization                              |
| git_multi.sh         | execute git command on multiple repositories                                  |
| git_reset_commits.sh | remove commits from a git repository                                          |
| memtest86.sh         | install or upgrade memtest86 on efi partition                                 |
| status.sh            | simple script for system information in different formats                     |
| system_cleanup.sh    | purge cache and remove duplicated entries from python-, bash- and zsh-history |
| touchpad_toggle.sh   | disable/enable touchpad                                                       |
| urxvtc.sh            | start urxvtd if not already running and open urxvtc                           |
| w3m.sh               | terminal wrapper for w3m with or without suckless tabbed                      |
| wallpaper.sh         | set and load wallpaper (file/random file from directory) from xresources      |

related projects:

- [dmenu](https://github.com/mrdotx/dmenu)
- [dotfiles](https://github.com/mrdotx/dotfiles)
