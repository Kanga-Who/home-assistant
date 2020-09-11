#!/usr/bin/env bash

    if command -v docker > /dev/null 2>&1 then
        echo "Docker-ce is not present - installing now"  
        curl -fsSL get.docker.com | sh
    fi
