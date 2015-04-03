#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/.encdrive-default
echo -e "Unmounting $enc_file from $mount_point\n"

fuser $mount_point && {
  echo "$mount_point is busy. Cannot unmount drive."
  echo "Consider using 'sudo lsof | grep \"$mount_point\"' or 'fuser $mount_point' to get more information."
  exit 1
}

losetup -a | grep "$enc_file"

if [ $? -ne 0 ]; then
  echo "No loopback device found referring to $enc_file, aborting."
  exit 1
fi

deviceline=$(losetup -a | grep "$enc_file")
device=${deviceline%%:*}
echo "Found loopback device $device for $enc_file"

echo "Unmounting $mount_point..."
umount $mount_point || echo "...failed"
echo "Deleting loopback device..."
losetup -d $device && echo "...done" || echo "...failed"

