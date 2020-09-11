#!/usr/bin/env bash

    if command_exists docker
        then
            echo "Docker-CE is already installed"
            
        else
            echo "Docker-ce is not present - installing now"  
            curl -fsSL get.docker.com | sh
    fi
