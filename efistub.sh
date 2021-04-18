#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/efistub.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-18T09:47:47+0200

# config
disk="/dev/nvme0n1"
root="root=UUID=5b21fe4a-3cae-4150-91bc-bf1d5ddbe03a rw"
ucode="initrd=/intel-ucode.img"

logging="quiet udev.log_priority=3"
mitigations="mitigations=off"
# mitigations="mitigations=off i915.mitigations=off"
others="random.trust_cpu=on snd_hda_codec_hdmi.enable_silent_stream=0"
options="$logging $mitigations $others"

# functions for efibootmgr
delete_entries() {
    boot_entries=$(efibootmgr | grep "\*" | sed 's/^Boot//g;s/\*.*//g')
    for i in $boot_entries
    do
        printf "%s " "$i"
        efibootmgr \
            --bootnum "$i" \
            --delete-bootnum \
            --quiet
    done
    printf "\n"
}

create_entry() {
    printf "   "
    efibootmgr \
        --disk "$disk" \
        --create \
        --label "$1" \
        --loader "$2" \
        --unicode "$3" \
        --quiet
    efibootmgr | grep "$1$"
}

create_boot_order() {
    boot_order() {
        boot_entries=$(efibootmgr | grep "\*" | sed 's/^Boot//g;s/\*.*//g')
        printf "%s\n" "$boot_entries" | {
            while IFS= read -r line; do
                if [ -n "$entry" ]; then
                    entry="$entry,$line"
                else
                    entry="$line"
                fi
            done
            printf "%s\n" "$entry"
        }
    }

    printf "   %s\n" "$(boot_order)"
    efibootmgr \
        --bootorder "$(boot_order)" \
        --quiet
}

# functions to create entries
ck() {
    label="Con Kolivas Skylake Linux $1"
    kernel="/vmlinuz-linux-ck-skylake"
    initrd="$ucode initrd=/initramfs-linux-ck-skylake"
    if [ -z "$2" ]; then
        create_entry \
            "$label" \
            "$kernel" \
            "$root $initrd.img $options"
    else
        create_entry \
            "$label $2" \
            "$kernel" \
            "$root $initrd-$2.img"
    fi
}

manjaro() {
    label="Manjaro Linux $1"
    kernel="/vmlinuz-$1-x86_64"
    initrd="$ucode initrd=/initramfs-$1-x86_64"
    if [ -z "$2" ]; then
        create_entry \
            "$label" \
            "$kernel" \
            "$root $initrd.img $options"
    else
        create_entry \
            "$label $2" \
            "$kernel" \
            "$root $initrd-$2.img"
    fi
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
    ck "5.11" "fallback"
    manjaro "5.12"
    manjaro "5.12" "fallback"
    manjaro "5.11"
    manjaro "5.11" "fallback"
    manjaro "5.10"
    manjaro "5.10" "fallback"
    memtest "9.0"
    printf "\n"

    printf ":: create boot order\n"
    create_boot_order
fi
