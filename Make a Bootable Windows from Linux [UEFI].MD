## Make a Bootable Windows from Linux [UEFI]
---

| Require Tool  | 
| ---------- |
| gparted    |
| furiusisomount|



#### **STEP 1**
1. Format FlaskDisk (gparted) -> select `fat32`
2. Unmount FlashDisk (gparted)
3. Create Partition Table (gparted) -> select `msdos`
	* make freespace 1-2 mb
4. Click Apply

#### **STEP 2**
* open furiusisomount
* select `iso file`
* click `Loop` radiobutton
* click `Mount`

#### **STEP 3**
* **copy all** `file from iso to flaskdisk`

#### **STEP 4**
1.  **Make it bootable** 
`sudo grub-install --target=i386-pc --boot-directory="/media/<username>/<drive_label>/boot" /dev/sd<Xtarget>`
* **Replace**:
`/media/<username>/<drive_label>` with the path where USB drive is mounted;
/dev/sdX with the USB drive, not the partition `(e.g. /dev/sdb)`

Wait for it to finish. If everything is OK, you should see:
```
Installing for i386-pc platform.  
Installation finished. No error reported.
```

#### **STEP 5**

* Now, create a text file and write the following in it:
 
1. ** cd to flashdisk /boot/grub **
2. create new file `grub.cfg`


```
default=1  
timeout=15
color_normal=light-cyan/dark-gray
menu_color_normal=black/light-cyan
menu_color_highlight=white/black
 
menuentry "Start Windows Installation" {
    insmod ntfs
    insmod search_label
    search --no-floppy --set=root --label <USB_drive_label> --hint hd0,msdos1
    ntldr /bootmgr
    boot
}

menuentry "Boot from the first hard drive" {
    insmod ntfs
    insmod chain
    insmod part_msdos
    insmod part_gpt
    set root=(hd1)
    chainloader +1
    boot
}

```

Replace `<USB_drive_label>` with the label from step 1 (you can place it between quotes if it contains a space, although it is not recommended to use spaces in drive label). Save the file as grub.cfg and put it on the USB drive in the boot/grub folder.
That's it. The USB drive is now bootable from BIOS and can be used to install Windows on your PC. The first time you boot from it in MBR BIOS or CSM mode select `Start Windows Installation.`
