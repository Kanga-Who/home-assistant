#!/bin/bash

systemctl status ModemManager | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        systemctl disable ModemManager > /dev/null
	systemctl stop ModemManager > /dev/null
fi
