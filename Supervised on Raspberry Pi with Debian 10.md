## Installing Home Assistant Supervised on a Raspberry Pi with Debian 10

This guide will help you to install Home Assistant Supervised, on a Raspberry Pi with Debian 10. This guide has been tested on a Raspberry Pi 4 4gb model, with USB3 SSD as the boot drive. This installation takes approx 45 mins to complete, but may be faster/slower depending on the boot drive you use and your internet speed. I competed the install in under 20 mins with the above hardware.

:warning: Using Debian 10 and following a strict set of guidelines available [HERE](https://github.com/home-assistant/architecture/blob/6da4482d171f2ef04de9320d313526653b5818b4/adr/0014-home-assistant-supervised.md) will give you an[u] officially supported[/u] installation of Home Assistant Supervised. If you choose at anytime to install additional software to the Debian operating system, your installation will become officially unsupported. Community support via the forums is always available however.

While every effort has been made to ensure this guide complies with ADR-0014, no guarantee can be made it does now, or in the future.

In this guide, you will be using Debian 10 as the operating system. This type of installation is what is called “headless” and after the installation is complete, you will not need to have a keyboard, mouse or monitor attached (although you can if you prefer).

*What is Home Assistant Supervised?*

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to **Section 1**. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the document  *Backing up and Restoring your configuration* located  [HERE](https://github.com/Kanga-Who/home-assistant/blob/9f437fb0043daaa6ed450ed0eec7da479cb1ff93/Backup%20and%20restore%20your%20config.md)


## Section 1 – Install Debian

**1.1)** Start by downloading the correct `xz-compressed image` for your Pi from [HERE](https://raspi.debian.net/tested-images/). For a Pi 4, you will need the image listed as **4** under **Family**

**1.2)** While Debian is downloading, you will need to download some software to burn the Debian` xz-compressed image` to your SD Card / USB SSD. You will use a program called **balenaEtcher**, available [HERE](https://www.balena.io/etcher/). Once the Debian image has downloaded, insert your SD Card / USB SSD into your PC and launch Etcher.

Click **Select Image** and navigate to the location you saved the Debian `xz-compressed image`, Click **Select Target** and then choose your SD card / USB SSD, and then click **Flash**. Depending on the speed of your card / drive this process can take between 1 and 20 minutes to complete.

If you do not want to use, or do not have a Keyboard, Mouse and Monitor to connect to the Pi during the setup process, you can skip to **Section 2** where you will edit a config file to allow you to remote connect to the Pi from first boot using you PC. Otherwise, continue to the next **Step 1.3**

**1.3)** Once the image has been written to the SD card / USB SSD, you can safely remove the SD card / USB SSD and plug it into your Pi. Before powering on the Pi, you will need to connect a Network Cable, HDMI cable, Monitor and a keyboard. Once you have done this, you can connect the power cable to your Pi. The initial boot will take a few minutes to complete. When the Pi is ready to use, you will see a screen that looks like this (or similar).
```
Debian GNU/Linux 10 rpi4-20201112 tty1
rpi4-20201112 login:
```

When you see this, you can now login using the default username of **root**.

**1.4)** First, you will make sure the OS is up to date by entering the following commands one at a time.
```
apt update && apt upgrade -y
apt install sudo -y
```

**1.5)** You will now add a username and make that user part of the sudo group. To do this, run the following commands

```
adduser YOUR_USERNAME
```
You will now be asked to enter a password twice (make note of this for later). You will then be asked to enter your first name, last name, phone number etc. You can skip through all this by pressing *Enter*. Now you have added your user, you will need to make it part of the `sudo` group by running the following command.

```
usermod -aG sudo YOUR_USERNAME
```
You will now be able to connect to the Pi via SSH using the username and password you have just created to copy and paste the commands needed to install Home Assistant Supervised. Check your router for the IP address of your Pi, or run the following command in the Terminal and look for the entry `inet`. You don't need the `/24` or `/16` on the end, just the IP which will look like `192.168.1.150`, or `10.1.1.15`

```
ip addr show eth0
``` 

To connect to your Pi via SSH you will use a piece of software called **PuTTY** (use Terminal on a Mac), available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). Putty is a free and open-source terminal emulator, serial console and network file transfer application. 

You can now unplug the Monitor, HDMI cable and keyboard as these are no longer needed, or leave them connected if you wish.

**1.6)** Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of your Pi, then select OPEN. You will now be prompted to enter your username and password. This will be the username and password you just setup in step 1.5.

## Section 2 – Enable SSH access from first boot

In this section, you will edit the `sysconf.txt` to enable SSH access to your Pi from your PC, from the first boot.

**2.1)** Now that your SD card/SSD has been flashed with Debian, you will need to safely remove it from your PC and then reinsert it. You will now be able to see the root of the drive and edit its contents. Open the file named `sysconf.txt` using your favortie text editor, like Notepad++

**2.2)** Find these lines of text
```
# root_pw - Set a password for the root user (by default, it allows
# for a passwordless login)
#root_pw=FooBar
```

You will need to do 2 things, the first is to remove the # from the line `#root_pw=FooBar` and then to change the default password of `FooBar` to something secure that you can remember - make a note of this password. It should now look something like this

```
root_pw=MyStrongPassword!!!
```

You can now save and close the text file.

**2.3)** Once the image has been written to the SD card / USB SSD, you can safely remove the SD card / USB SSD and plug it into your Pi. Before powering on the Pi, you will need to connect a Network Cable, HDMI cable, Monitor and a keyboard. Once you have done this, you can connect the power cable to your Pi. The initial boot will take a few minutes to complete. When the Pi is ready to use, you will see a screen that looks like this (or similar).
```
Debian GNU/Linux 10 rpi4-20201112 tty1
rpi4-20201112 login:
```

When you see this, you can now login using the default username of **root**.

**2.4)** First, you will make sure the OS is up to date by entering the following commands one at a time.
```
apt update && apt upgrade -y
apt install sudo -y
```

**2.5)** You will now add a username and make that user part of the sudo group. To do this, run the following commands

```
adduser YOUR_USERNAME
```
You will now be asked to enter a password twice (make note of this for later). You will then be asked to enter your first name, last name, phone number etc. You can skip through all this by pressing *Enter*. Now you have added your user, you will need to make it part of the `sudo` group by running the following command.

```
usermod -aG sudo YOUR_USERNAME
```
You will now be able to connect to the Pi via SSH using the username and password you have just created to copy and paste the commands needed to install Home Assistant Supervised. Check your router for the IP address of your Pi, or run the following command in the Terminal and look for the entry `inet`. You don't need the `/24` or `/16` on the end, just the IP which will look like `192.168.1.150`, or `10.1.1.15`

```
ip addr show eth0
``` 

To connect to your Pi via SSH you will use a piece of software called **PuTTY** (use Terminal on a Mac), available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). Putty is a free and open-source terminal emulator, serial console and network file transfer application. 

You can now unplug the Monitor, HDMI cable and keyboard as these are no longer needed, or leave them connected if you wish.

**2.6)** Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of your Pi, then select OPEN. You will now be prompted to enter your username and password. This will be the username and password you just setup in step 1.5.


## Section 3 – Install Home Assistant Supervised

With Debian installed, you can move on to installing Home Assistant Supervised.

**3.1)** Copy and paste each line of the below commands into the Putty window one at a time, and press Enter.

```
sudo -i

apt-get install -y software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq network-manager

systemctl disable ModemManager

systemctl stop ModemManager

curl -fsSL get.docker.com | sh

curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | bash -s -- -m raspberrypi4-64
```

If you are using a Raspberry Pi 3, then replace `raspberrypi4-64` with `raspberrypi3` at the end of the last command.


**3.2)** The installation time is generally under 5 mins, however it can take longer so be patient. You can check the progress of Home Assistant setup by connecting to the IP address of your machine in Chrome/Firefox on port 8123. (e.g. http://192.168.1.150:8123) 

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document *Backing up and Restoring your configuration.*

You have completed the installation of Home Assistant Supervised on your Raspberry Pi running Debian. It is recommended that you log into your machine at least once a month and use the following command to download security patches and keep the OS up to date.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove –y
```

You can do this directly on the Pi itself with the Monitor and Keyboard attached, or via Putty.

Along with this guide, there is also associated documents available. These are essentially guides I use myself and do not comply with ADR-0014.

- [Install Samba, Portainer and MQTT on Ubuntu or Debian](https://github.com/Kanga-Who/home-assistant/blob/9f437fb0043daaa6ed450ed0eec7da479cb1ff93/Install%20Samba%2C%20Portainer%20and%20MQTT.md)
- [Backing up and Restoring your configuration](https://github.com/Kanga-Who/home-assistant/blob/9f437fb0043daaa6ed450ed0eec7da479cb1ff93/Backup%20and%20restore%20your%20config.md)

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements, or find an error that needs correcting.

![supported|295x400](upload://8oOlvdFPETnlGhnxDUm7Lj5TcJE.png) 

![Capture|500x235](upload://eXYIYS1B9lKlrZKhSpdUiAta8RY.png)
