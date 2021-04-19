#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/efistub.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-19T14:30:31+0200

# config
disk="/dev/nvme0n1"

root="root=UUID=5b21fe4a-3cae-4150-91bc-bf1d5ddbe03a rw"
ucode="initrd=/intel-ucode.img"

kernel_parameter() {
    parameter="
        quiet
        udev.log_priority=3
        random.trust_cpu=on
        snd_hda_codec_hdmi.enable_silent_stream=0
        mitigations=off
        # i915.mitigations=off
    "

    if [ "$(printf "%s" "$1" | sed 's/\.//')" -ge 512 ]; then
        printf "%s i915.mitigations=off" "$(pivot "$parameter" " ")"
    else
        printf "%s" "$(pivot "$parameter" " ")"
    fi
}

# helper functions
pivot() {
    printf "%s\n" "$1" \
        | awk '{gsub(/^ +| +$/,"")} !/^($|#)/ {print $0}' \
        | {
            while IFS= read -r line; do
                if [ -n "$entry" ]; then
                    entry="$entry$2$(printf "%s" "$line")"
                else
                    entry="$(printf "%s" "$line")"
                fi
            done
            printf "%s\n" "$entry"
        }
}

# efibootmgr functions
get_entries() {
    efibootmgr \
        | grep "\*" \
        | sed 's/^Boot//g;s/\*.*//g'
}

get_entry() {
    efibootmgr \
        | grep "$1$" \
        | sed 's/^Boot//g;s/\*//g'
}

delete_entries() {
    for i in $(get_entries)
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
    get_entry "$1"
}

create_boot_order() {
    boot_order="$(pivot "$(get_entries)" ",")"
    printf "   %s\n" "$boot_order"
    efibootmgr \
        --bootorder "$boot_order" \
        --quiet
}

# functions to create boot entries
ck() {
    label="Con Kolivas Skylake Linux $1"
    kernel="/vmlinuz-linux-ck-skylake"
    options="$root $ucode initrd=/initramfs-linux-ck-skylake"
    if [ -z "$2" ]; then
        create_entry \
            "$label" \
            "$kernel" \
            "$options.img $(kernel_parameter "$1")"
    else
        create_entry \
            "$label $2" \
            "$kernel" \
            "$options-$2.img"
    fi
}

manjaro() {
    label="Manjaro Linux $1"
    kernel="/vmlinuz-$1-x86_64"
    options="$root $ucode initrd=/initramfs-$1-x86_64"
    if [ -z "$2" ]; then
        create_entry \
            "$label" \
            "$kernel" \
            "$options.img $(kernel_parameter "$1")"
    else
        create_entry \
            "$label $2" \
            "$kernel" \
            "$options-$2.img"
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
