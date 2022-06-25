# Installing Home Assistant OS using Proxmox 7 

This guide will help you to install Home Assistant, on almost any x86/64 machine type you choose using Proxmox as the operating system. This guide has been tested on machines including a Dell Optiplex SFF 990, Dell Optiplex USFF 780 and a HP T520 thin client.

This guide also utilizes scripts to simplify the installation process, always remember to use due diligence when sourcing scripts and automation tasks from third-party sites. If you wish to view the source code of the scripst used in this guide a link is available at the bottom.

This installation uses an **Official KVM Image provided by the Home Assistant Team and is considered a supported installation method**. This method of installation is considered easy/medium difficulty and some knowledge of how to use and interact with Linux is suggested.

If you have an existing Home Assistant installation and would like to know how to backup your current configuration to restore later, please see the documentation on [backing up and restoring your configuration](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui) as well as some additional information [HERE](https://github.com/Kanga-Who/home-assistant/blob/master/Backup%20and%20restore%20your%20config.md).

## Section 1 - Installing Proxmox VE 7

1.1) You will want to ensure **UEFI Boot & Virtualisation is enabled and Secure Boot is disabled** in the [bios](https://www.lifewire.com/how-to-enter-bios-2624481) of your machine.

1.2) Download the [Proxmox VE 7.x ISO Installer](https://www.proxmox.com/en/downloads/category/iso-images-pve).

1.3) You will now need to make a bootable USB drive using [balenaEtcher](https://www.balena.io/etcher/). Using a USB drive of at least **8gb**, insert it into your PC, open Etcher, select the Proxmox VE image you just downloaded, select your USB drive, then click Flash.

1.4) Insert the bootable USB drive you just made into the machine you wish to install Proxmox VE on. Connect a monitor, Ethernet cable, keyboard, mouse, and power on the machine. If the machine doesn't boot from the USB drive automatically, you will need to enter the boot options menu by pressing Esc, F2, F10 or F12, (This relies on the company of the computer or motherboard) on your keyboard immediately when the machine is powering on. 

1.5) When you see the first screen, select Install Proxmox VE and press Enter. The installer will perform some automated tasks for 1-2 minutes.

1.6) On the EULA screen, select, I Agree.

1.7) On the Proxmox Virtualization Environment (PVE) screen, you will get the option to choose which disk you want to install Proxmox VE on. When finished, click Next.

1.8) On the Location and Time Zone selection, Type your country, then select your time zone and change the keyboard layout if needed. When finished, click Next

1.9) On the Administration password and E-mail address screen, choose a password (**make sure you don’t forget it**), confirm your password and enter a valid email address. When finished, click Next

1.10) On the Management network configuration screen.
   * Management interface Should auto populate with the network interface (Ethernet) of your machine. If not, select the network interface.
   * Hostname (FQDN) - The first part of the hostname is what your node will be called under Datacenter, you might want to change this to something more friendly now, the default is “pve” (eg. proxmox.lan).
   * IP Address - Should auto populate. If the IP address looks odd here and not at all like the address range of your other devices, it’s possible you may not be connected to your network, so check your network cable and start again.
   * Netmask - Should auto populate and be something like `255.255.255.0` depending on your network configuration.
   * Gateway - Should auto populate to the IP address of your router. If not, make sure you're connected to your network
   * DNS server - Should auto populate to the same IP address as your gateway. Or, input one of your choosing. When finished, click Next

1.11) Next on the Summary screen, confirm that all of the details are correct. When confirmed click Install.

Proxmox VE will install and is finished once it displays its IP address on the screen. **Take note of the IP address!** It's needed to access Proxmox via a web browser. Remove the USB drive, and click Reboot. While the machine is rebooting, you can unplug the monitor, keyboard and mouse, as they're no longer needed.

1.12) After 1-2 minutes, you should be able to access Proxmox VE via a web browser using the noted IP address from above (eg. `http://192.168.1.10:8006`) If you see a message "Warning: Potential Security Risk Ahead", you can safely ignore this, accept the risk and continue. Login with User name: `root` and the password you created on the Administration password and E-mail address screen. 

## Section 2 - Configuring and Updating Proxmox VE 7

Before installing Home Assistant OS, you will want to make sure that Proxmox VE has the latest updates and security patches installed. This has been made very simple with a [script](https://github.com/tteck/Proxmox/raw/main/misc/post-install-v3.sh) by @tteck

2.1) To run the Proxmox VE 7 Post Install script, copy and paste the following command in the Proxmox Shell.
```
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-install-v3.sh)"
```
It's recommended to answer `y` to all questions.

## Section 3 - Installing Home Assistant OS

Installing Home Assistant OS using Proxmox VE has been made very simple with a [script](https://github.com/tteck/Proxmox/raw/main/vm/haos-vm-v3.sh) by @tteck

3.1) To run the Home Assistant OS VM install script, copy and paste the following command in the Proxmox Shell.

```
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm-v3.sh)"
```
3.2) It's recommended to press [ENTER] to use the default settings. (Advanced settings are available for changing settings such as mac, bridge, vlan, ect...) It will then download the Official KVM Image from the Home Assistant github and configure it in Proxmox VE for you. This will take 2-20 minutes depending on your internet connection and machine.

Once this has finished, you will see **✓ Completed Successfully!**.

3.3) The Home Assistant OS VM will be assigned a different IP address than the one Proxmox VE is using. To find the IP address of the newly created Home Assistant OS VM, click on the VM (eg. haos8.2) then click Summary from the menu list, wait for Guest Agent to start. The IP address listed here is needed to access Home Assistant via a web browser using port 8123 (eg. `http://192.168.1.50:8123`).

Once you can see the login screen, the setup has been completed and you can set up an account name and password. If you are new to Home Assistant you can now configure any smart devices that Home Assistant has automatically discovered on your network. If you have an existing Home Assistant install and you have a snapshot or YAML files you wish to restore, refer to Home Assistant website on backing up and restoring your configuration, located [HERE](https://www.home-assistant.io/common-tasks/supervised/#making-a-backup-from-the-ui) as well as some additional information [HERE](https://github.com/Kanga-Who/home-assistant/blob/master/Backup%20and%20restore%20your%20config.md)

I welcome feedback on this guide, please feel free to tag me or PM if you have suggestions on how to make improvements. Scripts provided by @tteck. These and other helpful information can be found at https://github.com/tteck/Proxmox
