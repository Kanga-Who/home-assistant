## Installing Home Assistant OS using Proxmox 7 ##

This guide will help you to install Home Assistant, on almost any x86/64 machine type you choose using Proxmox as the operating system. This guide has been tested on machines including a Dell Optiplex SFF 990, Dell Optiplex USFF 780 and a HP T520 thin client.

This installation uses an official image provided by the Home Assistant team and is considered a supported installation method. This method of installation is considered medium difficulty and some knowledge of how to use and interact with Linux is required. Many thanks to @tteck for his edits to this guide and excellent scripts and other helpful information, available [HERE](https://github.com/tteck/Proxmox).

What is Home Assistant?

Home Assistant is a full UI managed home automation ecosystem that runs Home Assistant Core, the Home Assistant Supervisor and add-ons. It comes pre-installed on Home Assistant OS, but can be installed on any Linux system. It leverages Docker, which is managed by the Home Assistant Supervisor plus the added benefit of dozens of add-ons (think app store) that work natively inside the Home Assistant environment.

If you are new to Home Assistant, you can now proceed to Section 1. If you have an existing Home Assistant installation and need to know how to back up your current configuration, please see the documentation on backing up and restoring your configuration, located [HERE](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui).

### Section 1 – **Install Proxmox** ###

1.1) You will want to ensure UEFI Boot & Virtualisation is enabled and Secure Boot is disabled in the bios of your machine.

1.2) Download Proxmox VE 7.x ISO Installer from [HERE](https://www.proxmox.com/en/downloads/category/iso-images-pve)

1.3) You will now need to make a bootable USB drive using balenaEtcher, available [HERE](https://www.balena.io/etcher/). Use a USB drive of at least 8gb. Insert the blank USB drive into your PC, open Etcher, select the Proxmox image you have just downloaded, select your USB drive, then click Flash.

1.4) Insert the USB you have just made into the new machine, connect a monitor, Ethernet cable, keyboard, mouse, and power on the machine. You will need to select the USB drive as the boot device, to do this, you will need to press something like F12 or DEL on your keyboard immediately when the machine is powered on.

1.5) When you see the first screen, select Install Proxmox VE, press Enter. The installer will perform some automated tasks for 1-2 mins.

1.6) Next on the EULA screen, select, I Agree.

1.7) Next on the Proxmox Virtualization Environment (PVE) screen, select the drive you wish to use from the box at the bottom of the screen, then click Next.

1.8) Next on the Location and Time Zone selection, Type your country, then select your time zone and change the keyboard layout if needed, then click Next

1.9) Next on the Administration password and E-mail address screen, choose a password, confirm your password and enter a valid email address.

1.10) Next on the Management network configuration screen.

- Management interface should already be populated with the Ethernet controller of your machine, if not, select the Ethernet controller
- Hostname (FQDN) - Type a hostname in this box, you could use something like, proxmox.local, hass.info, or haserver.ddns.
- IP Address - you can choose an IP for your machine, if you have a specific IP you wish to use on your network, enter this now
- Netmask - should auto populate and be something like `255.255.255.0` depending on your network configuration.
- Gateway - this is (normally) the IP of your router, this should auto populate with the correct info, if it does not, enter the IP of your router
- DNS server - you can leave this at the default on your network (normally the same IP as your router), or input one of your choosing like a Google DNS server `8.8.8.8` or a Cloudflare DNS server like `1.1.1.1`.

1.11) Next on the Summary screen, confirm all the details are correct, then click Install. This process can take anywhere from 2 -20min depending on your machine.

Once the installation is complete, take note of the IP information on screen, remove the USB drive, and click Reboot. While the reboot is taking place, you can now unplug the monitor, keyboard and mouse from your machine as they are no longer needed.

After 1-2 minutes, you should be able to access Proxmox at `https://MACHINE_IP:8006`. If you see a message like Warning: Potential Security Risk Ahead, you can safely ignore this, accept the risk and continue.

### Section 2 - **Configure and Update Proxmox** ###

2.1) Before configuring anything in the Proxmox interface, you will start by updating the Proxmox OS to make sure all the latest updates and security patches are installed. This has been made very simple with scripts created by @tteck.

To run the Proxmox VE 7 Post Install script, copy and paste the following command into the Proxmox Shell.

<sub>Always remember to use due diligence when sourcing scripts and automation tasks from third-party sites.</sub>
```
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-install-v3.sh)"
```
It's recommended to answer `y` to all questions.

### Section 3 - **Installing Home Assistant** ###

3.1) To run the Home Assistant OS VM install script, copy and paste the following command into the Proxmox Shell.

<sub>Always remember to use due diligence when sourcing scripts and automation tasks from third-party sites.</sub>
```
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm-v3.sh)"
```
Unless you have some specific need not to use the default settings (Image, vCPU, RAM, MAC, VLAN, ect...) press [Enter] for default settings. This will download an official image from the Home Assistant website and configure it in Proxmox for you. This will take 2-20mins depending on your internet connection and machine.

Once this has finished, you will see ✓ Completed Successfully!.

3.2) The Home Assistant VM will be assigned a different IP to Proxmox. To find the IP of the Home Assistant install, click on Summary from the menu list, and you should now see a box that shows information such as Status, HA State, CPU and Memory info. The IP listed here is the one needed to access Home Assistant.

You can now enter this IP and port 8123 (eg. `http://192.168.1.150:8123`) in your web browser and check the status of the Home Assistant installation.

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to the document Backing up and Restoring your configuration.

That’s it, you have now installed Home Assistant on your machine using Proxmox.

If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to Home Assistant website on backing up and restoring your configuration, located [HERE](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui).

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements. Scripts provided by @tteck
