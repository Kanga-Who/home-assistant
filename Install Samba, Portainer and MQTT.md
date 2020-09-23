In this guide, you will learn how to install Samba for network file sharing, Portainer to help manage and troubleshoot your Docker containers and install an MQTT server. You do not need to install all, or even any of these programs as Home Assistant will run perfectly without them and they can also all be installed from within the Home Assistant Supervisor.

The advantage of installing these particular pieces of software outside of the Home Assistant Supervisor is that if you have an issue with Home Assistant not starting, you can still access your files via your network and access the Home Assistant Docker containers to get logs and help troubleshoot problems.

## Section 1 – Install Portainer

**1.1)** Connect to your machine using Putty.

**1.2)** Copy and paste this command into the Putty window and execute. You can paste into Putty by right clicking your mouse.

```
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

**1.3)** Once installed, you will be able to access Portainer at `http://MACHINE_IP_ADDRESS:9000`. When you first log in, you will be presented with a screen that will ask you for a username, and password. Enter these, then click Create User. On the next screen, select Local and then Connect. You will now be able to click on the Containers tab on the side to view you installed containers.

## Section 2 – Install Samba

**2.1)** Connect to your machine using Putty.

**2.2)** Copy and paste this command into the Putty window and execute. You can paste into Putty by right clicking your mouse.

```
sudo apt install samba -y
```

**2.3)** Now you will edit the standard Samba configuration file. To access it, execute the following command

```
sudo nano /etc/samba/smb.conf
```

**2.4)** You will now see the contents of the Samba configuration file. You need to delete the contents of this by pressing and holding CTRL+K until all text has been removed.

**2.5)** Now the file is blank, copy and paste in the following configuration. Once you have done this, press CTRL+X to save.

```
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = HomeAssistant
security = user
map to guest = bad user
name resolve order = bcast host
dns proxy = no
bind interfaces only = yes

[Public]
path = /usr/share/hassio
writable = yes
guest ok = yes
guest only = yes
read only = no
create mode = 0777
directory mode = 0777
force user = nobody
create mask = 0777
directory mask = 0777
force user = root
force create mode = 0777
force directory mode = 0777
hosts allow =
```

**2.6)** You will now need to create a username and password to log into Samba.

```
sudo smbpasswd -a USERNAME_OF_YOUR_CHOICE
```

**2.7)** You will then be prompted to enter a password twice. Choose a password you can easily remember and make a note of it. Now you can restart the samba service and immediately access our files from another machine on our local network.

```
sudo service smbd restart
```

You will now be able to access you Home Assistant files from another machine on your network via Samba, making it easy to copy and paste your configuration to keep a backup.

## Section 3 – Install an MQTT broker

What is an MQTT broker? An MQTT broker is a server that receives messages from MQTT clients (switches, lights, sensors etc) and then routes the messages to the appropriate destination. An example of how MQTT is used in Home Assistant is HERE.

**3.1)** Connect to your machine using Putty.

**3.2)** Copy and paste the following commands into the Putty one at a time, and execute. You can paste into Putty by right clicking your mouse.

```
sudo apt-get update && sudo apt-get upgrade -y

sudo apt install mosquitto -y && sudo apt install mosquitto-clients -y

sudo nano /etc/mosquitto/conf.d/mosquitto.conf
```

**3.3)** You should now have a blank MQTT configuration file open. Copy and paste in the following information, once you have done this, press CTRL+X to save.

```
allow_anonymous false
password_file /etc/mosquitto/conf.d/pwfile
port 1883
```

**3.4)** You will now need to set a username and password. User the following command to do this.

```
sudo mosquitto_passwd -c /etc/mosquitto/conf.d/pwfile USERNAME_OF_YOUR_CHOICE
```

**3.5)** You will be prompted to enter a password. Keep note of both the username and password as this is the information you will use to connect your MQTT devices to Home Assistant.

**3.6)** Restart the MQTT service with the following command.

```
sudo service mosquitto restart
```

**3.7)** Next you will need to add some information into your Home Assistant configuration.yaml file so your MQTT broker can talk to Home Assistant. Copy and paste this command into Putty, and execute.

```
sudo nano /usr/share/hassio/homeassistant/configuration.yaml
```

**3.8)** Using the arrow keys on your keyboard, arrow down to the bottom of this file and paste in the following information, making sure to preserve the formatting. Once you have done this, CTRL+X to save and then restart Home Assistant.

```
mqtt:
  discovery: true
  discovery_prefix: homeassistant
  broker: IP_OF_YOUR_MACHINE (eg: 192.168.1.150)
  port: 1883
  client_id: home-assistant-1
  keepalive: 60
  username: YOUR_MQTT_USERNAME
  password: YOUR_MQTT_PASSWORD
```
