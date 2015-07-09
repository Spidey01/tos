#!/bin/sh

. ./installer.lib
if [ $? -ne 0 ]; then
    echo "fatal error: failed sourcing installer.lib"
    read -p "Press enter key to exit." REPLY
    exit 127
fi

set_install_parameters "$@"
shift $?

# Now we will enable exit on unhandled error for now.
set -o errexit

install_device="$1"
swap_size="$2"
boot_device="${install_device}1"
recovery_device="${install_device}2"

if [ -n "$swap_size" ]; then
    die "Fatal error: swap isn't supported yet :'("
else
    root_device="${install_device}3"
    recovery_offset="260M"
    root_offset="1284M"
fi

[ -b "$install_device" ] || {
    file "$install_device"
    die "install_device $install_device is not a block special file."
}


if [ -n "$nopartition" ]; then
    warn "Skipping partitioning $install_device because -nopartition was given."
else
    echo "Zeroing start of ${install_device}."
    dd if=/dev/zero "of=$install_device" bs=1M count=10

    echo "Making new partition table on ${install_device}."
    parted -s "$install_device"  mktable msdos

    create_boot_partition "$install_device" "$boot_device" 1 "$recovery_offset"
    create_recovery_partition "$install_device" "$recovery_device" "$recovery_offset" "$root_offset"
    create_root_partition "$install_device" "$root_device" "$root_offset" "100%"
fi

ls_partitions "$install_device"

if [ -n "$noformat" ]; then
    warn "Skipping formatting partitions because -noformat was given."
else
    format_boot_partition "$boot_device"
    format_recovery_partition "$recovery_device"
    format_root_partition "$root_device"
fi


say "Installing system files."

install_image "$root_device" /images/root.txz
install_image "$recovery_device" /images/recovery.txz
install_image "$boot_device" /images/boot.txz

say "Setting up boot loader."

install_mbr mbr "$install_device"

# /syslinux/bios/linux/syslinux -d /boot/syslinux -i "$boot_device"
/syslinux/bios/linux/syslinux -i "$boot_device"
do_mount "$boot_device" /mnt boot
write_syslinux_cfg "$root_device" "$recovery_device" /mnt/syslinux.cfg
do_umount "$boot_device" /mnt boot


do_mount "$root_device" /mnt root
say "Writing /etc/fstab to root partition."
cat << EOF > /mnt/etc/fstab
# Boot partition
$boot_device /boot vfat defaults 0 1
# Recovery Partition
$recovery_device /recovery ext2 defaults 0 2
# / Partition
$root_device / ext4 defaults 0 3
EOF
cat $fstab
do_umount "$root_device" /mnt root
