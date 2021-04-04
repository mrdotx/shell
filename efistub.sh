#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/efistub.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-04T13:51:14+0200

# config
disk="/dev/nvme0n1"
root="root=UUID=5b21fe4a-3cae-4150-91bc-bf1d5ddbe03a rw"
ucode="initrd=/intel-ucode.img"

logging="quiet udev.log_priority=3"
mitigations="mitigations=off"
# mitigations="mitigations=off i915.mitigations=off"
others="random.trust_cpu=on snd_hda_codec_hdmi.enable_silent_stream=0"
options="$logging $mitigations $others"

boot_num="0000 0001 0002 0003 0004 0005 0006 0007 0008"
boot_order="0000,0002,0004,0006,0008,0001,0003,0005,0007"

# functions for efibootmgr
delete_entries() {
    for i in $boot_num
    do
        printf "%s " "$i"
        efibootmgr \
            --bootnum "$i" \
            --delete-bootnum \
            --quiet
    done
    i=0
    printf "\n"
}

create_entry() {
    printf "   %04x %s\n" "$i" "$1"
    efibootmgr \
        --disk "$disk" \
        --create \
        --label "$1" \
        --loader "$2" \
        --unicode "$3" \
        --quiet
    i=$((i + 1))
}

create_boot_order() {
    printf "   %s\n" "$boot_order"
    efibootmgr \
        --bootorder "$boot_order" \
        --quiet
}

# functions to create entries
ck() {
    label="Con Kolivas Skylake Linux $1"
    kernel="/vmlinuz-linux-ck-skylake"
    initrd="/initramfs-linux-ck-skylake"
    create_entry \
        "$label" \
        "$kernel" \
        "$root $ucode initrd=$initrd.img $options"
    create_entry \
        "$label Fallback" \
        "$kernel" \
        "$root $ucode initrd=$initrd-fallback.img"
}

manjaro() {
    label="Manjaro Linux $1"
    kernel="/vmlinuz-$1-x86_64"
    initrd="/initramfs-$1-x86_64"
    create_entry \
        "$label" \
        "$kernel" \
        "$root $ucode initrd=$initrd.img $options"
    create_entry \
        "$label Fallback" \
        "$kernel" \
        "$root $ucode initrd=$initrd-fallback.img"
}

memtest() {
    create_entry \
        "MemTest86 $1" \
        "/EFI/memtest86/BOOTX64.efi"
}

# main
if [ ! "$(id -u)" = 0 ]; then
    printf "this script needs root privileges to run\n"
    exit 1
else
    printf ":: delete boot numbers\n   "
    delete_entries
    printf "\n"

    printf ":: create boot entries\n"
    ck "5.11"
    manjaro "5.12"
    manjaro "5.11"
    manjaro "5.4"
    memtest "9.0"
    printf "\n"

    printf ":: create boot order\n"
    create_boot_order
fi
