#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/efistub.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-01T19:06:34+0200

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
label="Con Kolivas Skylake Linux"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-linux-ck-skylake \
    --unicode "$root $initrd initrd=/initramfs-linux-ck-skylake.img $options" \
    --quiet

label="Con Kolivas Skylake Linux Fallback"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-linux-ck-skylake \
    --unicode "$root $initrd initrd=/initramfs-linux-ck-skylake-fallback.img" \
    --quiet

label="Manjaro Linux 5.11"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-5.11-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.11-x86_64.img $options" \
    --quiet

label="Manjaro Linux 5.11 Fallback"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-5.11-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.11-x86_64-fallback.img" \
    --quiet

label="Manjaro Linux 5.4"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-5.4-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.4-x86_64.img $options" \
    --quiet

label="Manjaro Linux 5.4 Fallback"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
    --loader /vmlinuz-5.4-x86_64 \
    --unicode "$root $initrd initrd=/initramfs-5.4-x86_64-fallback.img" \
    --quiet

label="MemTest86 9.0"
printf ":: create %s entry\n" "$label"
efibootmgr \
    --disk "$disk" \
    --create \
    --label "$label" \
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
