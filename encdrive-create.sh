#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/.encdrive-default
echo -e "Creating encrypted container in $enc_file\n"

test -f $enc_file && {
  echo "$enc_file exists, aborting."
  exit 1
}

echo "Creating disk of size $block_count (number of blocks, each block 512 byte)"
dd if=/dev/urandom of=$enc_file count=$block_count || {
  echo "Operation failed, aborting"
  exit 1
}

chown $user_group $enc_file

device=$(losetup -f)

echo "##########################################"
echo " Now preparing an encrypted device."
echo " Choose a secure password for your drive!"
echo "##########################################"
losetup -e aes $device $enc_file ||  {
  echo "Could not create encrypted loopback device in $enc_file. Aborting"
  exit 1
}

echo "Creating ext3 filesystem in loopback device $device"
/sbin/mkfs -t ext3 -q $device || {
  echo "Failed to create filesystem. Aborting."
  exit 1
}


echo "Cleaning up, removing loopback device"
losetup -d $device

echo "Success. To mount the new drive, call ./encdrive-mount.sh"

