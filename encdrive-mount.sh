#!/bin/bash
#set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/.encdrive-default
echo -e "Mounting $enc_file into $mount_point\n"

losetup -a | grep "$enc_file"
if [ $? -eq 0 ]; then
  echo "Existing loopback device found referring to $enc_file, aborting."
  exit 1
fi

device=$(losetup -f)

echo "Creating mount point directory"
mkdir -p "$mount_point"
modprobe cryptoloop

echo "Preparing loopback $device for $enc_file with encryption, enter passphrase..."
losetup -e aes $device "$enc_file" || {
  echo "Preparation failed, aborting."
  exit 1
}

echo "Mounting filesystem..."
mount -t ext3 $device "$mount_point" ||  {
  echo "Mounting failed, deleting loopback device"
  losetup -d $device
  exit 1
}
echo "Taking ownership for mountpoint as $user_group"
chown -R $user_group "$mount_point"
echo "...done"
