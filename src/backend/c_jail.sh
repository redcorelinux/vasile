#!/usr/bin/env bash

export local jailbinmodecmd="vasile --binmode"
export local jailsrcmodecmd="vasile --srcmode"
export local jaildkmscmd="vasile --dkms"
export local jailmandbcmd="mandb --create"
export local jailportagecmd="emerge -kav "$jailtarget""
export local jaildracutcmd="dracut -N -a dmsquash-live -a pollcdrom --force --kver="$kernver" /boot/"$jailramfsname""
export local jailmkchainloadercmd="grub2-mkimage -d /usr/lib64/grub/i386-pc -o core.img -O i386-pc biosdisk part_msdos fat -p /boot/grub"
export local jailmkx64eficmd="grub2-mkimage -d /usr/lib64/grub/x86_64-efi -o bootx64.efi -O x86_64-efi ext2 fat udf btrfs ntfs reiserfs xfs hfsplus lvm ata part_msdos part_gpt part_apple bsd search_fs_uuid normal chain iso9660 configfile help loadenv reboot cat search memdisk tar boot linux chain -p /boot/grub"
export local jailmkia32eficmd="grub2-mkimage -d /usr/lib64/grub/i386-efi -o bootia32.efi -O i386-efi ext2 fat udf btrfs ntfs reiserfs xfs hfsplus lvm ata part_msdos part_gpt part_apple bsd search_fs_uuid normal chain iso9660 configfile help loadenv reboot cat search memdisk tar boot linux chain -p /boot/grub"
