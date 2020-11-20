## Installing Home Assistant Supervised on Raspberry Pi OS

This guide will help you to install Home Assistant Supervised on a Raspberry Pi. This guide has been tested on a Raspberry Pi 3b+ and Raspberry Pi 4 4gb, and should also work for other Raspberry Pi's. 

:warning: Please keep in mind that currently **this installation method is not officially supported** by the Home Assistant team, and therefore you are responsible for updating and managing updates and security on the base OS, no official support will be offered. This install method may cease to work at any time, so use at your own risk. If you would like to run an officially supported Supervised install on you Pi, please see [this guide](https://community.home-assistant.io/t/installing-home-assistant-supervised-on-a-raspberry-pi-with-debian-10/247116) using Debian 10 as the OS.

In this guide, you will be using Raspberry Pi OS (formally named Raspbian) as the operating system. This type of installation is what is called “headless” and after the installation is complete, you will not need to have a keyboard, mouse or monitor attached (although you can if you prefer). You will manage and update the machine via terminal commands.

*What is Home Assistant Supervised?*

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to Step 1. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the document  *Backing up and Restoring your configuration* located  [HERE](https://github.com/Kanga-Who/home-assistant/blob/53ac6a3e77e3654a4f5835bde7cef91493cc08a0/Backup%20and%20restore%20your%20config.md)

## Section 1 – Install Raspberry Pi OS

**1.1)** Start by downloading **Raspberry Pi OS (32-bit) Lite** from [HERE](https://www.raspberrypi.org/downloads/raspbian/) (torrent link)

**1.2)** While this is downloading, you will need to format the SD card you wish to use in your Pi. For this installation, you should use an SD card with at least 16gb capacity (32gb is recommended), and one that is rated as Class 10, A1 or A2. If you haven’t yet purchased an SD, or would like some excellent information on SD cards, this YouTube video is worth watching. [Explaining Computers - SD Card Benchmarks](https://www.youtube.com/watch?v=YUResed38uo&t=).

Insert the SD card into your computer and format it. You can do this using the Windows format tool, or a program such as **HP format tool** available from [HERE](https://filehippo.com/download_hp_usb_disk_storage_format_tool/). 

**1.3)** Once the Raspberry Pi OS download has finished, you will write the image to an SD card using software called **balenaEtcher**, available [HERE](https://www.balena.io/etcher/). Insert the SD card into your PC and launch Etcher.

Click **Select Image** and navigate to the location you saved the Raspberry Pi OS image (named something like *2020-05-27-raspios-buster-lite-armhf.zip*), Click **Select Target** and then choose your SD card, and then click **Flash**. Depending on the speed of your SD card this process can take between 2 and 20 minutes to complete.

**1.4)** When Etcher has finished writing Raspberry Pi OS to your SD card, you will need to remove the SD from your computer, and then re-insert it. Once your PC has recognized the SD card, you will navigate to **My Computer/This PC** and you will see a new drive named **boot** listed. Make a note of the drive letter, eg. **D:**

**1.5)** Next you will now create an SSH file so that when you first boot the Pi, you can connect to it from your PC via SSH using a program called PuTTY.

To create the SSH file, press the Windows Key on your keyboard plus the R key **(Windows Key + R)**. This will open a prompt called RUN. In the box type in **cmd** and press Enter. Alternatively, if you are running Windows 10 you can simply type cmd into the search box and select Command Prompt from the menu.

You should now have a terminal window open that will show something like **C:\Users\YourName**. In this window, type in the drive letter of the SD card you noted from Step 1.4 and a colon. It should look like this **D:** then press enter. Next you will copy and paste in this command and press enter.

```
type nul > ssh
```

You have now created the SSH file on your SD card and can now safely eject and remove the SD from your PC.

**1.6.)** Insert the SD card into your Pi, connect an Ethernet cable so the Pi will have a network connection and then the power cord. Wait approx. 2-3 mins, then you can move onto Step 1.7. 

*WiFi is never a recommended option when running any sort of server or automation environment like Home Assistant, so this guide will not cover how to use WiFi.*

**1.7.)** You will now connect via SSH to run commands on the Pi from your PC. Check your router for the IP address of your Pi. 

To connect to your Pi via SSH you will use a piece of software called PuTTY, available [HERE](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). Putty is a free and open-source terminal emulator, serial console and network file transfer application. You will use Putty to execute commands on the Ubuntu machine from your Windows PC. (Use Terminal on a Mac).

Open Putty and in the HOST NAME (OR IP ADDRESS) box, enter the IP of your Pi, then select OPEN. You will now be prompted to enter your username and password. The default username is pi and the default password is raspberry. 

Next you will run the Raspberry Pi Configuration utility. Copy and paste this into the Putty/terminal window 

```
sudo raspi-config
```

**1.8)** Firstly, select **Option 1** and press to Enter to change the default password. Type a new password when prompted and press Enter. This new password will be what you use to log into the Pi in the future, so make a note of it.

**1.9)** Next using your arrow keys, select **Option 4** and press Enter and then select Change Timezone and press enter. Using the arrow keys, select your Geographical area, press Enter, and then select your City/Region from the provided list and press Enter.

**1.10)** Next you will select **Option 7** Advanced Options, and then select Option **A1 – expand file system**, and press Enter. Once this has been completed, you can use the arrow keys to navigate to Finish. When you are asked if you would like to reboot, select Yes. The Pi will now reboot. Wait approx. 2 mins, then move onto Step 1.11.

**1.11)** Next you will now update your Pi to ensure it has the latest OS and security updates that are available. You will need to reconnect via SSH using Putty as you did earlier, and log in using the username **pi** and the new password you created in Step 1.8. Once logged in, copy and paste this command and press Enter.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```

Depending on your network connection, this could take anywhere from 1 to 20 minutes, so be patient. When it has completed, you can reboot the Pi using this command.

```
sudo reboot
```

## Section 2 – Install Home Assistant Supervised

Now that you have Raspberry Pi OS installed, you can move on to installing Home Assistant Supervised. Connect to you Pi using Putty as you have previously using the IP of the Pi, the user name **pi** and the password you set in Step 1.8.

**2.1)** Copy each line of the below commands one at a time and paste them into the Putty window, and press ENTER. One of the following commands will execute a shell script as root, and some people may be concerned with the security risk. If you would like to read the script for piece of mind, click [HERE](https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh)
```
sudo -i

apt-get install -y software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq network-manager

systemctl disable ModemManager

systemctl stop ModemManager

curl -fsSL get.docker.com | sh

curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | bash -s -- -m raspberrypi3
```

If you are using a Raspberry Pi 4, then replace `raspberrypi3` with `raspberrypi4` at the end of the last command.

**2.2)** On a Raspberry Pi 3 the installation time is approx 15 mins, however it can take longer so be patient. You can check the progress of Home Assistant setup by connecting to the IP address of your machine in Chrome/Firefox on port 8123. (e.g. http://192.168.1.150:8123) 

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document *Backing up and Restoring your configuration.*

That’s it, you have now installed Home Assistant Supervised on your Raspberry Pi and have SSH access to keep it up to date. It is recommended that you log into the Pi using Putty at least once a month and use the following command to download security patches and keep the OS up to date.

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```
Along with this guide, there is also associated documents available. These are essentially guides I use myself.

- [Install Samba, Portainer and MQTT on Ubuntu or Debian](https://github.com/Kanga-Who/home-assistant/blob/7aa3f36037288a945c6cb06254effc2b46fdd8f3/Install%20Samba%2C%20Portainer%20and%20MQTT.md)
- [Backing up and Restoring your configuration](https://github.com/Kanga-Who/home-assistant/blob/7aa3f36037288a945c6cb06254effc2b46fdd8f3/Backup%20and%20restore%20your%20config.md)

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements.

Thank you to [nickrout](https://community.home-assistant.io/u/nickrout/) for testing, feedback and edits to help improve this guide.

:exclamation: This guide has also been tested using a USB SSD as the boot drive. You can replace the SD card with an SSD+USB enclosure but your success with this may vary, and using an SSD has not been covered as part of this guide, and no support will be offered. To see a list of adapters known to be working on a Raspberry Pi 3 and 4, click [HERE](https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/):exclamation:
