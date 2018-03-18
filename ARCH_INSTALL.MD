# Arch Linux installation (preinstalled Windows 10 dual boot) by MDVK


## Before

1. Disable Windows Fast-Startup
2. Disable Secure Boot


## Partitioning

Before:

| Partition  | Location | Size       | File system |
| ---------- |:--------:|:----------:|:-----------:|
| ESP        | sda1     | 500 MB     | fat32       |
| DIAGS      | sda2     | 40 MB      | fat32       |
| OEM 1      | sda3     | 128 MB     | ?           |
| WINRETOOLS | sda4     | 750 MB     | ntfs        |
| WINDOWS 8  | sda5     | 913.878 GB | ntfs        |
| PBR        | sda7     | 8.25 GB    | ntfs        |
| OEM 2      | sda6     | 8 GB       | ?           |

After:

| Partition  | Location | Size      | File system |
| ---------- |:--------:|:---------:|:-----------:|
| ESP        | sda1     | 500 MB    | fat32       |
| DIAGS      | sda2     | 40 MB     | fat32       |
| OEM 1      | sda3     | 128 MB    | ?           |
| WINRETOOLS | sda4     | 750 MB    | ntfs        |
| WINDOWS 8  | sda5     | 200 GB    | ntfs        |
| /boot      | sda8     | 200 MB    | ext2        |
| swap       | sda9     | 8.5 GB    | swap        |
| /          | sda10    | 705.18 GB | ext4        |
| PBR        | sda7     | 8.25 GB   | ntfs        |
| OEM 2      | sda6     | 8 GB      | ?           |


## Load keyboard layout

```
$ loadkeys la-latin1
```


## Connect to the internet (Wi-Fi)

```
$ iw dev    # Get the interface name
$ wifi-menu <wifi_interface_name>
```


## Format and mount disks

```
$ mkfs.ext2 /dev/sda8
$ mkfs.ext4 /dev/sda10
$ mkswap /dev/sda9
$ swapon /dev/sda9
$ mount /dev/sda10 /mnt
$ mkdir /mnt/boot
$ mount /dev/sda8 /mnt/boot
```


## Set mirrors

Set the preferred mirror first.
To find the best mirrors:

```
$ rankmirrors -n 6 /etc/pacman.d/mirrorlist > mirrorlistbest
```

In my case, the best one at the moment was: http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch

```
$ vi /etc/pacman.d/mirrorlist
```


## Install

```
$ pacstrap /mnt base base-devel
```


## Generate fstab

```
$ genfstab -U -p /mnt >> /mnt/etc/fstab
```

## Chroot and configure base system

```
$ arch-chroot /mnt /bin/bash
```


### Root password

```
$ passwd
```


### Hostname

```
$ echo miguelarch >> /etc/hostname
$ vi /etc/hosts
```

/etc/hosts should look like:

```
127.0.0.1   localhost.localdomain   localhost   miguelarch
::1         localhost.localdomain   localhost   miguelarch
```


### Timezone

```
$ echo "America/Mexico_City" >> /etc/timezone
$ ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime
```


### Locale

```
$ vi /etc/locale.gen
$ locale-gen
$ echo LANG=es_MX.UTF-8 > /etc/locale.conf
$ export LANG=es_MX.UTF-8
```

On `/etc/locale.gen` I uncommented `es_MX.UTF-8 UTF-8` and `en_US.UTF-8 UTF-8`


### Console font and keymap

```
$ vi /etc/vconsole.conf
```

It should look like:

```
KEYMAP=la-latin1
FONT=
FONT_MAP=
```


### Hardware clock

```
hwclock --systohc --utc
```


### Initial ramdisk environment

```
$ mkinitcpio -p linux
```


### GRUB

```
$ pacman -S dosfstools grub efibootmgr
$ mkdir /boot/efi
$ mount /dev/sda1 /boot/efi
```

Edit `/etc/default/grub`, set `DEFAULT_TIMEOUT=30`.

```
$ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck
$ grub-mkconfig -o boot/grub/grub.cfg
```

Now, let's add Windows to the GRUB menu. Edit `/boot/efi/EFI/grub/grub.cfg` and add the following menuentry after the Arch Linux menuentries:

```
menuentry "Microsoft Windows 8.1" {
    insmod part_gpt
    insmod fat
    insmod search_fs_uuid
    insmod chain
    search --fs-uuid --set=root $hints_string $fs_uuid
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

Now change:

- `$hints_string` by the output of `$ grub-probe --target=fs_uuid /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi`

- `$fs_uuid` by the output of `$ grub-probe --target=hints_string /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi`


### Network configuration

```
$ pacman -S iw wpa_supplicant networkmanager
```

I chose to use NetworkManager since I like how it integrates with Gnome3 via NetworkManager-Applet. Disable all network services before using NetworkManager.

```
$ systemctl enable NetworkManager
```


## Unmount and reboot

```
$ exit      # If still on arch-chroot mode
$ umount -R /mnt
$ reboot
```


## After installation

### Connect to the internet

```
$ nmcli nm wifi on
$ nmcli dev wifi connect <network ssid> password <password>
```

### Install zsh

```
$ pacman -S zsh
```


### Create user

```
$ useradd -m -g users -G wheel -s /bin/zsh miguel
$ passwd miguel
$ chfn miguel
```


### Install X

Laptop trackpad support: `$ pacman -S xf86-input-synaptics`

```
$ pacman -S xorg-server xorg-server-utils xorg-xinit
```


### Dynamic switching between NVIDA and Intel integrated graphics

In `/etc/pacman.conf`, uncomment:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

```
$ pacman -S intel-dri xf86-video-intel nvidia bbswitch bumblebee lib32-nvidia-utils lib32-intel-dri
$ gpasswd -a miguel bumblebee
$ systemctl enable bumblebeed
```

Edit `/etc/default/grub`, set `GRUB_CMDLINE_LINUX_DEFAULT="quiet rcutree.rcu_idle_gp_delay=1"`.

Edit `/etc/bumblebee/xorg.conf.nvidia`, set `BusID "PCI:4:0:0"`. Where the PCI should be the one shown for the Nvidia card in `lspci`.

To turn on Nvidia graphics card:

```
$ tee /proc/acpi/bbswitch <<< ON
$ modprobe nvidia
```

To turn it off:

```
$ modprobe -r nvidia
$ tee /proc/acpi/bbswitch <<< OFF
```

To get information about PCI devices (Shows if Nvidia card is activeted or deactivated and the driver it's using):

```
$ lspci -v
$ lspci -k
$ lspci
```

Test if Bumblebee is working:

```
$ pacman -S xorg-twm xorg-xclock xterm mesa-demos
$ startx
$ optirun glxgears -info
```


### Install Gnome

```
$ pacman -S gnome network-manager-applet
$ systemctl enable gdm.service
```


### Other configurations

Add `ILoveCandy` under `Misc options` in `/etc/pacman.conf`


#### Yaourt

Install AUR packages.

```
$ curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
$ tar zxvf package-query.tar.gz
$ cd package-query
$ makepkg -si
$ cd ..
$ rm -rf package-query*
$ curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
$ tar zxvf yaourt.tar.gz
$ cd yaourt
$ makepkg -si
$ cd ..
$ rm -rf yaourt*
```


#### HDAPSD

Protect disk.

```
$ pacman -S hdapsd
$ systemctl enable hdapsd
```


#### Specific for my Dell Inspiron 7537

To see the battery levels, add `acpi_osi=Linux` to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub.cfg`. If the backlight service fails after that, add `acpi_backlight=vendor` too (didn't happen to me, but [this thread](https://bbs.archlinux.org/viewtopic.php?id=179139) claims that it can happen).

```
$ grub-mkconfig -o boot/grub/grub.cfg
```


#### Ruby

```
$ yaourt -S rbenv ruby-build
$ rbenv install 2.1.2
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc
$ gem install bundler
```


#### Other stuff

```
$ pacman -S ttf-dejavu wget acpi vim rfkill ctags tree  gimp nodejs infinality-bundle gnome-tweak-tool gloobus-preview terminator viewnior synapse openssh
$ yaourt -S google-chrome spotify sublime-text python-markdown retext gnome-shell-extension-topicons 
$ mkdir $HOME/.config/terminator
$ curl -o $HOME/.config/terminator/config https://raw.githubusercontent.com/ghuntley/terminator-solarized/master/config 
$ curl -L http://install.ohmyz.sh | sh
$ wget -qO- https://toolbelt.heroku.com/install.sh | sh
```

## References


### Installation

- [Arch Linux Wiki: Beginners Guide](https://wiki.archlinux.org/index.php/beginners'_guide#GRUB_2)
- [Arch Linux Wiki: GRUB](https://wiki.archlinux.org/index.php/GRUB)
- [Arch Linux Wiki: Installation](https://wiki.archlinux.org/index.php/Installation_guide)
- [Arch Linux Wiki: Windows and Arch dual boot](https://wiki.archlinux.org/index.php/Windows_and_Arch_Dual_Boot)


### Post-intallation

- [Arch Linux Wiki: General Recommendations](https://wiki.archlinux.org/index.php/General_recommendations)
- [Arch Linux Wiki: Users and Groups](https://wiki.archlinux.org/index.php/Users_and_groups)
- [Arch Linux Wiki: NVIDIA](https://wiki.archlinux.org/index.php/NVIDIA)
- [Arch Linux Wiki: Bumblebee](https://wiki.archlinux.org/index.php/Bumblebee)
- [Arch Linux Wiki: NVIDIA Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus)
- [Arch Linux Wiki: Xorg](https://wiki.archlinux.org/index.php/Xorg)
- [Arch Linux Forums: Bumblebee problem](https://bbs.archlinux.org/viewtopic.php?pid=1326090#p1326090)
- [Arch Linux Wiki: GNOME](https://wiki.archlinux.org/index.php/GNOME)
- [Arch Linux Wiki: NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager)
- [Arch Linux Forums: No battery after boot. Dell 7537](https://bbs.archlinux.org/viewtopic.php?id=179139)
- [Arch Linux Wiki: Yaourt](https://wiki.archlinux.org/index.php/yaourt)
- [Arch Linux Wiki: HDAPS](https://wiki.archlinux.org/index.php/Hard_Drive_Active_Protection_System)