#!/bin/busybox sh

# debug
E() {
    printf "\texec: %s\n" "$*"
}
EE() {
    printf "\texec: %s\n" "$*"
    command $*
}

. ./installer.lib
if [ $? -ne 0 ]; then
    echo "fatal error: failed sourcing installer.lib"
    sleep 500
    exit
fi

#########################################################


say "Welcome to The Other System's installer."

echo "Please wait while preparations are made."

if [ "$(id -u)" -ne 0 ]; then
    say "##############################" \
        "Not running as root: I hope you're debugging this!" \
        "##############################"
fi

[ -d /proc ] || mkdir /proc
E mount -t proc  none /proc
[ -d /sys ] || mkdir /sys
E mount -t sysfs none /sys

say "We need a device to install to. First let's see what your computer has."
ls_devices
say "Type a device name and press enter to view its details." \
    "Just press enter to continue to selecting a device."
while read -p "Review device: " install_device
do
    [ -z "$install_device" ] && break
    [ ! -b "$install_device" ] \
        && echo "$install_device is not a block device" \
        && continue
    EE parted "$install_device" print
done

say "OK, which should we install to?"
say "Press enter to see the list again."
while read -p "Install to: " install_device
do
    [ -z "$install_device" ] && ls_devices && continue
    [ -b "$install_device" ] && break
done

say "OK: we will be installing to ${install_device}."

echo "Device size: $(parted -s "$install_device" print \
                        | grep "Disk ${install_device}:" \
                        | awk '{print $3}')."

say "Before use $install_device must be labelled, partitioned, and formatted."

machine_type="$(uname -m)"
# is it i386 for x86_32?
if [ "$machine_type" = i386 -o "$machine_type" = x86_64 ]; then
    echo "$machine_type can be partitioned in one of two ways."
    echo "MS-DOS style: legacy table format used by BIOS. Very limited."
    echo "GPT style: modern table format used by UEFI. Recommended."
    while read -p "msdos or gpt: " table_type; do
        [ "$table_type" = "msdos" -o "$table_type" = "gpt" ] && break
    done
fi


say "You may wish to create a SWAP partition." \
    "This will be used when you run out of memory or store large files in a tmpfs." \
    "Suspending to disk (hibernation) requires SWAP >= installed memory." \
    "It is easy to create a SWAP file later if necessary."

gigs_of_ram="$(get_memory -g)"
if [ "$gigs_of_ram" -lt 5 ]; then
    say "It is recommended that we create a SWAP partition."
fi
say "Your machine has $(get_memory -m)M (${gigs_of_ram}G) of memory installed." \
    "The recommended SWAP size is usualy equal or double this value."

while read -p "Create a swap partition: yes/no? " want_swap; do
    if echo "$want_swap" | grep -qi '^y'; then
        echo "OK: you want a SWAP partition."
        echo "Any size understood by GNU Parted may be entered. The default is Megabytes."
        read -p "Enter SWAP size: " want_swap
        break
    elif  echo "$want_swap" | grep -qi '^n'; then
        want_swap=""
        echo "OK: you do NOT want a SWAP parition."
        break
    fi
done
say "Let's review your install settings: "
for v in machine_type install_device table_type want_swap; do
    printf "\t$(echo "$v" | sed -e 's/_/ /g'): '$(eval "echo \$$v")'\n"
done

say "Press enter to begin installation now." \
    "To restart this program press control+c" \
    "To abort totally: shutdown the computer!"

read -p "Press enter to continue"

#
# Write out a script that we can use -- even in recovery.
#

say "DEBUG, DEBUG, DEBUG"

if [ "$table_type" = "gpt" ]; then
    install_tool="gpt-install"
elif [ "$table_type" = "msdos" ]; then
    install_tool="mbr-install"
else
    echo "Internal software error: unknown table_type: $table_type"
fi

cat << EOF > /recovery
#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/
export PATH

echo "Initialating recovery on $install_device in 30 seconds."
sleep 30

script -c '$install_tool "$install_device" "$want_swap"' /recovery.log

echo DEBUG
read -p "Press enter to exit."
EOF
# TODO: run this instead of exec and then move to finished recovery partition on target.
chmod +x /recovery
exec /recovery

# NOTREACED
die "Failed to exec recovery program!"
