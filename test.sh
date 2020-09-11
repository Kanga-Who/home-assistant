#!/usr/bin/env bash

if systemctl list-unit-files ModemManager.service | grep enabled; then

	sudo systemctl disable ModemManager > /dev/null
        sudo systemctl stop ModemManager > /dev/null
fi
