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

echo "Zeroing start of ${install_device}."
dd if=/dev/zero "of=$install_device" bs=1M count=10

echo "Making new partition table on ${install_device}."
p mktable gpt

echo "Creating new EFI System Partition (ESP) on ${esp_device}."
p mkpart primary fat32 1 "$recovery_offset"
p name 1 ESP
p set 1 boot on
mkfs.vfat -v "$esp_device"

echo "Creating new Recovery Partition on ${recovery_device}."
p mkpart primary ext2 "$recovery_offset" "$root_offset" 
p name 2 recovery
p set 2 diag on
mkfs.ext2 "$recovery_device"


if [ -n "$swap_device" ]; then
    echo "Creating new SWAP partition on ${swap_device}."
    die "Not implemented"
    # p mkpart primary linux-swap 100M "$swap_size"
    # p name "$(get_part_number "$swap_device")" SWAP
    # mkswap "$swap_device"
fi


echo "Creating new / partition on ${root_device}."
p mkpart primary ext4 ${root_offset} '100%'
p name 3 TOS
mkfs.ext4 "$root_device"


say "Displaying partition table of ${install_device}"
parted "$install_device" print


say "Installing system files."

install_image "$root_device" root
install_image "$recovery_device" recovery
install_image "$esp_device" boot


say "Setting up boot loader."

install_mbr gptmbr "$install_device"
install_efiboot "$esp_device" "$(uname -m)"
do_mount "$esp_device" boot
cat << EOF > syslinux.cfg
LABEL TOS
    LINUX /vmlinuz
    APPEND rootwait root=${root_device} rw quiet
LABEL RECOVERY
    LINUX /vmlinuz
    APPEND rootwait root=${recovery_device} rw quiet

SAY TOS = The Other System from {$root_device}.
SAY RECOVERY = Reinstall from recovery partition from ${recovery_partition}.
DEFAULT TOS
PROMPT 1
TIMEOUT 50
EOF
echo "TODO: aslo load syslinux for mbr boot compat and write syslinux.cfg that sources efi one."
do_umount "$esp_device" boot


do_mount "$root_device" root
say "Writing /etc/fstab to root partition."
cat << EOF > /mnt/etc/fstab
# (U)EFI System Partition (ESP)
$esp_device /boot vfat defaults 0 1
# Recovery Partition
$esp_device /recovery ext2 defaults 0 2
# / Partition
$root_device / ext4 defaults 0 3
EOF
cat $fstab
do_umount "$root_device" root

echo "ALL DONE"
