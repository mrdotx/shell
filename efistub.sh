#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/efistub.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-01T11:53:00+0200

# config
disk="/dev/nvme0n1"
root="root=UUID=5b21fe4a-3cae-4150-91bc-bf1d5ddbe03a rw"
initrd="initrd=/intel-ucode.img"

# i915.mitigations=off
options="quiet udev.log_priority=3 random.trust_cpu=on mitigations=off snd_hda_codec_hdmi.enable_silent_stream=0"

boot_max=6
boot_order="0,1,2,3,4,5,6"

# check permission
[ ! "$(id -u)" = 0 ] \
   && printf "this script needs root privileges to run\n" \
   && exit 1

# delete existing entries
while [ $boot_max -ge 0 ]
do
    printf ":: delete boot number %s\n" "$boot_max"
    efibootmgr \
        --bootnum "$boot_max" \
        --delete-bootnum \
        --quiet
    boot_max=$((boot_max - 1))
done
printf "\n"

# create entries
printf ":: create Con Kolivas Skylake Linux entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Con Kolivas Skylake Linux" \
    --loader /vmlinuz-linux-ck-skylake \
    --unicode "$root $initrd initrd=/initramfs-linux-ck-skylake.img $options" \
    --quiet

printf ":: create Con Kolivas Skylake Linux Fallback entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Con Kolivas Skylake Linux Fallback" \
    --loader /vmlinuz-linux-ck-skylake \
    --unicode "$root $initrd initrd=/initramfs-linux-ck-skylake-fallback.img" \
    --quiet

printf ":: create Manjaro Linux 5.11 entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Manjaro Linux 5.11" \
    --loader /vmlinuz-5.11-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.11-x86_64.img $options" \
    --quiet

printf ":: create Manjaro Linux 5.11 Fallback entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Manjaro Linux 5.11 Fallback" \
    --loader /vmlinuz-5.11-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.11-x86_64-fallback.img" \
    --quiet

printf ":: create Manjaro Linux 5.4 entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Manjaro Linux 5.4" \
    --loader /vmlinuz-5.4-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.4-x86_64.img $options" \
    --quiet

printf ":: create Manjaro Linux 5.4 Fallback entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "Manjaro Linux 5.4 Fallback" \
    --loader /vmlinuz-5.4-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.4-x86_64-fallback.img" \
    --quiet

printf ":: create MemTest86 9.0 entry\n"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "MemTest86 9.0" \
    --loader /EFI/memtest86/BOOTX64.efi \
    --quiet
printf "\n"

# change boot order
printf ":: change boot order to %s\n" "$boot_order"
efibootmgr \
    --bootorder "$boot_order" \
    --quiet
printf "\n"

# show results
printf ":: show results\n"
efibootmgr
# efibootmgr --verbose
