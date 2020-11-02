## Installing Home Assistant using Proxmox

This guide will help you to install Home Assistant, on almost any x86/64 machine type you choose using Proxmox as the operating system. This guide has been tested on machines including a Dell Optiplex SFF 990 and Dell Optiplex USFF 780. 

This installation uses an offical image provided by the Home Assistant team and is considered a supported installation method. This method of installation is considered medium difficulty and some knowledge of how to use and interact with Linux is required.

*What is Home Assistant?*

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to Step 1. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the document  *Backing up and Restoring your configuration* located  [HERE](https://github.com/Kanga-Who/home-assistant/blob/53ac6a3e77e3654a4f5835bde7cef91493cc08a0/Backup%20and%20restore%20your%20config.md)

## Section 1 – Install Proxmox

**1.1)** Download Proxmox VE 6.2 ISO Installer from [HERE](https://www.proxmox.com/en/downloads/category/iso-images-pve)

**1.2)** You will now need to make a bootable USB drive using balenaEtcher, available [HERE](https://www.balena.io/etcher/). Use a USB drive of at least 8gb. Insert the blank USB drive into your PC, open Etcher, select the Proxmox image you have just downloaded, select your USB drive, then click Flash.

**1.3)** Insert the USB you have just made into the new machine, connect a monitor, Ethernet cable, keyboard, mouse, and power on the machine. If you have any extra hardware, like a Zigbee or Z-Wave stick, now is also a good time to plug them in to the machine. You will need to select the USB drive as the boot device, to do this, you will need to press something like F12 or DEL on your keyboard immediately when the machine is powered on. 

**1.4)** When you see the first screen, select **Install Proxmox VE**, press Enter. The installer will perform some automated tasks for 1-2 mins.

**1.5)** Next on the **EULA** screen, select, I Agree.

**1.6)** Next on the **Proxmox Virtualization Environment (PVE)** screen, select the drive you wish to use from the box at the bottom of the screen, then click Next.

**1.7)** Next on the **Location and Time Zone** selection, Type your country, then select your time zone and change the keyboard layout if needed, then click Next

**1.8)** Next on the **Administration password and E-mail address** screen, choose a password, confirm your password and enter a valid email address.

**1.9)** Next on the **Management network configuration** screen.

- **Management interface** should already be populated with the Ethernet controller of your machine, if not, select the Ethernet controller
- **Hostname (FQDN)** - Type a hostname in this box, you could use something like, `proxmox.local`, `hass.info`, or `haserver.ddns`.
- **IP Address** - you can choose an IP for your machine, if you have a specific IP you wish to use on your network, enter this now
- **Netmask** - should auto populate and be something like `255.255.255.0` depending on your network configuration.
- **Gateway** - this is (normally) the IP of your router, this should auto populate with the correct info, if it does not, enter the IP of your router
- **DNS server** - you can leave this at the default on your network (normally the same IP as your router), or input one of your choosing like a Google DNS server` 8.8.8.8 or` a Cloudfare DNS server like `1.1.1.1`.

**1.10)** Next on the **Summary** screen, confirm all the details are correct, then click Install. This process can take anywhere from 2 -20min depending on your machine.

Once the installation is complete, take note of the IP information on screen, remove the USB drive, and click Reboot. While the reboot is taking place, you can now unplug the monitor, keyboard and mouse from your machine as they are no longer needed.

After 1-2 minutes, you should be able to access Proxmox at `https://MACHINE_IP:8006`. If you see a message like Warning: Potential Security Risk Ahead, you can safely ignore this, accept the risk and continue.


## Section 2 - Configure and Update Proxmox

**2.1)** Before configuring anything in the Proxmox interface, you will start by updating the Proxmox OS to make sure all the latest updates and security patches are installed. To do this you will use Putty available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to connect via SSH and copy and paste some commands. To connect to Proxmox via Putty, you will need the IP of the machine from Step 1.10, the username `root` and password you created from Step 1.8.

Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of the Proxmox machine, then select OPEN. You will now be prompted to enter the username `root` (login as:) and your password. 

**2.2)** The first thing you should do is add a user to the sudo group so you don't need to login with root. To do this, copy and paste this command into the Putty window to install sudo.
```
apt update
apt install sudo
```
Once this has completed, create a new user
```
adduser YOUR_USER_NAME
```
Choose and confirm a password, then complete the following.
```
Changing the user information for username
Enter the new value, or press ENTER for the default
    Full Name []: YOUR NAME
    Room Number []: LEAVE BLANK
    Work Phone []: LEAVE BLANK
    Home Phone []: LEAVE BLANK
    Other []: LEAVE BLANK
```
You can now add the user the sudo group with this command.
```
usermod -aG sudo YOUR_USER_NAME
```
To test this has worked, log out of Putty by typing `exit` and press enter. Start a new Putty connection and use the new username and password you have just created. Now that you have logged in with the new user, you will update Proxmox before installing Home Assistant. Firstly, you will need to edit the apt sources so you get the correct updates.

**2.3)** Copy and paste this command into Putty and press enter
```
sudo nano /etc/apt/sources.list
```
Press and hold Control button and K button together on your keyboard to remove all the text you can see (Control+K)

When the screen is blank, copy and paste in the following information.
```
#
deb http://ftp.debian.org/debian buster main contrib
deb http://ftp.debian.org/debian buster-updates main contrib

# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve buster pve-no-subscription

# security updates
deb http://security.debian.org/debian-security buster/updates main contrib
#
```
Then press `Control+X`, then `Y` for Yes, then press Enter.

Copy and paste this command into Putty and press enter.
```
sudo nano /etc/apt/sources.list.d/pve-enterprise.list
```
Press and hold `Control+K` to remove all the text you can see, once all text is removed, press `Control+X`, then `Y` for Yes, then press Enter.

You can now run the following update command and should not get any errors. The update could take 1-20mins, when finished, you can move on.
```
sudo apt update && sudo apt dist-upgrade -y && sudo apt install qemu-guest-agent -y && sudo apt autoremove --purge -y
```
Now that the OS is up to date, you can move onto to installing Home Assistant using Proxmox.

## Section 3 - Installing Home Assistant

Installing Home Assistant in Proxmox has been made very simple with an excellent script created by **Whiskerz007**. Information about the script can be found [HERE](https://github.com/whiskerz007/proxmox_hassos_install). Credit to Whiskerz007 for making this process so simple.

**3.1)** To run the install script, copy and paste the following command into the Putty window you have open. This will download an official image from the Home Assistant website and configure it in Proxmox for you. This will take 2-20mins depending on your internet connection and machine.

```
sudo bash -c "$(wget -qLO - https://github.com/whiskerz007/proxmox_hassos_install/raw/master/install.sh)"
```

Once this has finished, you will see `[INFO] Completed Successfully! New VM ID is 100`. When you can see this message in Putty, you can move over the Proxmox page to configure the VM.

**3.2)** In your web browser, head to the Proxmox web interface at `https://MACHINE_IP:8006` and login using the username `root` and the password you created during Step 1.8. You will get a message saying "You do not have a valid subscription for this server.", you can safely ignore this and click OK.

On the left hand side, you should see a new entry under **Datacentre --- Your_Machine_Name** called `100 (hassosova-4.15)` or similar. This is the Home Assistant VM created by the script. It is currently not running and you should now make some changes to how the VM will operate.

**3.3)** Click on the VM named `100 (hassosova-4.15)`. You should now see a menu listing Summary, Console, Hardware, Cloud-init etc. Click on **Hardware**. The key things you will want to change are **Memory, Processors and Hard Disk**. 

**3.4)** Click on **Memory**, then click on **Edit** in the bar just above. The default value will be `512`. Depending on how much Memory you have in your machine, you can increase this value to `2048` (2gb) or `4096` (4gb), and then click OK. Home Assistant happily runs with 2gb of memory. 

**3.5)** Click on **Processors**, then click on **Edit** in the bar just above. The default values will be Sockets 1 and Cores 1. Leave Sockets at 1. Depending on your CPU type (dual core, quad core, etc) change the value of Cores to 2, or 4, then click OK. You can also leave this value at 1 which will only use 1 CPU Core.

**3.6)** Click on **Hard Disk**, then click on **Resize Disk** in the bar just above. The drive is already 6gb, so you can add a value to increase the size of the disk. A good value to use is 26 as this will make the drive size 32gb which is more than enough for Home Assistant. Enter a value, then click Resize Disk.

**3.7)** If you have a Zigbee or Z-wave stick connected to the machine that you wish to use with Home Assistant, you can configure these now by clicking on **USB Device** then click on **Edit** in the bar just above. You can now choose the USB Zigbee or Z-wave device from the dropdown list, then click OK. 

**3.8)** Now move to **Options** tab in the list, 2 places below your current position of **Hardware**. Now double click on **Boot Order** and select your internal drive (SSD or HDD), such as 'sata0' from the list and make sure the check box next to it is checked/enabled and it is in position 1 (first boot device), then click OK.

You can now start the Home Assistant VM for the first time so it can run the install. To do this, click **Start** on the top right corner of the screen.

**3.9)** The Home Assistant VM will be assigned a different IP to Proxmox. To find the IP of the Home Assistant install, click on **Summary** from the menu list, and you should now see a box that shows information such as Status, HA State, CPU and Memory info. The IP listed here is the one needed to access Home Assistant. 

You can now enter this IP and port 8123 (eg. http://192.168.1.150:8123) in your web browser and check the status of the Home Assistant installation.

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document *Backing up and Restoring your configuration.*

That’s it, you have now installed Home Assistant on your machine using Proxmox and have SSH access to your machine using Putty to keep it up to date. It is recommended that you log into the Proxmox machine using Putty at least once a month and use the following command to download security patches and keep the OS up to date.

```
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove –y
```

Along with this guide, there is also associated documents available. These are essentially guides I use myself.

- [Install Samba, Portainer and MQTT on Ubuntu or Debian](https://github.com/Kanga-Who/home-assistant/blob/53ac6a3e77e3654a4f5835bde7cef91493cc08a0/Install%20Samba%2C%20Portainer%20and%20MQTT.md)
- [Backing up and Restoring your configuration](https://github.com/Kanga-Who/home-assistant/blob/53ac6a3e77e3654a4f5835bde7cef91493cc08a0/Backup%20and%20restore%20your%20config.md)

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements.
