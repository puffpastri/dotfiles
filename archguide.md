```
888    888                             888            
888    888                             888            
888    888                             888            
8888888888  .d88b.  888  888  888      888888 .d88b.  
888    888 d88""88b 888  888  888      888   d88""88b 
888    888 888  888 888  888  888      888   888  888 
888    888 Y88..88P Y88b 888 d88P      Y88b. Y88..88P 
888    888  "Y88P"   "Y8888888P"        "Y888 "Y88P"  

8888888                   888             888 888             d8888                 888      
  888                     888             888 888            d88888                 888      
  888                     888             888 888           d88P888                 888      
  888   88888b.  .d8888b  888888  8888b.  888 888          d88P 888 888d888 .d8888b 88888b.  
  888   888 "88b 88K      888        "88b 888 888         d88P  888 888P"  d88P"    888 "88b 
  888   888  888 "Y8888b. 888    .d888888 888 888        d88P   888 888    888      888  888 
  888   888  888      X88 Y88b.  888  888 888 888       d8888888888 888    Y88b.    888  888 
8888888 888  888  88888P'  "Y888 "Y888888 888 888      d88P     888 888     "Y8888P 888  888
```

#### Requirements:
* Ethernet connection
* USB drive (or CD) which will be wiped
	
**Notes**
+ Easier if you mount the Arch ISO already on a Linux machine, you could probs do it with Rufus as well in Windows tho idk
+ All commands are surrounded by ` ` so just follow those if you want
+ Tutorial taken from Luke Smith's "Full Arch Linux Install (SAVAGE Edition!)" video, timestamps linked at each section

# Part 1

### Mounting ISO [2:55]
1. Go to Arch Linux website, download Arch ISO
	+ https://www.archlinux.org/download/
	+ mounting can also be done on a windows machine, this first section is for doing it on linux

2. Go to terminal in Linux, enter:
	
	`lsblk`
	+ sda, sdb is name of drive, sda1, sda2 etc. is names of partitions.
	
3. Plug USB in, retype 
	
	`lsblk`
	+ make note of the new block that appears, be ABSOLUTELY SURE that this is the USB and not your harddrive or whatever
	+ look at the sizes of the blocks to make sure
	+ most likely it will be sdb if your main harddrive is sda
	
4. Enter root by typing:
	
	`sudo su`
	
5. Now for SCARY part. To mount the ISO, we use dd (disk dump/destroyer). Enter into terminal:
	
	`dd if=[ISO LOCATION] of=[USB LOCATION] status="progress"`
	+ *if* stands for input file, *of* is output file
	+ before you run it, MAKE SURE you're using the right drive or you'll wipe your whole computer, double check looking at block sizes
	+ maybe also add *status="progress"* so you get feedback as dd does its thing
	+ for example, a full command might be:
	
	`dd if=Downloads/archlinux-2018.03.01-x86_64.iso of=/dev/sdb status="progress"`
	+ when you're sure, press enter and pray, might take a few minutes
	
	
### Booting into Arch [10:18]
6. Reboot computer, on boot press F2, F10, F11, F12 or whatever the boot menu button is and then boot into the USB

7. First thing to do is run `lsblk` again, both your harddrive and the usb should appear. 
	+ Make note of the drive name (sda or whatever it is) that you want to install on
	
8. Now to find out if your computer requires UEFI. If given the choice, recommended that traditional BIOS is chosen, this tutorial will be for traditional BIOS
	+ type in:
	
	`ls /sys/firmware/efi/efivars`
	+ if nothing found, this computer uses a traditional BIOS
	+ if a bunch of files show up, computer probs uses UEFI. find a different tutorial, only differences are in partitioning and installing a boot loader
	
9. Ping a website to see if you have internet connection:
	
	`ping www.google.com.au`
	+ ctrl+c to stop
	+ if you don't have ethernet and need wifi you can run:
	
	`wifi-menu`
	+ but wifi-menu never bloody works so just try to use ethernet
	
10. Make sure the system clock is all good by running:
	
	`timedatectl set-ntp true`

	
### Partitioning Drives [16:04]
11. The hard part. To begin, enter:
	
	`fdisk /dev/sda`
	+ assuming sda is the drive you're installing on, otherwise just replace it with whatever drive
	
12. To print current drive details:
	`p`
	
13. Delete all currently existing partitions by entering:
	`d`
	+ if you have multiple partitions just enter `d` a couple times
	+ you can print `p` again to see that no partitions exist anymore
	
14. To create a new partition, enter:
	`n`
	1. [enter] the default or `p` for primary
	2. press [enter] for default `1`, this will be our __boot__ partition where the grub menu and important installing stuff will be located
	3. just press [enter] for first sector
	4. for last sector the boot menu is usually about 200MB so just enter `+200M`
		+ if it asks you to remove a signature from a previous partition select `Y`es
	5. print `p` again and the first partition should be there, now to create the second partition
	
15. Create a new partition with `n`
	1. select default `p` for primary
	2. press [enter] or type `2` for default, this is the __swap__ partition, which is involved in hibernation etc.
	3. press [enter] for default first sector
	4. for second sector, rule of thumb is generally 150% of your ram, so if you have 8GB or ram you'd input 12GB.
		+ for the laptop i think you can just input `+12G`
	5. print `p` again and there should be two partitions.
	
16. Create the third partition with `n`, this will be the __root__ partition where all the programs are located 
	1. press [enter] for default `p`
	2. press [enter] for default `3`
	3. press [enter] for default first sector
	4. for last sector, safe bet is 25GB but at least 15GB, depending on what you install/delete you could go more or less
		+ for the laptop just go with `+35G`
	5. print `p`, now theres three
	
17. Finally, create the fourth partition, `n`, this is the __home__ partition where all files are located and will take up the remainder of the space
	1. press [enter] for default `p`
	2. press [enter] for default `4`
	3. press [enter] for default first sector
	4. press [enter] for default last sector so it fills up the rest of the space
	5. print `p` finally and there should be all four partitions
		+ it's normal for messages such as "Filesystem/RAID signature on partition 1 will be wiped" to appear on the print screen
	
18. To complete the partitioning process and write the changes, enter:
	
	`w`
	+ this will wipe the computer (duh) so back everything up
	

### Creating Filesystems [25:00]
19. Re-enter 

	`lsblk`
	+ we're going to want to create filesystems for the boot, root and home partitions (sda1, sdab3 & sda4), not swap, as these partitions will contain files

20. To make the filesystem for the boot partitions, enter:
	
	`mkfs.ext4 /dev/sda1`
	+ or replace sda1 with whatever the boot partition is
	
21. For the root partition, enter:
	
	`mkfs.ext4 /dev/sda3`
	+ this will take a little longer because its bigger
	
22. For the home partition, enter:
	
	`mkfs.ext4 /dev/sda4`
	+ this will take the longest amount of time, but shouldnt be too long
	
23. To set up the swap partition, enter:
	
	`mkswap /dev/sda2`
	and then enter:
	
	`swapon /dev/sda2`
	

### Mounting Partitions [27:36]
24. First we mount the root partition:
	
	`mount /dev/sda3 /mnt`
	+ traditionally root is mounted to '/mnt'
	+ obviously replace sda3 with your root partition
	+ entering `ls /mnt` should return a 'lost+found' folder
	
25. Now to make directories to mount the other partitions:
	
	`mkdir /mnt/home`
	`mkdir /mnt/boot`
	+ type `ls /mnt` again and there should be two new folders, 'boot' and 'home'
	
26. To mount the boot partition to the new 'boot' folder, enter:
	
	`mount /dev/sda1 /mnt/boot`
	
27. To mount the home partition to the new 'home' folder, enter:
	
	`mount /dev/sda4 /mnt/home`
	+ type `lsblk` for the final time and all four partitions should now have appropriate mountpoints
	
	
### Installing Arch Linux [30:28]
28. To finally install Arch, enter:
	
	`pacstrap /mnt base base-devel`
	+ pacstrap is a magic command to install Arch
	+ we tell it to install Arch at '/mnt'
	+ the packages we want it to install are 'base', 'base-devel' or any other programs you want
	+ i'll include a big list of my programs somewhere
	+ this might take a while
	

### Making an FSTAB File [33:14]
29. Enter:
	
	`genfstab -U /mnt >> /mnt/etc/fstab`
	+ you can view this file with `vim /mnt/etc/fstab`
	+ keep in mind, at this point we're still working off the usb

30. Delete any entries that might not be neccessary
	+ e.g. if you're using sda and theres an sda1 entry just remove it
	
	
### Finalise Installation [37:23]
31. To enter the Arch installation and leave the usb drive, enter:
	
	`arch-chroot /mnt`
	+ typing `ls` should show a whole bunch of directories like 'bin', 'lib', 'usr', 'var' etc.
	
32. To be able to connect to the internet, install a network manager and enable it on boot:
	
	`pacman -S networkmanager`
	`systemctl enable NetworkManager`
	+ make sure the N and M are capitalised for the systemctl command
	
33. Install a boot loader, activate GRUB and generate a GRUB config:
	
	`pacman -S grub`
	`grub-install --target=i386-pc /dev/sda`
	+ replace 'sda' with whatever your system is
	+ dont write sda1 or sda2, just sda
	
	`grub-mkconfig -o /boot/grub/grub.cfg`
	
34. Set a password:
	
	`passwd`
	+ you'll be prompted to type in a password
	
35. Generate a locale:
	
	`vim /etc/locale.gen`
	+ find your locale (en_AU or whatever it is) and uncomment the two lines with it
	+ save and exit the file
	
	`locale-gen`
	+ this will generate the locale
	
36. Set locale:
	
	`vim /etc/locale.conf`
	+ this will be a new file
	+ enter `LANG=en_AU.UTF8`
	+ save and exit the file
	
37. Set a timezone:
	
	`ln -sf /usr/share/zoneinfo/[COUNTRY]/[LOCATION] /etc/localtime`
	+ tab through the options until you find Australia and then Melbourne
	
38. Set a hostname:
	
	`vim /etc/hostname`
	+ should be a new file
	+ type computer name in, e.g. `ArchJefe`
	+ save and exit the file
	
39. Exit the install and go back to the USB:
	
	`exit`
	
40. Unmount everything for safety's sake:
	
	`umount -R /mnt`
	+ umount, NOT unmount
	
41. Reboot the computer and remove the USB:
	
	`reboot`
	
42. The computer should boot into a terminal as a fresh Arch install. Now go do whatever.

# Part 2

### Users and Groups [2:00]
1. Add a user ('sam') and give user a password:
	
	`useradd -m -g wheel sam`
	`passwd sam`
	+ if a mistake is made, check man files for 'useradd', 'userdel', 'groupadd' or 'groupdel'
	
2. Give user sudo access:
	
	`vim /etc/sudoers`
	+ uncomment the line reading:
	
	`%wheel ALL=(ALL) NOPASSWD: ALL`
	+ should be located below the comment that says 'Same thing without a password'

### Xorg and i3 [09:23]
3. Install an xorg server:
	
	`pacman -S xorg-server xorg-xinit`
	+ X can be started by running `xinit` or `startx`
	+ this will read ~/.xinitrc
	
4. Install i3-gaps, i3-status, any terminal and dmenu/rofi:
	
	`pacman -S i3-gaps i3-status rxvt-unicode dmenu`
	
5. Install a network manager and fonts:
	
	`pacman -S nm-applet`
	`pacman -S noto-fonts`
	+ if you install firefox it'll install all the fonts it needs anyway
	+ if there are problems with fonts, set fonts manually in '~./config/fontconfig/fonts.conf'
	
6. Set the X server to start i3:
	
	`vim ~/.xinitrc`
	+ type in `exec i3`
	+ for other DEs or WMs, look up on the Arch Wiki or the man files for what command to replace i3 with
	+ use `startx` to start the X server
	+ if the X server doesn't start, try installing 'xf86-video-intel' or check the Arch Wiki
	
### SystemD and Customisation [22:22]
7. To start a service/program at startup:
	
	`sudo systemctl enable [SERVICENAME]`
	+ or `sudo systemctl start [SERVICENAME]` to start it right now
	
8. To customise user startup and settings:
	+ check files like ~/.profile or ~/.bash_profile
	+ these will run on login
