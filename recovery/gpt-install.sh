#!/bin/sh

. ./installer.lib
if [ $? -ne 0 ]; then
    echo "fatal error: failed sourcing installer.lib"
    read -p "Press enter key to exit." REPLY
    exit 127
fi
p() {
    if ! parted -s "$install_device" $*
    then
        die "exited $? when running parted $*"
    fi
}


install_device="$1"
esp_device="${install_device}1"
swap_size="$2"
if [ -n "$swap_size" ]; then
    die "Fatal error: swap isn't supported yet :'("
else
    recovery_device="${install_device}2"
    swap_device=""
    root_device="${install_device}3"

    # esp is 260
    recovery_offset="260M"
    # recovery is 1024
    root_offset="1284M"
fi

[ -b "$install_device" ] || {
    echo "usage: $0 DEVICE [swap size]"
    exit 64
}

echo DEBUG, DEBUG, DEBUG
echo install_device=$install_device esp_device=$esp_device swap_device=$swap_device recovery_device=$recovery_device root_device=$root_device
echo swap_size=$swap_size recovery_offset=$recovery_offset root_offset=$root_offset
# echo "get_part_number esp_device = $(get_part_number $esp_device)"
# echo "get_part_number swap_device = $(get_part_number $swap_device)"
# echo "get_part_number recovery_device = $(get_part_number $recovery_device)"
# echo "get_part_number root_device = $(get_part_number $root_device)"
echo DEBUG, DEBUG, DEBUG

if [ -n "$nopartition" ]; then
    warn "Skipping partitioning $install_device because -nopartition was given."
else
    echo "Zeroing start of ${install_device}."
    dd if=/dev/zero "of=$install_device" bs=1M count=10

    echo "Making new partition table on ${install_device}."
    p mktable gpt

    create_boot_partition "$install_device" "$esp_device" 1 "$recovery_offset" ESP
    create_recovery_partition "$install_device" "$recovery_device" "$recovery_offset" "$root_offset" Recovery
    create_root_partition "$install_device" "$root_device" "$root_offset" "100%" TOS
fi

ls_partitions

if [ -n "$noformat" ]; then
    warn "Skipping formatting partitions because -noformat was given."
else
    format_boot_partition "$esp_device"
    format_recovery_partition "$recovery_device"
    format_root_partition "$root_device"
fi


say "Installing system files."

install_image "$root_device" /images/root.txz
install_image "$recovery_device" /images/recovery.txz
install_image "$esp_device" /images/boot.txz


say "Setting up boot loader."

install_mbr gptmbr "$install_device"
install_efiboot "$esp_device" "$(uname -m)"
do_mount "$esp_device" /mnt boot
write_syslinux_cfg "$root_device" "$recovery_device" /mnt/EFI/BOOT/syslinux.cfg
echo "TODO: aslo load syslinux for mbr boot compat and write syslinux.cfg that sources efi one."
do_umount "$esp_device" /mnt boot


do_mount "$root_device" /mnt root
say "Writing /etc/fstab to root partition."
cat << EOF > /mnt/etc/fstab
# (U)EFI System Partition (ESP)
$esp_device /boot vfat defaults 0 1
# Recovery Partition
$recovery_device /recovery ext2 defaults 0 2
# / Partition
$root_device / ext4 defaults 0 3
EOF
cat $fstab
do_umount "$root_device" /mnt root

echo "ALL DONE"
