# -------------------------------
# USB Installation | Manjaro Xfce
# -------------------------------
set -e

# //www.archlinux.org/download/
# //manjaro.org/products/download/x86
# //wiki.archlinux.org/title/USB_flash_installation_medium
# NOTE: in windows, use something like //rufus.akeo.ie/
filename="manjaro-xfce-24.1.1-241011-linux610.iso"
filesha1="62944dd95c12507f699cd983766d6af29396687799439554e7340f4f6ae9b956"
iso_url="https://download.manjaro.org/xfce/24.1.1/$filename"
iso_path=/tmp/$filename
usb_device=/dev/sda

echo "Downloading Manjaro ISO from $iso_url..."
wget -q --show-progress $iso_url -O $iso_path

echo "Verifying the ISO checksum... Expecting $filesha1"
downloaded_sha1=$(sha256sum $iso_path | awk '{print $1}')

if [ "$downloaded_sha1" != "$filesha1" ]; then
    echo "Checksum mismatch! Got $downloaded_sha1."
    exit 1
fi

echo "Unmounting the USB device $usb_device..."
umount ${usb_device}*

echo "Writing the ISO to the USB drive ($usb_device)..."
sudo dd bs=4M if=$iso_path of="/dev/sda" conv=fdatasync status=progress

sync
