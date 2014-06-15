# encdrive - toolset for a Truecrypt replacement

When the Truecrypt developers decided to let go further development on Truecrypt I searched for a proper replacement to support encrypted file systems in a lightweight, open source and platform independent manner.

I found out that the virtual file system supports file systems inside (big) files and that loopback devices support adding encryption to VFS. So I decided to give it a try and wrote this shell script helpers to ease the handling a bit.

## Usage
To use the shell scripts you have to 

1. get them on your computer
2. copy them to for instance /usr/local/bin
3. ensure they are executable for at least root

### Setting up a new encryped drive in a file
To setup an encrypted drive just 

1. call `sudo encdrive-create.sh`. 
2. The system will create a new file (per default ~/.encdrivedata, 1 GB size), containing random garbage. If the file exists, the script aborts.
3. Next an encrypted loopback device will be created. You have to specify a secure password used for encryption and decryption.
4. Then an ext3 file system  is created within the encrypted loopback device.

That's it, you now can mount the encrypted drive.

### Mounting an encrypted drive
To mount the encrypted drive, just call `sudo encdrive-mount.sh`. The system will ask you for the password that is valid for the encrypted loopback device. The filesystem will be mounted on ~/drive_encoded, which gets created if it does not exist.

### Unmounting an encrypted drive
If you are done with the drive, just call `sudo encdrive-umount.sh` to unmount the filesystem and delete the loopback device.

## Configuration
If you don't like the default settings (~/.encdrivedata created woth 1GB mounted into ~/drive_encoded) you can create a file  ~/.encdrive and specify variables like they are specified in the default settings:
```
#
# The file containing the encrypted filesystem
#
enc_file=~/.encdrivedata

#
# The directory used as a mountpoint for the mounted filesystem
#
mount_point=~/drive_encoded


#
# user.group used with chown to own the mounted filesystem
#
user_group=$SUDO_USER.$SUDO_USER

#
# Number of blocks to be allocated for disk, each block has 512 bytes, afaik.
# So we are allocating 1 GB:
#
block_count=2097152

```
