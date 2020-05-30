## Installing Home Assistant Supervised on Ubuntu

This guide will help you to install Home Assistant Supervised, on almost any machine type you choose. This guide has been tested on a number of machines including, Intel NUC J5005, Dell Optiplex SFF 990 and Dell Optiplex USFF 780. 

:warning: Please keep in mind that currently **this installation method is not officially supported** by the Home Assistant team, and therefore you are responsible for updating and managing updates and security on the base OS and no offical support will be offered. This install method may cease to work at any time, so use at your own risk.

In this guide, you will be using Ubuntu Server 18.04.04 as the operating system. This type of installation is what is called “headless” and after the installation is complete, you will not need to have a keyboard, mouse or monitor attached (although you can if you prefer). You will manage and update the machine via terminal commands.

*What is Home Assistant Supervised?*

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to Step 1. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the document  *Backing up and Restoring your configuration* located  [HERE](https://github.com/Kanga-Who/home-assistant/blob/master/Backup%20and%20restore%20your%20config.md)

## Section 1 – Install Ubuntu Server

**1.1)** Start by downloading Ubuntu Server 18.04.04 from [HERE](https://ubuntu.com/download/alternative-downloads). This is a torrent file, so use your favourite torrent program.

**1.2)** While Ubuntu is downloading, you will need some other programs to help with the setup and installation. To burn the Ubuntu ISO image to a USB thumb drive, you will use a program called Rufus which can be downloaded from [HERE](https://rufus.ie/). You will also use a piece of software called PuTTY, available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). 

Putty is a free and open-source terminal emulator, serial console and network file transfer application. You will use Putty to execute commands on the Ubuntu machine from your Windows PC. (Use Terminal on a Mac).

**1.3)** You will now create a bootable USB drive using Rufus and the Ubuntu image you have downloaded. Insert a blank USB drive of at least 8gb into your PC, open Rufus and choose your USB from the drop-down menu. Now select the Ubuntu ISO image you downloaded, and click Start. If you get any prompts, select OK or Yes to continue.

**1.4)** Insert the USB you have just made into the new machine, connect a monitor, Ethernet cable, keyboard and mouse, and power on the machine. You will need to select the USB drive as the boot device, to do this, you will need to press something like F12 or DEL on your keyboard immediately when the machine is powered on.

**1.5)** The first screen you should be able to select from is the **Welcome** screen where you will select your language.

**1.6)** Next will be **Keyboard Configuration**. If you are using something other than English US, use the arrow keys on your keyboard to arrow up and select the correct type. When the correct selection is made, select DONE.

**1.7)** Next will be **Network Connections**. Make sure you can see an IP listed. Depending on your network configuration, it will show something like `DHCPv4 192.168.1.150/24`. The info you need to make a note of here is the IP as you will use this to connect to the machine later, in this case, 192.168.1.150.

**1.8)** Next will be **Configure Proxy**. Skip this screen by selecting DONE, we do not need to enter anything.

**1.9)** Next will be **Configure Ubuntu Archive Mirror**. Skip this screen by selecting DONE, we do not need to enter anything.

**1.10)** Next will be **Installer Update**. We do not necessarily need to update the installer, so select CONTINUE WITHOUT UPDATING.

**1.11)** Next will be **Filesystem Setup**. Select USE AN ENTIRE DISK and then on the next screen select the disk you wish to use. Then on the next screen, select DONE and then CONTINUE.

**1.12)** Next will be **Profile Setup**. Enter your name, choose a name for your server (i.e. ubuntu-server) and enter a password. Make note of the username and password you choose here, this is what you will use to connect to the machine later.

**1.13)** Next will be **SSH Setup**. You will press SPACEBAR to place an X in the box next to INSTALL OPEN SSH SERVER, then arrow down to DONE.

**1.14)** Next will be **Featured Server Snaps**. We do not need to select anything on this screen, arrow down to DONE. 

The installation will now continue automatically. When it has completed (5-15mins), you will see REBOOT at the bottom of the screen. Before rebooting, remove your USB drive, then press enter to reboot. While rebooting, you can also remove the keyboard, mouse and monitor as you will no longer need them.

## Section 2 – Install Home Assistant Supervised

Now that you have Ubuntu installed, you can move on to installing Home Assistant Supervised.

**2.1)** First you will start by updating Ubuntu to make sure all the latest updates and security patches are installed. To do this you will use Putty to connect via SSH and copy and paste some commands. To connect to the Ubuntu machine via Putty, you will need the IP of the machine from Step 1.7, and the username and password you created from Step 1.12.

Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of the Ubuntu machine, then select OPEN. You will now be prompted to enter your username (login as:) and password. Now that you have logged in, copy the following command and paste into Putty window by right clicking your mouse button. You may be asked to re-enter your password.
```
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y
```
Depending on the speed of your internet connection, this could take anywhere from 2 to 20 minutes to complete. When finished, you will see the prompt.

**2.2)** Now the operating system is up to date, you can install Home Assistant Supervised. Copy each line of the below commands one at a time and paste them into the Putty window, and press ENTER. One of the following commands will execute a shell script as root, and some people may be concerned with the security risk. If you would like to read the script for piece of mind, click [HERE](https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh)
```
sudo -i

apt-get install -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat

systemctl disable ModemManager

systemctl stop ModemManager

curl -fsSL get.docker.com | sh

curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | bash -s
```

**2.3)** On a PC or NUC the installation time is generally under 5 mins, however it can take longer so be patient. You can check the progress of Home Assistant setup by connecting to the IP address of your machine in Chrome/Firefox on port 8123. (e.g. http://192.168.1.150:8123) 

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document *Backing up and Restoring your configuration.*

That’s it, you have now installed Home Assistant Supervised on Ubuntu server and have SSH access to your machine to keep it up to date. It is recommended that you log into your machine using Putty at least once a month and use the following command to download security patches and keep the OS up to date.
```
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove –y
```
Along with this guide, there is also associated documents available. These are essentially guides I use myself.

- [Install Samba, Portainer and MQTT on Ubuntu or Debian](https://github.com/Kanga-Who/home-assistant/blob/master/Install%20Samba%2C%20Portainer%20and%20MQTT.md)
- [Backing up and Restoring your configuration](https://github.com/Kanga-Who/home-assistant/blob/master/Backup%20and%20restore%20your%20config.md)

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements.

Thank you to contributors, [nickrout](https://community.home-assistant.io/u/nickrout/), [finity](https://community.home-assistant.io/u/finity) and [flamingm0e](https://community.home-assistant.io/u/flamingm0e)
