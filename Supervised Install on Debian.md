## Installing Home Assistant Supervised on Debian 11

This guide will help you to install Home Assistant Supervised, on almost any machine type you choose. This guide has been tested on machines including a Lenovo m72e, Dell Optiplex SFF 990, Dell Optiplex USFF 780 and a HP T520 thin client.

:warning: Using Debian 11 and following a strict set of guidelines available [HERE](https://github.com/home-assistant/architecture/blob/master/adr/0014-home-assistant-supervised.md) will give you a supported installation of Home Assistant Supervised. If you choose at anytime to install additional software to the Debian operating system, your installation will become officially unsupported. Community support via the forums is always available however.

While every effort has been made to ensure this guide complies with [ADR-0014](https://github.com/home-assistant/architecture/blob/master/adr/0014-home-assistant-supervised.md), no guarantee can be made it does now, or in the future.

In this guide, you will be using Debian 11 as the operating system. This type of installation is what is called “headless” and after the installation is complete, you will not need to have a keyboard, mouse or monitor attached, although you can if you prefer.

#### What is Home Assistant Supervised? ####

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to Section 1 if you need assistance with installing Debian 11. If you already have Debian 11 installed and wish to move on to installing Home Assistant, move on to Section 2.

## Section 1 – Install Debian

<details>
  <summary>If you would like a step by step guide on how to install Debian 11 to your machine, click here to expand for instructions.</summary>


**1.1)** Start by downloading `debian-live-11.0.0-amd64-standard.iso` from [HERE](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/). If you would prefer the full Debain image with all drivers, download `firmware-11.0.0-amd64-DVD-1.iso` [HERE](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/11.0.0+nonfree/amd64/iso-dvd/firmware-11.0.0-amd64-DVD-1.iso)

**1.2)** While Debian is downloading, you will need some other programs to help with the setup and installation. To burn the Debian ISO image to a USB thumb drive, you will use a program called Rufus which can be downloaded from [HERE](https://rufus.ie/). 

**1.3)** You will now create a bootable USB drive using Rufus and the Debian image you have downloaded. Insert a blank USB drive of at least 8gb into your PC, open Rufus and choose your USB from the drop-down menu. Now select the Debian ISO image you downloaded, and click Start. If you get any prompts, select OK or Yes to continue. When this has completed, you can move on.

**1.4)** Insert the USB you have just made into the new machine, connect a monitor, Ethernet cable, keyboard and mouse, and power on the machine. You will need to select the USB drive as the boot device, to do this, you will need to press something like F12 or DEL on your keyboard immediately when the machine is powered on.

**1.5)**	The first screen you should be able to select from is **Main Menu**, on this screen, select **Graphical Debian Installer**

**1.6)**	Next will be **Language**. Choose your language and click continue.

**1.7)**	Next will be **Select your location**. Choose your country and click continue.

**1.8)**	Next will be **Configure the keyboard**. Select your keyboard type and click continue. The installer will now perform some automated tasks which will take 1-2 minutes.

**1.9)**	Next will be **Configure the network**. Here you can name your machine, the default name will be `debian`. Choose a name and click continue. You can skip the next page by clicking continue as you do not need to set a domain name. 

**1.10)**	Next will be **Set up users and passwords**. You will be asked to create a password for the root user. Make a note of the password you choose here, and click continue.

**1.11)**	Next will be **Set up users and passwords** again. Enter a username, click continue and on the next screen, enter a password for this user account. Make note of both of these, you will need them later.

**1.12)**	Next will be **Configure the clock**. Select the correct time zone and click continue.

**1.13)**	Next will be **Partition Disks**. Select **Guided - use entire disk** and then click continue. On the next screen make sure the correct disk is selected and click continue. On the next screen select **All files in one partition** and click continue. On the next screen, make sure **Finish partitioning and write changes to disk** is selected, and click continue. On the next screen, select **Yes** and then click continue. The installer will now perform some automated tasks. This will take 1-2 mins.

**1.14)**	Next will be **Configure the package manager**. Select **Yes** and click continue. Select your Country and click continue. You can leave the default selection **deb.debian.org** selected, or select another mirror of your choosing, and click continue. Leave the next page blank and click continue. The installer will now perform some automated tasks. This will take a few minutes.

**1.15)**	Next will be **Install the GRUB bootloader**. Select **Yes** and click continue. Now select the drive you are installing Debian on, and click continue. The installer will now perform some automated tasks. This will take 1-2 mins and then installation will be complete.

**1.16)** In Debian, your user will not be a member of the sudo group so cannot run administrative commands. After the system has rebooted, log in as the root user and the password you set during **Step 1.10.** To add your user to the sudo group enter this command, and press Enter. 

```
usermod -aG sudo username
```

where *username* is the one you setup during **Step 1.11**

**1.17)**	Log out of the root account by pressing ctrl-d on your keyboard then to login to the machine using the username and password you created in **Step 1.11**.

**1.18)**	Before you start installing Home Assistant Supervised, you will need to update the operating system. Enter this command, and press enter.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```

**1.19)**	Once this has completed, you will need to find the IP address of the machine. You can do this by checking your router, or by typing this command into the terminal.

```
ip a
```

You should now see some information on your screen showing network configuration. You are looking for information like `inet 192.168.1.150/24`, or, `inet 10.1.1.50/24` depending on your network setup. This is the IP of the machine and you can now use this to connect to the machine from another PC.
</details>

## Section 2 – Install Home Assistant Supervised

With Debian installed, you can move on to installing Home Assistant Supervised.

**2.1)** First you will start by updating the Debian OS to make sure all the latest updates and security patches are installed. To do this, log into the terminal of your machine, enter the following command and press enter.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```

Depending on the speed of your internet connection, this could take anywhere from 30 seconds to 20 minutes to complete. When finished, you will see the prompt.

**2.2)** Now the operating system is up to date, you can install Home Assistant Supervised. Enter each line of the below commands into the terminal and execute them one at a time.

```
sudo -i

apt-get install -y software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq network-manager

systemctl disable ModemManager

systemctl stop ModemManager

curl -fsSL get.docker.com | sh

curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | bash -s
```

**2.3)** The installation time is generally under 5 mins, however it can take longer so be patient. You can check the progress of Home Assistant setup by connecting to the IP address of your machine in Chrome/Firefox on port 8123. (e.g. http://192.168.1.150:8123) 

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document *Backing up and Restoring your configuration.*

You have completed the installation of Home Assistant Supervised on your Debian machine. It is recommended that you log into your machine at least once a month and use the following command to download security patches and keep the OS up to date.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove –y
```

You can do this directly on the machine itself, or, if you wish to install Open-SSH so you can remotely connect to your Home Assistant machine from another PC, run the following from console. 

```
sudo apt install openssh-server -y
```

:warning: If you install Open-SSH you will not be adhering to the guidelines of [ADR-0014](https://github.com/home-assistant/architecture/blob/master/adr/0014-home-assistant-supervised.md) and therefore will not have an officially supported installation, however, installing Open-SSH will not break your machine. If you do choose to install and use Open-SSH, you can then use software called PuTTY, available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

Putty is a free and open-source terminal emulator, serial console and network file transfer application. You can use Putty to execute commands on the Debian machine from your Windows PC. (Use Terminal on a Mac). To connect to the Debian machine via Putty, you will need the IP of the machine from Step 1.19, and the username and password you created from Step 1.10.

If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to Home Assistant website on backing up and restoring your configuration, located [HERE](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui). 

## Section 3 - Install OS Agent

This is the OS Agent for Home Assistant. It is used for Home Assistant OS and Home Assistant Supervised installation types and it allows the Home Assistant Supervisor to communicate with the host operating system.

**3.1)** Connect to your machine via SSH using Putty, then run the following commands.

```
sudo apt --fix-broken install
sudo apt-get install udisks2 wget
cd /usr/local/src
```

**3.2)** Visit the OS Agent page and then replace the version number with the latest available, into the commands below. *(i.e. replace all references to 1.2.0 with the latest available)*

https://github.com/home-assistant/os-agent/releases/tag/1.2.0


```
sudo wget https://github.com/home-assistant/os-agent/releases/download/1.2.0/os-agent_1.2.0_linux_x86_64.deb
dpkg -i os-agent_1.2.0_linux_x86_64.deb
sudo reboot
```
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
I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements.

Thank you to [nickrout](https://community.home-assistant.io/u/nickrout/) for testing, feedback and edits to help improve this guide and to others who have contributed code and ideas, you support is appreciated.
