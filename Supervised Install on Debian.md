## Installing Home Assistant Supervised on a Raspberry Pi with Debian 11

This guide will help you to install Home Assistant Supervised, on a Raspberry Pi with Debian 11. This guide has been tested on a Raspberry Pi 4 4gb model, with USB3 SSD as the boot drive. This installation takes approx 30 mins to complete, but may be faster/slower depending on the boot drive you use and your internet speed. I completed the install in under 20 mins with the above hardware.

:warning: Using Debian 11 and following a strict set of guidelines available [HERE](https://github.com/home-assistant/architecture/blob/6da4482d171f2ef04de9320d313526653b5818b4/adr/0014-home-assistant-supervised.md) will give you an[u] officially supported[/u] installation of Home Assistant Supervised. If you choose at anytime to install additional software to the Debian operating system, your installation will become officially unsupported. Community support via the forums is always available however.

While every effort has been made to ensure this guide complies with ADR-0014, no guarantee can be made it does now, or in the future.

In this guide, you will be using Debian 11 as the operating system. This type of installation is what is called “headless” and after the installation is complete, you will not need to have a keyboard, mouse or monitor attached (although you can if you prefer).

*What is Home Assistant Supervised?*

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to **Section 1**. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the document  *Backing up and Restoring your configuration* located  [HERE](https://github.com/Kanga-Who/home-assistant/blob/9f437fb0043daaa6ed450ed0eec7da479cb1ff93/Backup%20and%20restore%20your%20config.md)


## Section 1 – Install Debian 11

**1.1)** Start by downloading the correct `xz-compressed image` for your Pi from [HERE](https://raspi.debian.net/tested-images/). For a Pi 4, you will need the image listed as **4** under **Family**

**1.2)** While Debian is downloading, you will need to download some software to burn the Debian` xz-compressed image` to your SD Card / USB SSD. You will use a program called **balenaEtcher**, available [HERE](https://www.balena.io/etcher/). Once the Debian image has downloaded, insert your SD Card / USB SSD into your PC and launch Etcher.

Click **Select Image** and navigate to the location you saved the Debian `xz-compressed image`, Click **Select Target** and then choose your SD card / USB SSD, and then click **Flash**. Depending on the speed of your card / drive this process can take between 1 and 20 minutes to complete.


**1.3)** Once the image has been written to the SD card / USB SSD, you can safely remove the SD card / USB SSD and plug it into your Pi. Before powering on the Pi, you will need to connect a Network Cable, HDMI cable, Monitor and a keyboard. Once you have done this, you can connect the power cable to your Pi. The initial boot will take a few minutes to complete. When the Pi is ready to use, you will see a screen that looks like this (or similar).
```
Debian GNU/Linux 11 rpi4-20210823 tty1
rpi4-20210823 login:
```

When you see this, you can now login using the default username of **root**.

**1.4)** First, you will make sure the OS is up to date by entering the following commands one at a time. 
```
apt update && apt upgrade -y
apt install sudo -y
```

**1.5)** You will now add a username and make that user part of the sudo group. To do this, run the following command

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
exit
``` 

You will now unplug the monitor and keyboard from the Pi as these will no longer be used. You will continue the installation by connecting to your Pi via SSH using a piece of software called **PuTTY** (use Terminal on a Mac), available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). Putty is a free and open-source terminal emulator, serial console and network file transfer application. 

**1.6)** Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of your Pi, then select OPEN. You will now be prompted to enter your username and password. This will be the username and password you just setup in step 1.5.

## Section 2 – Install Home Assistant Supervised

With Debian installed, you can move on to installing Home Assistant Supervised.

**2.1)** Copy and paste each line of the below commands into the Putty window one at a time, and press Enter. You may be prompted to approve changes during the installation, if so choose Y (yes) to continue.

```
sudo -i

apt-get install -y software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq network-manager

systemctl disable ModemManager

systemctl stop ModemManager

curl -fsSL get.docker.com | sh

curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | bash -s -- -m raspberrypi4-64
```

If you are using a Raspberry Pi 3, then replace `raspberrypi4-64` with `raspberrypi3` at the end of the last command.


**2.2)** The installation time is generally under 5 mins, however it can take longer so be patient. You can check the progress of Home Assistant setup by connecting to the IP address of your machine in Chrome/Firefox on port 8123. (e.g. http://192.168.1.150:8123) 

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. 

If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to Home Assistant website on backing up and restoring your configuration, located [HERE](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui)

## Section 3 - Install OS Agent

This is the OS Agent for Home Assistant. It is used for Home Assistant OS and Home Assistant Supervised installation types and it allows the Home Assistant Supervisor to communicate with the host operating system.

**3.1)** Connect to your machine via SSH using Putty, then run the following commands. 

```
sudo apt --fix-broken install
sudo apt-get install udisks2 wget
cd /usr/local/src
```

**3.2)** Visit the OS Agent page and then replace the version number with the latest available, into the commands below. *(i.e. replace all references to 1.1.1 with the latest available)*
https://github.com/home-assistant/os-agent/releases/latest

```
sudo wget https://github.com/home-assistant/os-agent/releases/download/1.1.1/os-agent_1.1.1_linux_aarch64.deb
dpkg -i os-agent_1.1.1_linux_aarch64.deb
sudo reboot
```
You have completed the installation of Home Assistant Supervised on your Raspberry Pi running Debian. It is recommended that you log into your machine at least once a month and use the following command to download security patches and keep the OS up to date.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove –y
```

You can do this directly on the Pi itself with the Monitor and Keyboard attached, or via Putty.

## Section 4 - Unhealthy Installation
<details>
  <summary> If you are faced with the HA Supervisor showing you the 'Unhealthy Installation' error, click here to expand and follow this procedure to fix it.</summary>

**4.1)** Install the **SSH & Web Terminal** add-on from with the HA Supervisor add-on store. It looks like this. 
![ssh|331x90](upload://94WdjeVWRIQ3mX4iSkjXKrAFfed.png)

Configure the add-on so you can connect to the HA container. Here is an example of a simple working configuration you can use, adjust the `username` and `password` to suit.

```
ssh:
  username: USERNAME
  password: PASSWORD
  authorized_keys: []
  sftp: false
  compatibility_mode: false
  allow_agent_forwarding: false
  allow_remote_port_forwarding: false
  allow_tcp_forwarding: false
zsh: true
share_sessions: false
packages: []
init_commands: []
``` 
You will need to change the port to 23 (or other unused port number of your choosing) in the Network section of the Configuration tab. Once you have installed and configured the add-on, move on to the next step.

**4.2)** Using Putty, login to the HA machine using the IP of the machine and port 23. Use the username and password you configured in the previous step.

**4.3)** Once logged in you can now execute the following command;
```
ha jobs options --ignore-conditions healthy
```
Once you have done this, you should see a message saying, *Command completed successfully*. You can type `exit` to leave the shell connection. You can now also turn off/stop the SSH & Web Terminal add-on in HA as you will no longer need it. It can be restarted at anytime.

![Capture|593x337](upload://9to6dfTx05R9O7d1G0uK4gbDail.png)
</details>

___

Thank you to @Tamsy for input and additional information. I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements, or find an error that needs correcting.
