## Section 1 – Backing up your configuration

In this section, you will learn how to save a snapshot and backup the configuration files and folders from your Home Assistant machine. To do this, you will use a program called WinSCP available [HERE](https://winscp.net/eng/docs/guide_install). Download and install WinSCP and then move on. If you are not using a version of Home Assistant with the Supervisor, skip step 1.1 and move on to 1.2.

**1.1)** Log in to your existing Home Assistant, navigate to the Supervisor section and click on the Snapshots tab. Enter a name for your snapshot, todays date is a good name, and click CREATE. This may take a few minutes, so be patient. When this process is finished, you will see your snapshot appear and you can click on it and download.

You can now use this snapshot to restore your configuration on a new install following Section 2a. It is also a good idea to make a backup of your YAML files for safe keeping. You can do this in the next step.

**1.2)** To manually backup your files and folders from any version of Home Assistant, you will use [WinSCP](https://winscp.net/eng/docs/guide_install) to connect to the current Home Assistant machine and copy and paste to your PC. Open WinSCP on your PC. Under HOST NAME enter the IP of the Ubuntu machine, leave PORT NUMBER at 22, enter the username and password you created when installing the OS to your machine, and then select LOGIN. If you are prompted with a security window, select YES to continue.

- If you are currently using *Home Assistant Supervised*, your files are located at `/usr/share/hassio/homeassistant`
- If you are currently using *Home Assistant Core*, your files are located at `/home/USERNAME/.homeassistant`
- If you are currently using *Home Assistant Container*, your files are located at `/home/USERNAME/homeassistant`
- If you are currently using *Home Assistant OS* on a Pi, other SBC or in a VM, your files are located at `/config`

**1.3)** When you have located your config files, you can copy and paste them to your desktop. It is not necessary to back up the `home-assistant_v2.db` file as this can be very large and is not needed for backup purposes. Make sure to also backup you `www` and `custom_components` folders, if you have them.

You will also want to make a backup of the hidden `.storage` folder. To enable WinSCP to see this folder, you will need to do the following. In WinSCP, click on *Options – Preferences – Panels – Remote*, and make sure to check the box for *Show Inaccessible Directories*.

## Section 2a – Restore a Snapshot

In this section, you will learn how to restore a snapshot you have taken from another Home Assistant machine.

**2.1a)** Open WinSCP on your PC. Under HOST NAME enter the IP of the Ubuntu machine, leave PORT NUMBER at 22, enter the username and password and then select LOGIN. If you are prompted with a security window, select YES to continue.

**2.2a)** If you have an existing snapshot from a previous Home Assistant you wish to restore, you can now navigate to `/usr/share/hassio/backup` in the right side window of WinSCP. Use the *up folder* icon to navigate back to root.

You can now navigate to the location on your PC where saved your previous snapshot and drag-and-drop it into the backup folder. If you get a permission error, you will need to connect to the machine using Putty and execute the follow command to give the correct permission access.

```
sudo chmod -R 777 /usr/share/hassio/backup
```

**2.3a)** Once you have copied the snapshot into the `/usr/share/hassio/backup` folder, you can go back to the Home Assistant web interface, and navigate to the Supervisor section, click on the Snapshots tab and click the refresh icon on the top right of the screen. You should see your snapshot appear and can now restore it. You machine will now take some time to restore and will reboot Home Assistant. This process normally takes about 5-10 minutes.

## Section 2b – Restore YAML files and folders

In this section, you will learn how to restore YAML files and folders you have backed up from another Home Assistant machine. To do this, you will use a program called WinSCP available HERE. Download and install WinSCP and then move on.

**2.1b)** To manually restore your files and folders from any previous version of Home Assistant, you will use WinSCP to connect to your Home Assistant machine and copy and paste the files from your PC to the Home Assistant machine. Open WinSCP on your PC. 

Under HOST NAME enter the IP of the Ubuntu machine, leave PORT NUMBER at 22, enter the username and password you created when installing the OS to your machine, and then select LOGIN. If you are prompted with a security window, select YES to continue.

**2.2b)** Navigate to `/usr/share/hassio/homeassistant`. This is the standard storage location for all user configuration, YAML and custom folders.

**2.3b)** You can now navigate to the location you have saved your backup files on your PC and drag-and-drop them into the /homeassistant folder. If you get a permission error, you will need to connect to the machine using Putty and execute the follow command to give the correct permission access.

```
sudo chmod -R 777 /usr/share/hassio/homeassistant
```

**2.4b)** Once you have finished copying back your files, you can restart Home Assistant for the changes to take effect.
